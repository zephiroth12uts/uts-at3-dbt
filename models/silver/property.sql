/*
    Silver model: property

    Purpose:
    - Decompose property characteristics from Airbnb listings.
    - Return the most recently observed property state for each listing.
    - Prepare changing property characteristics for SCD Type 2 snapshotting.

    listing_id is used as the business key because each Airbnb listing
    represents one property configuration at a given observation date.
    scraped_date identifies when that configuration was observed.
*/

with ranked_properties as (

    select
        listing_id,
        scraped_date,
        property_type,
        room_type,
        accommodates,

        row_number() over (
            partition by listing_id
            order by scraped_date desc
        ) as row_num

    from {{ ref('airbnb_listings') }}

    where listing_id is not null

)

select
    listing_id,
    scraped_date,
    property_type,
    room_type,
    accommodates

from ranked_properties

where row_num = 1