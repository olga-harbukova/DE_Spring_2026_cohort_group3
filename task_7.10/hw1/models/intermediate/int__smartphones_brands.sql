{{ config(
    materialized = 'table',
    schema = 'smartphones',
    alias = 'int_smartphones_brands'
) }}

SELECT DISTINCT
    brand_name
FROM {{ ref('stg__smartphones') }}
ORDER BY brand_name
