{%- macro scrub_string(column_name, collapse_spaces=false) -%}
    {%- if collapse_spaces -%}
    nullif(regexp_replace(trim({{ column_name }}), '\s+', ' ', 'g'), '')
    {%- else -%}
    nullif(nullif(trim({{ column_name }}), ''), 'NULL')
    {%- endif -%}
{%- endmacro -%}

{%- macro scrub_int(column_name) -%}
    try_cast(try_cast({{ column_name }} AS double) AS integer)
{%- endmacro -%}