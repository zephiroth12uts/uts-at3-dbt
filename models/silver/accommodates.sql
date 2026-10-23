/*
    Silver model: accommodates

    Purpose:
    - Provide a reference entity for listing guest capacity.
    - Support analysis by accommodation capacity in the Gold layer.
*/

select distinct
    accommodates

from {{ ref('airbnb_listings') }}

where accommodates is not null