/*
    Silver model: property_type

    Purpose:
    - Provide a standardised reference entity for property types.
    - Remove blank values and unnecessary surrounding whitespace.
*/

select distinct
    nullif(trim(property_type), '') as property_type

from {{ ref('airbnb_listings') }}

where nullif(trim(property_type), '') is not null