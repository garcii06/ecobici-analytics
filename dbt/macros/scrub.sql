{%- macro scrub_string(column_name) -%}
    nullif(trim({{ column_name }}), '')
{%- endmacro -%}

{%- macro scrub_int(column_name) -%}
    try_cast(try_cast({{ column_name }} AS double) AS integer)
{%- endmacro -%}