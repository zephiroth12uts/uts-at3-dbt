/*
    Gold dimension: review rating band
*/

select
    md5(review_rating_band) as review_rating_band_key,

    review_rating_band,

    case
        when review_rating_band = 'EXCELLENT' then 1
        when review_rating_band = 'VERY GOOD' then 2
        when review_rating_band = 'GOOD' then 3
        when review_rating_band = 'FAIR' then 4
        when review_rating_band = 'LOW' then 5
        when review_rating_band = 'NO RATING' then 6
        else 99
    end as rating_band_order

from {{ ref('review_rating_band') }}