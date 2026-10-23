/*
    Gold dimension: accommodates

    Represents listing guest capacity.
*/

select
    md5(accommodates::text) as accommodates_key,
    accommodates

from {{ ref('accommodates') }}