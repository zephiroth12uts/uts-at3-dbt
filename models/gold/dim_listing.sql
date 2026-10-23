/*
    Gold dimension: listing

    SCD Type 2 listing dimension.
    Each historical listing version receives its own surrogate key.
*/

select
    md5(
        concat_ws(
            '||',
            listing_id::text,
            dbt_valid_from::text
        )
    ) as listing_key,

    listing_id,
    host_id,
    listing_neighbourhood,

    dbt_valid_from as valid_from,
    dbt_valid_to as valid_to

from {{ ref('listing_snapshot') }}