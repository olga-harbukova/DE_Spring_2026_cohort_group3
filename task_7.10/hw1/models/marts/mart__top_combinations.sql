{{ config(
    materialized = 'table',
    schema = 'smartphones',
    alias = 'mart_top_combinations'
) }}

SELECT
    processor_brand,
    num_cores,
    processor_speed,
    battery_capacity,
    combination_count
FROM {{ ref('int__smartphones_combination') }}
ORDER BY combination_count DESC
LIMIT 10
