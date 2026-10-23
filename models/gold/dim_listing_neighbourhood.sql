/*
    Gold dimension: listing neighbourhood

    Standardises Airbnb listing neighbourhoods and links them to
    NSW Local Government Areas where a matching LGA is available.
*/

with neighbourhoods as (

    select distinct
        listing_neighbourhood

    from {{ ref('listing_neighbourhood') }}

)

select
    md5(n.listing_neighbourhood) as listing_neighbourhood_key,

    n.listing_neighbourhood,
    l.lga_code,
    l.lga_name

from neighbourhoods n

left join {{ ref('lga') }} l
    on n.listing_neighbourhood = l.lga_name