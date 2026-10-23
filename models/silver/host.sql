/*
    Silver model: host

    Purpose:
    - Decompose host-related attributes from Airbnb listings.
    - Return exactly one current record per host.
    - Prepare the host entity for SCD Type 2 snapshotting.

    A monthly Airbnb extract may contain several scrape dates because
    individual listings can be scraped on different days.

    For snapshot purposes, each host must appear only once in the current
    source state. The most recently observed host record is therefore
    selected using scraped_date.
*/

with host_observations as (

    select distinct
        host_id,
        scraped_date,
        host_name,
        host_since,
        host_is_superhost,
        host_neighbourhood

    from {{ ref('airbnb_listings') }}

    where host_id is not null

),

ranked_hosts as (

    select
        host_id,
        scraped_date,
        host_name,
        host_since,
        host_is_superhost,
        host_neighbourhood,

        row_number() over (
            partition by host_id
            order by scraped_date desc
        ) as row_num

    from host_observations

)

select
    host_id,
    scraped_date,
    host_name,
    host_since,
    host_is_superhost,
    host_neighbourhood

from ranked_hosts

where row_num = 1