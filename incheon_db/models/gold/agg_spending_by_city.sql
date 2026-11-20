{{ config(materialized='table') }}

SELECT
    txn_month,
    txn_year,
    day_name,
    week_type,
    city,
    cty_cd,
    visitor_type,
    sex,
    age_group,
    category,
    category_group,
    mkt_cd,
    COUNT(*)                        AS transaction_count,
    SUM(amt)                        AS total_amount,
    AVG(amt)                        AS avg_amount,
    COUNT(DISTINCT customer_id)     AS unique_customers
FROM {{ ref('fact_transactions') }}
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12