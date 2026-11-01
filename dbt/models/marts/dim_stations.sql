  with station_events as(
select start_station_id as station_id
     , started_at       as seen_at
  from {{ ref('int_trips') }}

 union all

select end_station_id   as station_id
     , ended_at         as seen_at
  from {{ ref('int_trips') }}
),

 trip_stations as(
select station_id
     , min(seen_at) as first_seen_at
     , max(seen_at) as last_seen_at
  from station_events
 where station_id is not null
 group by station_id
),

current_details as (
select station_code
      , station_name
      , latitude
      , longitude
      , capacity
  from {{ ref('snap_station_information') }}
 where dbt_valid_to is null
)

select coalesce(t.station_id, d.station_code)   as station_id
     , d.station_name
     , d.latitude
     , d.longitude
     , d.capacity
     , d.station_code is not null               as has_station_details
     , t.first_seen_at
     , t.last_seen_at
  from trip_stations t
  full outer join current_details d
    on t.station_id = d.station_code