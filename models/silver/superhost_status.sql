/*
    Silver model: superhost_status

    Purpose:
    - Standardise the host superhost flag into a small reference entity.
    - Preserve the source representation without introducing business metrics.
*/

select distinct
    host_is_superhost

from {{ ref('airbnb_listings') }}

where host_is_superhost is not null