-- on_schema_change='fail' stops the run if the model’s columns change

{{ config(
    materialized='incremental',
    unique_key='trip_key',
    incremental_strategy='delete+insert',
    on_schema_change='fail'
) }}

select trip_key
     , start_station_id
     , end_station_id
     , started_date
     , ended_date
     , started_at
     , ended_at
     , cast(started_hour as integer)       as started_hour
     , cast(ended_hour as integer)         as ended_hour
     , cast(duration_seconds as integer)   as duration_seconds
     , bike_id
     , user_gender_label
     , cast(user_age as integer)           as user_age
     , age_group
     , is_round_trip
     , is_long_trip
     , _month
     , _loaded_at
  from {{ ref('int_trips') }}

{% if is_incremental() %}
 where _month >= (select max(_month) from {{ this }})
{% endif %}