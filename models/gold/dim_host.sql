/*
    Gold dimension: host

    SCD Type 2 host dimension built from the Silver host snapshot.
    Each historical host version receives its own surrogate key.
*/

select
    md5(
        concat_ws(
            '||',
            host_id::text,
            dbt_valid_from::text
        )
    ) as host_key,

    host_id,
    host_name,
    host_since,
    host_is_superhost,
    host_neighbourhood,

    dbt_valid_from as valid_from,
    dbt_valid_to as valid_to

from {{ ref('host_snapshot') }}