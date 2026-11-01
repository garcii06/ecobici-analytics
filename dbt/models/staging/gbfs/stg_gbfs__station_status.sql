select {{ scrub_string('station_id') }}                   as gbfs_station_id
     , {{ scrub_int('num_bikes_available') }}             as bikes_available
     , {{ scrub_int('num_bikes_disabled') }}              as bikes_disabled
     , {{ scrub_int('num_docks_available') }}             as docks_available
     , {{ scrub_int('num_docks_disabled') }}              as docks_disabled
     , is_installed = 1                                   as is_installed
     , is_renting = 1                                     as is_renting
     , is_returning = 1                                   as is_returning
     , to_timestamp(last_reported)                        as reported_at
     , is_charging
     , to_timestamp(cast(_feed_last_updated as bigint))   as feed_updated_at
     , _snapshot_at
     , _loaded_at
  from {{ source('gbfs', 'station_status') }}