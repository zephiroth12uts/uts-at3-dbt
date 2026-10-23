/*
    Silver model: room_type

    Purpose:
    - Provide a standardised reference entity for Airbnb room types.
    - Remove blank values and unnecessary surrounding whitespace.
*/

select distinct
    nullif(trim(room_type), '') as room_type

from {{ ref('airbnb_listings') }}

where nullif(trim(room_type), '') is not null