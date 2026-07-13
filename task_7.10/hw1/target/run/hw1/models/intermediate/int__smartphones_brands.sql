
  
    

  create  table "dbt_course"."public_smartphones"."int_smartphones_brands__dbt_tmp"
  
  
    as
  
  (
    

SELECT DISTINCT
    brand_name
FROM "dbt_course"."public_smartphones"."stg_smartphones"
ORDER BY brand_name
  );
  