/*
    Gold dimension: host neighbourhood

    Converts Airbnb host neighbourhood values into their corresponding
    NSW Local Government Areas using the suburb-to-LGA mapping.

    This dimension supports dm_host_neighbourhood.
*/

with neighbourhoods as (

    select distinct
        host_neighbourhood

    from {{ ref('host_neighbourhood') }}

),

suburb_mapping as (

    select
        suburb_name,
        lga_name,

        row_number() over (
            partition by suburb_name
            order by lga_name
        ) as row_num

    from {{ ref('suburb') }}

)

select
    md5(n.host_neighbourhood) as host_neighbourhood_key,

    n.host_neighbourhood,
    sm.suburb_name,
    l.lga_code,
    l.lga_name as host_neighbourhood_lga

from neighbourhoods n

left join suburb_mapping sm
    on n.host_neighbourhood = sm.suburb_name
    and sm.row_num = 1

left join {{ ref('lga') }} l
    on sm.lga_name = l.lga_name