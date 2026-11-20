{{ config(materialized='table') }}

SELECT
    key1,
    blk,
    TRY_TO_DATE(apv_d, 'YYYYMMDD')                      AS txn_date,
    DATE_TRUNC('month', TRY_TO_DATE(apv_d, 'YYYYMMDD')) AS txn_month,
    YEAR(TRY_TO_DATE(apv_d, 'YYYYMMDD'))                 AS txn_year,

    -- Gender
    CASE sex_cd
        WHEN 'M' THEN 'Male'
        WHEN 'F' THEN 'Female'
        ELSE 'Other'
    END AS sex,

    -- Age group (kept as original)
    age_cd AS age_group,

    -- City of residence (full mapping)
    CASE cty_cd
        WHEN '11' THEN 'Seoul'
        WHEN '26' THEN 'Busan'
        WHEN '27' THEN 'Daegu'
        WHEN '28' THEN 'Incheon'
        WHEN '29' THEN 'Gwangju'
        WHEN '30' THEN 'Daejeon'
        WHEN '31' THEN 'Ulsan'
        WHEN '36' THEN 'Sejong'
        WHEN '41' THEN 'Gyeonggi'
        WHEN '42' THEN 'Gangwon'
        WHEN '43' THEN 'Chungbuk'
        WHEN '44' THEN 'Chungnam'
        WHEN '45' THEN 'Jeonbuk'
        WHEN '46' THEN 'Jeonnam'
        WHEN '47' THEN 'Gyeongbuk'
        WHEN '48' THEN 'Gyeongnam'
        WHEN '50' THEN 'Jeju'
        WHEN '51' THEN 'Gangwon'
        WHEN '52' THEN 'Jeonbuk'
        WHEN '99' THEN 'Foreigner'
        ELSE 'Other'
    END AS city,

    -- Merchant category (accurate English translations)
    CASE mkt_cd
        WHEN 'Y01' THEN 'Korean Restaurant'
        WHEN 'Y02' THEN 'Japanese/Chinese/Western Restaurant'
        WHEN 'Y03' THEN 'Cafe/Bakery/Fast Food'
        WHEN 'Y04' THEN 'Other Food & Beverage'
        WHEN 'Y05' THEN 'Bar & Entertainment'
        WHEN 'Y06' THEN 'Department Store & Hypermarket'
        WHEN 'Y07' THEN 'Supermarket'
        WHEN 'Y08' THEN 'Convenience Store'
        WHEN 'Y09' THEN 'Other Retail'
        WHEN 'Y10' THEN 'Grocery & Food Products'
        WHEN 'Y11' THEN 'Fashion & Accessories'
        WHEN 'Y12' THEN 'Sports/Culture/Leisure Activity'
        WHEN 'Y13' THEN 'Sports & Leisure Goods'
        WHEN 'Y14' THEN 'Accommodation'
        WHEN 'Y15' THEN 'Travel & Transportation'
        WHEN 'Y16' THEN 'Beauty & Personal Care'
        WHEN 'Y17' THEN 'Household & Living Services'
        WHEN 'Y18' THEN 'Healthcare & Medical'
        WHEN 'Y19' THEN 'Electronics & Furniture'
        WHEN 'Y20' THEN 'Automotive'
        WHEN 'Y21' THEN 'Gas Station'
        ELSE 'Other'
    END AS category,

    -- Category group (useful for dashboard grouping)
    CASE mkt_cd
        WHEN 'Y01' THEN 'Food & Dining'
        WHEN 'Y02' THEN 'Food & Dining'
        WHEN 'Y03' THEN 'Food & Dining'
        WHEN 'Y04' THEN 'Food & Dining'
        WHEN 'Y05' THEN 'Entertainment'
        WHEN 'Y06' THEN 'Retail'
        WHEN 'Y07' THEN 'Retail'
        WHEN 'Y08' THEN 'Retail'
        WHEN 'Y09' THEN 'Retail'
        WHEN 'Y10' THEN 'Retail'
        WHEN 'Y11' THEN 'Fashion'
        WHEN 'Y12' THEN 'Leisure & Culture'
        WHEN 'Y13' THEN 'Leisure & Culture'
        WHEN 'Y14' THEN 'Travel & Stay'
        WHEN 'Y15' THEN 'Travel & Stay'
        WHEN 'Y16' THEN 'Beauty & Wellness'
        WHEN 'Y17' THEN 'Living Services'
        WHEN 'Y18' THEN 'Healthcare'
        WHEN 'Y19' THEN 'Electronics & Home'
        WHEN 'Y20' THEN 'Automotive'
        WHEN 'Y21' THEN 'Automotive'
        ELSE 'Other'
    END AS category_group,

    -- Visitor type
    CASE
        WHEN cty_cd = '28' THEN 'Incheon Local'
        WHEN cty_cd = '99' THEN 'Foreign Visitor'
        WHEN cty_cd = '*' THEN 'Other'
        ELSE 'Domestic Visitor'
    END AS visitor_type,

    mkt_cd,
    cty_cd,
    sex_cd,
    amt,
    cnt

FROM {{ ref('bronze_transactions') }}
WHERE TRY_TO_DATE(apv_d, 'YYYYMMDD') IS NOT NULL