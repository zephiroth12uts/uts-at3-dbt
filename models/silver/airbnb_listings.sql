/*
    Silver model: airbnb_listings

    Purpose:
    - Read the raw Airbnb listings loaded by Airflow into the Bronze layer.
    - Standardise text fields.
    - Preserve the source attributes required for downstream dimensional modelling.
    - Add temporal attributes that will be used later in the Gold layer and datamarts.

    No business aggregations are performed in the Silver layer.
*/

with source_data as (

    select
        listing_id,
        scrape_id,
        scraped_date,
        host_id,
        host_name,
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

    from {{ source('bronze', 'airbnb_listings') }}

),

cleaned as (

    select
        listing_id,
        scrape_id,
        scraped_date,

        host_id,
        nullif(trim(host_name), '') as host_name,
        host_since,
        host_is_superhost,
        nullif(trim(host_neighbourhood), '') as host_neighbourhood,

        nullif(trim(listing_neighbourhood), '') as listing_neighbourhood,
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

        extract(year from scraped_date)::integer as scrape_year,
        extract(month from scraped_date)::integer as scrape_month

    from source_data

)

select
    listing_id,
    scrape_id,
    scraped_date,
    host_id,
    host_name,
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
    review_scores_value,
    scrape_year,
    scrape_month

from cleaned