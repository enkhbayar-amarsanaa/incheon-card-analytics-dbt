with snapshot_hosts as (
    select * from {{ ref('scd_raw_hosts') }}
)

select
    id as host_id,
    coalesce(name, 'Anonymous') as host_name,
    is_superhost,
    created_at,
    updated_at
from snapshot_hosts