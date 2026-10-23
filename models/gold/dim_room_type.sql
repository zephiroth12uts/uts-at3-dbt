/*
    Gold dimension: room type
*/

select
    md5(room_type) as room_type_key,
    room_type

from {{ ref('room_type') }}