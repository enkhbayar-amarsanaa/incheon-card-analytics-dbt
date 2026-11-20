with listings as (
    select * from {{ ref('dim_listings') }}
),

hosts as (
    select * from {{ ref('dim_hosts') }}
)

select
    l.listing_id,
    l.listing_name,
    l.room_type,
    l.minimum_nights,
    l.price_str,
    l.host_id,
    h.host_name,
    h.is_superhost as host_is_superhost, 
    l.created_at,
    l.updated_at
from listings l
left join hosts h 
    on l.host_id = h.host_id