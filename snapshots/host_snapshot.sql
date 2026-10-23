/*
    SCD Type 2 snapshot: host

    Tracks changes to host attributes over time using scraped_date as the
    source observation timestamp.
*/

{% snapshot host_snapshot %}

{{
    config(
        target_schema='silver',
        unique_key='host_id',
        strategy='timestamp',
        updated_at='scraped_date'
    )
}}

select
    host_id,
    scraped_date,
    host_name,
    host_since,
    host_is_superhost,
    host_neighbourhood

from {{ ref('host') }}

{% endsnapshot %}