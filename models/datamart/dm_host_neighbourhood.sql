/*
    Datamart: dm_host_neighbourhood

    Purpose:
    - Provide monthly host and revenue metrics by host neighbourhood LGA.
    - Retrieve the historically correct host neighbourhood using the
      SCD Type 2 host dimension.
    - Map the host neighbourhood to its corresponding NSW LGA.

    Estimated revenue per host:
    Total estimated revenue from active listings divided by the number
    of distinct hosts in the group.
*/

with historical_data as (

    select
        f.listing_id,
        f.host_id,

        d.scraped_date,
        d.year,
        d.month,
        d.year_month,

        dh.host_neighbourhood,

        coalesce(
            dhn.host_neighbourhood_lga,
            'UNKNOWN'
        ) as host_neighbourhood_lga,

        av.has_availability,

        f.estimated_revenue

    from {{ ref('fact_airbnb_listing') }} f

    inner join {{ ref('dim_scrape_date') }} d
        on f.scrape_date_key = d.scrape_date_key

    /* SCD2 host join */
    inner join {{ ref('dim_host') }} dh
        on f.host_id = dh.host_id
        and d.scraped_date::timestamp >= dh.valid_from::timestamp
        and (
            dh.valid_to is null
            or d.scraped_date::timestamp < dh.valid_to::timestamp
        )

    left join {{ ref('dim_host_neighbourhood') }} dhn
        on upper(nullif(trim(dh.host_neighbourhood), ''))
            = dhn.host_neighbourhood

    inner join {{ ref('dim_availability_status') }} av
        on f.availability_status_key = av.availability_status_key
)

select
    host_neighbourhood_lga,

    year,
    month,
    year_month,

    count(distinct host_id) as distinct_hosts,

    avg(estimated_revenue)
        filter (where has_availability = true)
        as average_estimated_revenue_per_active_listing,

    (
        sum(estimated_revenue)
            filter (where has_availability = true)
        /
        nullif(count(distinct host_id), 0)
    ) as estimated_revenue_per_host

from historical_data

group by
    host_neighbourhood_lga,
    year,
    month,
    year_month

order by
    host_neighbourhood_lga,
    year,
    month