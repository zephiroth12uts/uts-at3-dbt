/*
    Gold dimension: property

    SCD Type 2 dimension containing the historical property
    configuration associated with each Airbnb listing.
*/

select
    md5(
        concat_ws(
            '||',
            listing_id::text,
            dbt_valid_from::text
        )
    ) as property_key,

    listing_id,
    property_type,
    room_type,
    accommodates,

    dbt_valid_from as valid_from,
    dbt_valid_to as valid_to

from {{ ref('property_snapshot') }}