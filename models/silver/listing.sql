/*
    Silver model: listing

    Purpose:
    - Represent the listing entity independently from fact metrics.
    - Preserve the relationship between listings, hosts and neighbourhoods.
    - Retain the scrape date so historical listing versions can be tracked.
*/

select distinct
    listing_id,
    scraped_date,
    host_id,
    listing_neighbourhood

from {{ ref('airbnb_listings') }}

where listing_id is not null