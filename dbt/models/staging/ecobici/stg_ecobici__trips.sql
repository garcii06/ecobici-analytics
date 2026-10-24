SELECT
       md5(concat_ws('|', coalesce(Bici,''), coalesce(Ciclo_Estacion_Retiro,''), coalesce(Fecha_Retiro,''), coalesce(Hora_Retiro,''), coalesce(Ciclo_EstacionArribo,'')
            , coalesce(Fecha_Arribo,''), coalesce(Hora_Arribo,'')))             AS trip_key
     , {{ scrub_string('Genero_Usuario') }}                                     AS user_gender
     , {{ scrub_int('Edad_Usuario') }}                                          AS user_age
     , nullif(trim(Bici), '')                                                   AS bike_id
     , nullif(trim(Ciclo_Estacion_Retiro), '')                                  AS start_station_id
     , nullif(trim(Ciclo_EstacionArribo), '')                                   AS end_station_id
     , try_strptime(Fecha_Retiro || ' ' || Hora_Retiro, '%d/%m/%Y %H:%M:%S')    AS started_at
     , try_strptime(Fecha_Arribo || ' ' || Hora_Arribo, '%d/%m/%Y %H:%M:%S')    AS ended_at
     , _month
     , _source_url
     , _loaded_at
  FROM {{ source('ecobici', 'trips') }}