

SELECT
    processor_brand,
    num_cores,
    processor_speed,
    battery_capacity,
    combination_count
FROM "dbt_course"."public_smartphones"."int_smartphones_combination"
ORDER BY combination_count DESC
LIMIT 10