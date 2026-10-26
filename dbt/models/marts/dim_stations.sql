  with station_events as(
select start_station_id as station_id
     , started_at       as seen_at
  from {{ ref('int_trips') }}

 union all

select end_station_id   as station_id
     , ended_at         as seen_at
  from {{ ref('int_trips') }}
)

select station_id
     , min(seen_at) as first_seen_at
     , max(seen_at) as last_seen_at
  from station_events
 where station_id is not null
 group by station_id