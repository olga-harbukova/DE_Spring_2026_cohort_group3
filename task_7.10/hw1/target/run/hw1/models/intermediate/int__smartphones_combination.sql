
  
    

  create  table "dbt_course"."public_smartphones"."int_smartphones_combination__dbt_tmp"
  
  
    as
  
  (
    

SELECT
    processor_brand,
    num_cores,
    processor_speed,
    battery_capacity,
    COUNT(*) AS combination_count
FROM "dbt_course"."public_smartphones"."stg_smartphones"
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
  );
  