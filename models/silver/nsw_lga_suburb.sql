/*
    Silver model: nsw_lga_suburb

    Purpose:
    - Standardise the relationship between NSW suburbs and LGAs.
    - Remove leading/trailing spaces.
    - Standardise text casing to support reliable joins with other datasets.

    The source CSV contained empty trailing columns that were removed during
    ingestion because they did not contain source data.
*/

with source_data as (

    select
        lga_name,
        suburb_name

    from {{ source('bronze', 'nsw_lga_suburb') }}

),

cleaned as (

    select
        upper(nullif(trim(lga_name), '')) as lga_name,
        upper(nullif(trim(suburb_name), '')) as suburb_name

    from source_data

)

select
    lga_name,
    suburb_name

from cleaned