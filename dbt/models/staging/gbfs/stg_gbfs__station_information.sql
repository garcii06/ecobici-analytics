select {{ scrub_string('station_id') }}                   as gbfs_station_id
     , {{ scrub_string('short_name') }}                   as station_code
     , {{ scrub_string('name', collapse_spaces=true) }}   as station_name
     , cast(external_id as varchar)                       as external_id
     , lat                                                as latitude
     , lon                                                as longitude
     , {{ scrub_int('capacity') }}                        as capacity
     , has_kiosk
     , is_charging
     , to_timestamp(cast(_feed_last_updated as bigint))   as feed_updated_at
     , _snapshot_at
     , _loaded_at
from {{ source('gbfs', 'station_information') }}