/*
    Silver model: lga

    Purpose:
    - Create a clean NSW Local Government Area reference entity.
    - Standardise LGA names for joins with suburb and Census datasets.
*/

select distinct
    lga_code,
    upper(nullif(trim(lga_name), '')) as lga_name

from {{ ref('nsw_lga_code') }}

where lga_code is not null