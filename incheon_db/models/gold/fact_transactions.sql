-- depends_on: {{ ref('incheon_blk') }}
{{ config(materialized='table') }}

SELECT
    s.key1                          AS customer_id,
    s.blk,
    b.lat,
    b.lon,
    s.txn_date,
    s.txn_month,
    s.txn_year,
    -- DAYOFWEEKISO is independent of the WEEK_START session parameter: 1 = Monday ... 7 = Sunday
    DAYOFWEEKISO(s.txn_date)        AS day_of_week,
    CASE DAYOFWEEKISO(s.txn_date)
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END                             AS day_name,
    CASE
        WHEN DAYOFWEEKISO(s.txn_date) IN (6, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END                             AS week_type,
    s.sex,
    s.age_group,
    s.city,
    s.cty_cd,
    s.visitor_type,
    s.mkt_cd,
    s.category,
    s.category_group,
    s.amt,
    s.cnt
FROM {{ ref('silver_transactions') }} s
LEFT JOIN {{ ref('incheon_blk') }} b
    ON s.blk = b.fid