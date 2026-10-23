/*
    Silver model: property

    Purpose:
    - Decompose property characteristics from Airbnb listings.
    - Preserve property attributes as observed at each scrape date.
    - Prepare changing property characteristics for SCD Type 2 handling.
*/

select distinct
    listing_id,
    scraped_date,
    property_type,
    room_type,
    accommodates

from {{ ref('airbnb_listings') }}

where listing_id is not null