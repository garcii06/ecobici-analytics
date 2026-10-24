select * 
  from {{ ref('stg_ecobici__trips') }}
 where ended_at < started_at