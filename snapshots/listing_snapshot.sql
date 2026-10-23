/*
    SCD Type 2 snapshot: listing

    Tracks changes to listing relationships and neighbourhood attributes
    using the monthly Airbnb scrape date.
*/

{% snapshot listing_snapshot %}

{{
    config(
        target_schema='silver',
        unique_key='listing_id',
        strategy='timestamp',
        updated_at='scraped_date'
    )
}}

select
    listing_id,
    scraped_date,
    host_id,
    listing_neighbourhood

from {{ ref('listing') }}

{% endsnapshot %}