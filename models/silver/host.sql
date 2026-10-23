/*
    Silver model: host

    Purpose:
    - Decompose host-related attributes from Airbnb listings.
    - Preserve each observed host state by scrape date.
    - Prepare the host entity for SCD Type 2 snapshotting.

    A host can own multiple listings. DISTINCT prevents duplicate
    host versions within the same scrape period.
*/

select distinct
    host_id,
    scraped_date,
    host_name,
    host_since,
    host_is_superhost,
    host_neighbourhood

from {{ ref('airbnb_listings') }}

where host_id is not null