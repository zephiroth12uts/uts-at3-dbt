/*
    Gold dimension: host since date

    Provides calendar attributes describing when an Airbnb host
    originally joined the platform.
*/

select distinct
    to_char(host_since, 'YYYYMMDD')::integer as host_since_date_key,

    host_since,

    extract(year from host_since)::integer as host_since_year,
    extract(month from host_since)::integer as host_since_month

from {{ ref('airbnb_listings') }}

where host_since is not null