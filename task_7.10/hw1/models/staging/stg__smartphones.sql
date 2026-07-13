{{ config(
    materialized = 'view',
    schema = 'smartphones',
    alias = 'stg_smartphones'
) }}

SELECT
    brand_name,
    model,
    price,
    processor_brand,
    num_cores,
    processor_speed,
    battery_capacity
FROM {{ source('raw', 'smartphone_cleaned_v5') }}
