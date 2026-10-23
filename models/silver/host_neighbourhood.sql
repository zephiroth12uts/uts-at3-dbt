/*
    Silver model: host_neighbourhood

    Purpose:
    - Standardise host neighbourhood values.
    - Preserve the date on which each neighbourhood value was observed.
    - Support the later transformation of host neighbourhoods into LGAs.
*/

select distinct
    scraped_date,
    upper(nullif(trim(host_neighbourhood), '')) as host_neighbourhood

from {{ ref('airbnb_listings') }}

where nullif(trim(host_neighbourhood), '') is not null