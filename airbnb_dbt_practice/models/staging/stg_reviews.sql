with source_reviews as (
    select * from {{ source('airbnb', 'reviews') }}
)

select
    date as review_date,
    comments as review_text,
    listing_id,
    reviewer_name,
    sentiment
from source_reviews
