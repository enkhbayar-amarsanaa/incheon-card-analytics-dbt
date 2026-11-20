{{ config(materialized='table') }}

WITH customer_stats AS (
    SELECT
        customer_id,
        -- Take MAX to get one consistent value per customer
        MAX(visitor_type)                                       AS visitor_type,
        MAX(city)                                               AS city,
        MAX(sex)                                                AS sex,
        MAX(age_group)                                          AS age_group,
        MIN(txn_date)                                           AS first_txn_date,
        MAX(txn_date)                                           AS last_txn_date,
        DATEDIFF('day', MAX(txn_date), '2024-12-31')            AS recency_days,
        DATEDIFF('day', MIN(txn_date), MAX(txn_date))           AS active_span_days,
        COUNT(*)                                                AS frequency,
        SUM(amt)                                                AS monetary,
        AVG(amt)                                                AS avg_transaction_amt,
        COUNT(DISTINCT txn_date)                                AS unique_active_days
    FROM {{ ref('fact_transactions') }}
    GROUP BY customer_id
),

rfm_scored AS (
    SELECT *,
        -- Recency: fewer days since last visit = higher score (ASC = low days first = NTILE 1, flip to 5)
        (6 - NTILE(5) OVER (ORDER BY recency_days ASC))        AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC)                AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC)                 AS m_score
    FROM customer_stats
    WHERE monetary > 0
),

rfm_segmented AS (
    SELECT *,
        r_score + f_score + m_score                             AS rfm_total,
        CONCAT(r_score, '-', f_score, '-', m_score)             AS rfm_score,
        CASE
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
                THEN 'Champion'
            WHEN r_score >= 3 AND f_score >= 4
                THEN 'Loyal Visitor'
            WHEN r_score <= 2 AND f_score >= 4
                THEN 'At Risk - High Value'
            WHEN r_score >= 4 AND f_score <= 2
                THEN 'New Visitor'
            WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3
                THEN 'Potential Loyalist'
            WHEN r_score <= 2 AND f_score >= 2
                THEN 'Lapsed Visitor'
            WHEN r_score = 1 AND f_score <= 2 AND m_score = 1
                THEN 'Lost'
            ELSE 'Occasional Visitor'
        END                                                     AS customer_segment
    FROM rfm_scored
)

SELECT
    customer_id,
    visitor_type,
    city,
    sex,
    age_group,
    first_txn_date,
    last_txn_date,
    recency_days,
    active_span_days,
    unique_active_days,
    frequency,
    ROUND(monetary, 0)                                          AS monetary,
    ROUND(avg_transaction_amt, 0)                               AS avg_transaction_amt,
    r_score,
    f_score,
    m_score,
    rfm_score,
    rfm_total,
    customer_segment
FROM rfm_segmented