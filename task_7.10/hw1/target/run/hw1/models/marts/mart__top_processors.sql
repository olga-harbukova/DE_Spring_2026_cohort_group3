
  
    

  create  table "dbt_course"."public_smartphones"."mart_top_processors__dbt_tmp"
  
  
    as
  
  (
    

SELECT
    processor_brand,
    num_cores,
    processor_speed,
    COUNT(*) AS usage_count
FROM "dbt_course"."public_smartphones"."stg_smartphones"
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
  );
  