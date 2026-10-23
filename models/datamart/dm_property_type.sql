/*
    Datamart: dm_property_type

    Purpose:
    - Provide monthly Airbnb performance metrics by property type,
      room type and accommodation capacity.
    - Use SCD Type 2 property and host dimensions so each fact row
      is associated with the historical dimension values that were
      valid at the time of the observation.
*/

with historical_data as (

    select
        f.listing_id,
        f.host_id,

        d.scraped_date,
        d.year,
        d.month,
        d.year_month,

        dp.property_type,
        dp.room_type,
        dp.accommodates,

        dh.host_is_superhost,

        av.has_availability,

        f.price,
        f.review_scores_rating,
        f.number_of_stays,
        f.estimated_revenue

    from {{ ref('fact_airbnb_listing') }} f

    inner join {{ ref('dim_scrape_date') }} d
        on f.scrape_date_key = d.scrape_date_key

    /* SCD2 property join */
    inner join {{ ref('dim_property') }} dp
        on f.listing_id = dp.listing_id
        and d.scraped_date::timestamp >= dp.valid_from::timestamp
        and (
            dp.valid_to is null
            or d.scraped_date::timestamp < dp.valid_to::timestamp
        )

    /* SCD2 host join */
    inner join {{ ref('dim_host') }} dh
        on f.host_id = dh.host_id
        and d.scraped_date::timestamp >= dh.valid_from::timestamp
        and (
            dh.valid_to is null
            or d.scraped_date::timestamp < dh.valid_to::timestamp
        )

    inner join {{ ref('dim_availability_status') }} av
        on f.availability_status_key = av.availability_status_key
),

monthly_metrics as (

    select
        property_type,
        room_type,
        accommodates,

        year,
        month,
        year_month,

        count(distinct listing_id) as total_listings,

        count(distinct listing_id)
            filter (where has_availability = true)
            as active_listings,

        count(distinct listing_id)
            filter (where has_availability = false)
            as inactive_listings,

        (
            count(distinct listing_id)
                filter (where has_availability = true)::numeric
            / nullif(count(distinct listing_id), 0)
        ) * 100 as active_listing_rate,

        min(price)
            filter (where has_availability = true)
            as minimum_price,

        max(price)
            filter (where has_availability = true)
            as maximum_price,

        percentile_cont(0.5)
            within group (order by price)
            filter (where has_availability = true)
            as median_price,

        avg(price)
            filter (where has_availability = true)
            as average_price,

        count(distinct host_id) as distinct_hosts,

        (
            count(distinct host_id)
                filter (where host_is_superhost = true)::numeric
            / nullif(count(distinct host_id), 0)
        ) * 100 as superhost_rate,

        avg(review_scores_rating)
            filter (where has_availability = true)
            as average_review_scores_rating,

        sum(number_of_stays)
            filter (where has_availability = true)
            as total_number_of_stays,

        avg(estimated_revenue)
            filter (where has_availability = true)
            as average_estimated_revenue_per_active_listing

    from historical_data

    group by
        property_type,
        room_type,
        accommodates,
        year,
        month,
        year_month
),

with_previous_month as (

    select
        property_type,
        room_type,
        accommodates,

        year,
        month,
        year_month,

        total_listings,
        active_listings,
        inactive_listings,
        active_listing_rate,

        minimum_price,
        maximum_price,
        median_price,
        average_price,

        distinct_hosts,
        superhost_rate,
        average_review_scores_rating,

        total_number_of_stays,
        average_estimated_revenue_per_active_listing,

        lag(active_listings) over (
            partition by
                property_type,
                room_type,
                accommodates
            order by year, month
        ) as previous_active_listings,

        lag(inactive_listings) over (
            partition by
                property_type,
                room_type,
                accommodates
            order by year, month
        ) as previous_inactive_listings

    from monthly_metrics
)

select
    property_type,
    room_type,
    accommodates,

    year,
    month,
    year_month,

    active_listing_rate,

    minimum_price,
    maximum_price,
    median_price,
    average_price,

    distinct_hosts,
    superhost_rate,
    average_review_scores_rating,

    (
        (active_listings - previous_active_listings)::numeric
        / nullif(previous_active_listings, 0)
    ) * 100 as active_listings_percentage_change,

    (
        (inactive_listings - previous_inactive_listings)::numeric
        / nullif(previous_inactive_listings, 0)
    ) * 100 as inactive_listings_percentage_change,

    total_number_of_stays,
    average_estimated_revenue_per_active_listing

from with_previous_month

order by
    property_type,
    room_type,
    accommodates,
    year,
    month