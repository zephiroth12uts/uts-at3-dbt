/*
    Custom schema naming.

    This macro ensures that dbt uses the exact schema name configured
    for each Medallion layer instead of prefixing it with target.schema.
*/

{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}

{%- endmacro %}