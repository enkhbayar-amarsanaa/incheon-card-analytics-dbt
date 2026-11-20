with source_listings as (
    select * from {{ source('airbnb', 'listing') }}
)

select
    id as listing_id,
    listing_url,
    name as listing_name,
    room_type,
    minimum_nights,
    host_id,
    price as price_str,
    created_at,
    updated_at
from source_listings