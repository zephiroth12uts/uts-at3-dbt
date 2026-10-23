/*
    Gold dimension: property type
*/

select
    md5(property_type) as property_type_key,
    property_type

from {{ ref('property_type') }}