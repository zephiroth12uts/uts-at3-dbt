/*
    Silver model: census_g02

    Purpose:
    - Standardise the Census G02 median and average measures.
    - Preserve demographic and household metrics required for downstream analysis.
    - Derive a numeric LGA code from the ABS-prefixed source identifier.

    Example:
        LGA10050 -> 10050
*/

with source_data as (

    select
        lga_code_2016,
        median_age_persons,
        median_mortgage_repay_monthly,
        median_tot_prsnl_inc_weekly,
        median_rent_weekly,
        median_tot_fam_inc_weekly,
        average_num_psns_per_bedroom,
        median_tot_hhd_inc_weekly,
        average_household_size

    from {{ source('bronze', 'census_g02') }}

),

cleaned as (

    select
        lga_code_2016,

        replace(
            upper(trim(lga_code_2016)),
            'LGA',
            ''
        )::integer as lga_code,

        median_age_persons,
        median_mortgage_repay_monthly,
        median_tot_prsnl_inc_weekly,
        median_rent_weekly,
        median_tot_fam_inc_weekly,
        average_num_psns_per_bedroom,
        median_tot_hhd_inc_weekly,
        average_household_size

    from source_data

)

select
    lga_code_2016,
    lga_code,
    median_age_persons,
    median_mortgage_repay_monthly,
    median_tot_prsnl_inc_weekly,
    median_rent_weekly,
    median_tot_fam_inc_weekly,
    average_num_psns_per_bedroom,
    median_tot_hhd_inc_weekly,
    average_household_size

from cleaned