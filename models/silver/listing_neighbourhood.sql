/*
    Silver model: listing_neighbourhood

    Purpose:
    - Standardise listing neighbourhood values.
    - Preserve the scrape date associated with each observed value.
    - Prepare neighbourhood attributes for historical dimensional modelling.
*/

select distinct
    scraped_date,
    upper(nullif(trim(listing_neighbourhood), '')) as listing_neighbourhood

from {{ ref('airbnb_listings') }}

where nullif(trim(listing_neighbourhood), '') is not null