/*
    Gold dimension: NSW Local Government Area
*/

select
    md5(lga_code::text) as lga_key,
    lga_code,
    lga_name

from {{ ref('lga') }}