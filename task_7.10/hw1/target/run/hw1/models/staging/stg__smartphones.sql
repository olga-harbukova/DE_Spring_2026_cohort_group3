
  create view "dbt_course"."public_smartphones"."stg_smartphones__dbt_tmp"
    
    
  as (
    

SELECT
    brand_name,
    model,
    price,
    processor_brand,
    num_cores,
    processor_speed,
    battery_capacity
FROM "dbt_course"."public"."smartphone_cleaned_v5"
  );