/*
    Silver model: review_rating_band

    Purpose:
    - Derive consistent analytical bands from review_scores_rating.
    - Provide a reusable categorisation for the Gold dimensional model.

    The original review score is preserved in the fact table.
    This model only defines analytical rating categories.
*/

select distinct
    case
        when review_scores_rating is null then 'NO RATING'
        when review_scores_rating >= 90 then 'EXCELLENT'
        when review_scores_rating >= 80 then 'VERY GOOD'
        when review_scores_rating >= 70 then 'GOOD'
        when review_scores_rating >= 60 then 'FAIR'
        else 'LOW'
    end as review_rating_band

from {{ ref('airbnb_listings') }}