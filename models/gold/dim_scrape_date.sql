/*
    Gold dimension: scrape date

    Provides calendar attributes for each Airbnb observation date.
*/

select distinct
    to_char(scraped_date, 'YYYYMMDD')::integer as scrape_date_key,

    scraped_date,

    extract(year from scraped_date)::integer as year,
    extract(month from scraped_date)::integer as month,

    to_char(scraped_date, 'Month') as month_name,
    to_char(scraped_date, 'YYYY-MM') as year_month

from {{ ref('airbnb_listings') }}

where scraped_date is not null