/*
    Gold reference table: Census G01

    2016 Census selected person characteristics by sex,
    enriched with the standardised NSW LGA name.
*/

select
    c.lga_code,
    l.lga_name,
    c.lga_code_2016,

    c.tot_p_m,
    c.tot_p_f,
    c.tot_p_p,

    c.age_0_4_yr_m,
    c.age_0_4_yr_f,
    c.age_0_4_yr_p,

    c.age_5_14_yr_m,
    c.age_5_14_yr_f,
    c.age_5_14_yr_p,

    c.age_15_19_yr_m,
    c.age_15_19_yr_f,
    c.age_15_19_yr_p,

    c.age_20_24_yr_m,
    c.age_20_24_yr_f,
    c.age_20_24_yr_p,

    c.age_25_34_yr_m,
    c.age_25_34_yr_f,
    c.age_25_34_yr_p,

    c.age_35_44_yr_m,
    c.age_35_44_yr_f,
    c.age_35_44_yr_p,

    c.age_45_54_yr_m,
    c.age_45_54_yr_f,
    c.age_45_54_yr_p,

    c.age_55_64_yr_m,
    c.age_55_64_yr_f,
    c.age_55_64_yr_p,

    c.age_65_74_yr_m,
    c.age_65_74_yr_f,
    c.age_65_74_yr_p,

    c.age_75_84_yr_m,
    c.age_75_84_yr_f,
    c.age_75_84_yr_p,

    c.age_85ov_m,
    c.age_85ov_f,
    c.age_85ov_p,

    c.counted_census_night_home_m,
    c.counted_census_night_home_f,
    c.counted_census_night_home_p,

    c.count_census_nt_ewhere_aust_m,
    c.count_census_nt_ewhere_aust_f,
    c.count_census_nt_ewhere_aust_p,

    c.indigenous_psns_aboriginal_m,
    c.indigenous_psns_aboriginal_f,
    c.indigenous_psns_aboriginal_p,

    c.indig_psns_torres_strait_is_m,
    c.indig_psns_torres_strait_is_f,
    c.indig_psns_torres_strait_is_p,

    c.indig_bth_abor_torres_st_is_m,
    c.indig_bth_abor_torres_st_is_f,
    c.indig_bth_abor_torres_st_is_p,

    c.indigenous_p_tot_m,
    c.indigenous_p_tot_f,
    c.indigenous_p_tot_p,

    c.birthplace_australia_m,
    c.birthplace_australia_f,
    c.birthplace_australia_p,

    c.birthplace_elsewhere_m,
    c.birthplace_elsewhere_f,
    c.birthplace_elsewhere_p,

    c.lang_spoken_home_eng_only_m,
    c.lang_spoken_home_eng_only_f,
    c.lang_spoken_home_eng_only_p,

    c.lang_spoken_home_oth_lang_m,
    c.lang_spoken_home_oth_lang_f,
    c.lang_spoken_home_oth_lang_p,

    c.australian_citizen_m,
    c.australian_citizen_f,
    c.australian_citizen_p,

    c.age_psns_att_educ_inst_0_4_m,
    c.age_psns_att_educ_inst_0_4_f,
    c.age_psns_att_educ_inst_0_4_p,

    c.age_psns_att_educ_inst_5_14_m,
    c.age_psns_att_educ_inst_5_14_f,
    c.age_psns_att_educ_inst_5_14_p,

    c.age_psns_att_edu_inst_15_19_m,
    c.age_psns_att_edu_inst_15_19_f,
    c.age_psns_att_edu_inst_15_19_p,

    c.age_psns_att_edu_inst_20_24_m,
    c.age_psns_att_edu_inst_20_24_f,
    c.age_psns_att_edu_inst_20_24_p,

    c.age_psns_att_edu_inst_25_ov_m,
    c.age_psns_att_edu_inst_25_ov_f,
    c.age_psns_att_edu_inst_25_ov_p,

    c.high_yr_schl_comp_yr_12_eq_m,
    c.high_yr_schl_comp_yr_12_eq_f,
    c.high_yr_schl_comp_yr_12_eq_p,

    c.high_yr_schl_comp_yr_11_eq_m,
    c.high_yr_schl_comp_yr_11_eq_f,
    c.high_yr_schl_comp_yr_11_eq_p,

    c.high_yr_schl_comp_yr_10_eq_m,
    c.high_yr_schl_comp_yr_10_eq_f,
    c.high_yr_schl_comp_yr_10_eq_p,

    c.high_yr_schl_comp_yr_9_eq_m,
    c.high_yr_schl_comp_yr_9_eq_f,
    c.high_yr_schl_comp_yr_9_eq_p,

    c.high_yr_schl_comp_yr_8_belw_m,
    c.high_yr_schl_comp_yr_8_belw_f,
    c.high_yr_schl_comp_yr_8_belw_p,

    c.high_yr_schl_comp_d_n_g_sch_m,
    c.high_yr_schl_comp_d_n_g_sch_f,
    c.high_yr_schl_comp_d_n_g_sch_p,

    c.count_psns_occ_priv_dwgs_m,
    c.count_psns_occ_priv_dwgs_f,
    c.count_psns_occ_priv_dwgs_p,

    c.count_persons_other_dwgs_m,
    c.count_persons_other_dwgs_f,
    c.count_persons_other_dwgs_p

from {{ ref('census_g01') }} c

left join {{ ref('lga') }} l
    on c.lga_code = l.lga_code