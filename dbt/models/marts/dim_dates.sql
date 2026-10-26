  with spine as(
{{
    dbt_utils.date_spine(
        datepart="day"
        , start_date="cast('" ~ var('dim_dates_start') ~ "' as date)"
        , end_date="cast('" ~ var('dim_dates_end') ~ "' as date)"
    )
}}
)

select cast(date_day as date)                       as date_day
     , cast(strftime(date_day, '%Y-%m') as varchar) as year_month
     , cast(year(date_day) as integer)             as year_number
     , cast(quarter(date_day) as integer)          as quarter_number
     , cast(month(date_day) as integer)            as month_number
     , cast(monthname(date_day) as varchar)        as month_name
     , cast(day(date_day) as integer)              as day_of_month
     , cast(isodow(date_day) as integer)           as day_of_week_number
     , cast(dayname(date_day) as varchar)          as day_name
     , cast(weekofyear(date_day) as integer)       as week_of_year
     , isodow(date_day) in (6, 7)                  as is_weekend
  from spine