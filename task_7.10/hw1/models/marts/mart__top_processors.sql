{{ config(
    materialized = 'table',
    schema = 'smartphones',
    alias = 'mart_top_processors'
) }}

SELECT
    processor_brand,
    num_cores,
    processor_speed,
    COUNT(*) AS usage_count
FROM {{ ref('stg__smartphones') }}
WHERE 
    processor_brand IS NOT NULL 
    AND num_cores IS NOT NULL
    AND processor_speed IS NOT NULL
GROUP BY
    processor_brand,
    num_cores,
    processor_speed
ORDER BY usage_count DESC
LIMIT 10
