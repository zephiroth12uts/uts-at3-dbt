/*
    Gold dimension: availability status

    The assignment defines an active listing as a listing where
    has_availability is true.
*/

select
    md5(has_availability::text) as availability_status_key,

    has_availability,

    case
        when has_availability then 'ACTIVE'
        else 'INACTIVE'
    end as availability_status

from {{ ref('availability_status') }}