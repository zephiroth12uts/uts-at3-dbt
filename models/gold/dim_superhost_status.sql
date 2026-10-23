/*
    Gold dimension: superhost status
*/

select
    md5(host_is_superhost::text) as superhost_status_key,

    host_is_superhost,

    case
        when host_is_superhost then 'SUPERHOST'
        else 'NOT SUPERHOST'
    end as superhost_status

from {{ ref('superhost_status') }}