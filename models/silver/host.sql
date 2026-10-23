/*
    Silver model: host

    Purpose:
    - Decompose host-related attributes from the Silver Airbnb listings model.
    - Produce one host record per scrape date.
    - Prepare the host entity for later SCD Type 2 snapshotting.

    A host can own multiple listings, so the source dataset may contain
    repeated host information for the same scrape date.
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