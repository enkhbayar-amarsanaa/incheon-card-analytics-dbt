{% snapshot scd_raw_hosts %}

{{
    config(
      target_database='AIRBNB',
      target_schema='DEV',
      unique_key='id',
      strategy='timestamp',
      updated_at='updated_at',
    )
}}

select * from {{ source('airbnb', 'hosts') }}

{% endsnapshot %}