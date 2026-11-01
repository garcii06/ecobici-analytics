select *
  from {{ ref('stg_gbfs__station_information') }}
qualify row_number() over (partition by station_code order by _snapshot_at desc) = 1