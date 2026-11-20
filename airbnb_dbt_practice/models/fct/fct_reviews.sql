with staging_reviews as (
    select * from {{ ref('stg_reviews') }}
)

select
    listing_id,
    review_date,
    reviewer_name,
    review_text,
    sentiment as review_sentiment 
from staging_reviews
where review_text is not null