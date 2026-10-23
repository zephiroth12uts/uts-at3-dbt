/*
    Silver model: suburb

    Purpose:
    - Create a clean suburb reference entity.
    - Preserve the relationship between suburbs and their corresponding LGAs.
    - Standardise text values to improve downstream joins.
*/

select distinct
    upper(nullif(trim(suburb_name), '')) as suburb_name,
    upper(nullif(trim(lga_name), '')) as lga_name

from {{ ref('nsw_lga_suburb') }}

where nullif(trim(suburb_name), '') is not null