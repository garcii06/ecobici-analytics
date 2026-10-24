  WITH trips AS(
SELECT * rename (user_age AS user_age_reported)
  FROM {{ ref('stg_ecobici__trips') }}
)

, cleaned AS (
SELECT *
     , CASE
        WHEN user_age_reported BETWEEN {{ var('min_user_age') }} AND {{ var('max_user_age') }}
        THEN user_age_reported
       END                                        AS user_age
     , CASE user_gender
        WHEN 'M' THEN 'male'
        WHEN 'F' THEN 'female'
        WHEN 'O' THEN 'other'
        ELSE 'unknown'
       END                                        AS user_gender_label
     , cast(started_at AS DATE)                   AS started_date
     , cast(ended_at AS DATE)                     AS ended_date
     , hour(started_at)                           AS started_hour
     , hour(ended_at)                             AS ended_hour
     , date_diff('second', started_at, ended_at)  AS duration_seconds
  FROM trips
)

, final AS (
SELECT *
     , CASE
        WHEN user_age is null THEN 'unknown'
        WHEN user_age < 25    THEN '<25'
        WHEN user_age < 35    THEN '25-34'
        WHEN user_age < 45    THEN '35-44'
        WHEN user_age < 55    THEN '45-54'
        WHEN user_age < 65    THEN '55-64'
        ELSE '65+'
    END                                               AS age_group,
    start_station_id = end_station_id                 AS is_round_trip,
    duration_seconds > {{ var('long_trip_seconds') }} AS is_long_trip
from cleaned
)

SELECT * 
  FROM final