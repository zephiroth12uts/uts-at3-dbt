/*
    Silver model: nsw_lga_code

    Purpose:
    - Standardise the NSW LGA code reference dataset.
    - Preserve the original LGA code.
    - Remove leading/trailing spaces from LGA names.
*/

with source_data as (

    select
        lga_code,
        lga_name

    from {{ source('bronze', 'nsw_lga_code') }}

),

cleaned as (

    select
        lga_code,
        nullif(trim(lga_name), '') as lga_name

    from source_data

)

select
    lga_code,
    lga_name

from cleaned