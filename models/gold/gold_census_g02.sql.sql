/*
    Gold reference table: Census G02

    2016 Census selected medians and averages enriched with
    the standardised NSW LGA name.
*/

select
    c.lga_code,
    l.lga_name,
    c.lga_code_2016,
    c.median_age_persons,
    c.median_mortgage_repay_monthly,
    c.median_tot_prsnl_inc_weekly,
    c.median_rent_weekly,
    c.median_tot_fam_inc_weekly,
    c.average_num_psns_per_bedroom,
    c.median_tot_hhd_inc_weekly,
    c.average_household_size

from {{ ref('census_g02') }} c

left join {{ ref('lga') }} l
    on c.lga_code = l.lga_code