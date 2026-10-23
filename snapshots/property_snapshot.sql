/*
    SCD Type 2 snapshot: property

    Tracks historical changes in property type, room type and accommodation
    capacity for each Airbnb listing.
*/

{% snapshot property_snapshot %}

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
    property_type,
    room_type,
    accommodates

from {{ ref('property') }}

{% endsnapshot %}