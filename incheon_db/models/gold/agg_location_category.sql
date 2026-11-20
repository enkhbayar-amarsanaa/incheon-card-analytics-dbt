{{ config(materialized='table') }}

SELECT
    ROUND(lat, 2)                   AS district_lat,
    ROUND(lon, 2)                   AS district_lon,
    MAX(blk)                        AS representative_block,
    txn_month,
    txn_year,
    category,
    category_group,
    mkt_cd,
    visitor_type,
    COUNT(*)                        AS transaction_count,
    SUM(amt)                        AS total_amount,
    AVG(amt)                        AS avg_amount,
    SUM(cnt)                        AS total_cnt,
    COUNT(DISTINCT customer_id)     AS unique_customers,
    COUNT(DISTINCT blk)             AS blocks_in_zone
FROM {{ ref('fact_transactions') }}
WHERE lat IS NOT NULL AND lon IS NOT NULL
GROUP BY 1, 2, 4, 5, 6, 7, 8, 9