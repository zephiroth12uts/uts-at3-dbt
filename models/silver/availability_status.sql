/*
    Silver model: availability_status

    Purpose:
    - Standardise the listing availability flag into a reference entity.
    - Support the active/inactive listing logic required by the datamarts.
*/

select distinct
    has_availability

from {{ ref('airbnb_listings') }}

where has_availability is not null