/*
    Silver model: listing

    Purpose:
    - Decompose listing-related attributes from Airbnb listings.
    - Return the most recently observed version of each listing.
    - Prepare the listing entity for SCD Type 2 snapshotting.

    The source data is loaded sequentially by month. scraped_date represents
    when the listing state was observed and is therefore retained as the
    timestamp used by the snapshot strategy.
*/

with ranked_listings as (

    select
        listing_id,
        scraped_date,
        host_id,
        listing_neighbourhood,

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
    host_id,
    listing_neighbourhood

from ranked_listings

where row_num = 1