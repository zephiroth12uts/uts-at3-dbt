/*
    Gold dimension: suburb

    Maps each NSW suburb to its corresponding Local Government Area.
*/

select
    md5(
        concat_ws(
            '||',
            s.suburb_name,
            s.lga_name
        )
    ) as suburb_key,

    s.suburb_name,
    l.lga_code,
    s.lga_name

from {{ ref('suburb') }} s

left join {{ ref('lga') }} l
    on s.lga_name = l.lga_name