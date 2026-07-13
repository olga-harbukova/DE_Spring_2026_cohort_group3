{{ config(
    materialized = 'table',
    schema = 'smartphones',
    alias = 'int_smartphones_combination'
) }}

SELECT
    processor_brand,
    num_cores,
    processor_speed,
    battery_capacity,
    COUNT(*) AS combination_count
FROM {{ ref('stg__smartphones') }}
WHERE 
    processor_brand IS NOT NULL 
    AND num_cores IS NOT NULL
    AND processor_speed IS NOT NULL
    AND battery_capacity IS NOT NULL
GROUP BY
    processor_brand,
    num_cores,
    processor_speed,
    battery_capacity
ORDER BY combination_count DESC
