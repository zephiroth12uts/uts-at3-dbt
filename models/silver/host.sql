/*
    Silver model: host

    Purpose:
    - Decompose host-related attributes from Airbnb listings.
    - Return the most recently observed version of each host.
    - Prepare the host entity for SCD Type 2 snapshotting.

    The Airbnb dataset is loaded month by month. For each host, only the
    latest available record is exposed by this model. The scraped_date
    column acts as the timestamp used by dbt snapshots to detect newer
    versions of the same host.

    A host may own multiple listings within the same scrape. ROW_NUMBER
    ensures that only one current record per host is presented to the
    snapshot process.
*/

with ranked_hosts as (

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

    from {{ ref('airbnb_listings') }}

    where host_id is not null

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