with staging_hosts as (
    select * from {{ ref('stg_hosts') }}
)

select
    host_id,
    coalesce(host_name, 'Anonymous') as host_name,
    is_superhost,
    created_at,
    updated_at
from staging_hosts