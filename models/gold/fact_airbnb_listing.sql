/*
    Gold fact table: Airbnb listing observation

    Grain:
    One row per Airbnb listing per scrape date.

    The fact table contains only identifiers / dimension keys and
    quantitative metrics.

    SCD Type 2 joins are used for host, listing and property dimensions
    so each monthly fact observation references the dimension version
    that was valid at that point in time.
*/

with source_data as (

    select
        listing_id,
        scrape_id,
        scraped_date,

        host_id,
        host_since,
        host_is_superhost,
        host_neighbourhood,

        listing_neighbourhood,

        property_type,
        room_type,
        accommodates,

        price,
        has_availability,
        availability_30,
        number_of_reviews,

        review_scores_rating,
        review_scores_accuracy,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_value

    from {{ ref('airbnb_listings') }}

),

prepared as (

    select
        listing_id,
        scrape_id,
        scraped_date,

        host_id,
        host_since,
        host_is_superhost,

        upper(nullif(trim(host_neighbourhood), '')) as host_neighbourhood,
        upper(nullif(trim(listing_neighbourhood), '')) as listing_neighbourhood,

        nullif(trim(property_type), '') as property_type,
        nullif(trim(room_type), '') as room_type,

        accommodates,

        price,
        has_availability,
        availability_30,
        number_of_reviews,

        review_scores_rating,
        review_scores_accuracy,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_value,

        case
            when review_scores_rating is null then 'NO RATING'
            when review_scores_rating >= 90 then 'EXCELLENT'
            when review_scores_rating >= 80 then 'VERY GOOD'
            when review_scores_rating >= 70 then 'GOOD'
            when review_scores_rating >= 60 then 'FAIR'
            else 'LOW'
        end as review_rating_band,

        case
            when has_availability then
                greatest(30 - coalesce(availability_30, 30), 0)
            else 0
        end as number_of_stays

    from source_data

)

select
    p.listing_id,
    p.host_id,
    p.scrape_id,

    dl.listing_key,
    dh.host_key,
    dp.property_key,

    dpt.property_type_key,
    drt.room_type_key,
    da.accommodates_key,

    dln.listing_neighbourhood_key,
    dhn.host_neighbourhood_key,
    ds.suburb_key,

    dlga.lga_key as listing_lga_key,
    hlga.lga_key as host_lga_key,

    dsd.scrape_date_key,
    dhsd.host_since_date_key,

    dsh.superhost_status_key,
    dav.availability_status_key,
    drr.review_rating_band_key,

    p.price,
    p.availability_30,
    p.number_of_reviews,

    p.review_scores_rating,
    p.review_scores_accuracy,
    p.review_scores_cleanliness,
    p.review_scores_checkin,
    p.review_scores_communication,
    p.review_scores_value,

    p.number_of_stays,

    case
        when p.has_availability then
            p.number_of_stays * p.price
        else 0
    end as estimated_revenue

from prepared p

/* SCD2 listing */
left join {{ ref('dim_listing') }} dl
    on p.listing_id = dl.listing_id
    and p.scraped_date::timestamp >= dl.valid_from::timestamp
    and (
        dl.valid_to is null
        or p.scraped_date::timestamp < dl.valid_to::timestamp
    )

/* SCD2 host */
left join {{ ref('dim_host') }} dh
    on p.host_id = dh.host_id
    and p.scraped_date::timestamp >= dh.valid_from::timestamp
    and (
        dh.valid_to is null
        or p.scraped_date::timestamp < dh.valid_to::timestamp
    )

/* SCD2 property */
left join {{ ref('dim_property') }} dp
    on p.listing_id = dp.listing_id
    and p.scraped_date::timestamp >= dp.valid_from::timestamp
    and (
        dp.valid_to is null
        or p.scraped_date::timestamp < dp.valid_to::timestamp
    )

left join {{ ref('dim_property_type') }} dpt
    on p.property_type = dpt.property_type

left join {{ ref('dim_room_type') }} drt
    on p.room_type = drt.room_type

left join {{ ref('dim_accommodates') }} da
    on p.accommodates = da.accommodates

left join {{ ref('dim_listing_neighbourhood') }} dln
    on p.listing_neighbourhood = dln.listing_neighbourhood

left join {{ ref('dim_host_neighbourhood') }} dhn
    on p.host_neighbourhood = dhn.host_neighbourhood

left join {{ ref('dim_suburb') }} ds
    on dhn.suburb_name = ds.suburb_name
    and dhn.lga_code = ds.lga_code

left join {{ ref('dim_lga') }} dlga
    on dln.lga_code = dlga.lga_code

left join {{ ref('dim_lga') }} hlga
    on dhn.lga_code = hlga.lga_code

left join {{ ref('dim_scrape_date') }} dsd
    on p.scraped_date = dsd.scraped_date

left join {{ ref('dim_host_since_date') }} dhsd
    on p.host_since = dhsd.host_since

left join {{ ref('dim_superhost_status') }} dsh
    on p.host_is_superhost = dsh.host_is_superhost

left join {{ ref('dim_availability_status') }} dav
    on p.has_availability = dav.has_availability

left join {{ ref('dim_review_rating_band') }} drr
    on p.review_rating_band = drr.review_rating_band