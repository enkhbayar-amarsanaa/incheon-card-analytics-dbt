{{ config(materialized='table') }}

SELECT
    key1,
    blk,
    apv_d,
    sex_cd,
    age_cd,
    cty_cd,
    mkt_cd,
    amt,
    cnt
FROM {{ source('raw', 'raw_transactions') }}
WHERE key1 IS NOT NULL
  AND apv_d IS NOT NULL