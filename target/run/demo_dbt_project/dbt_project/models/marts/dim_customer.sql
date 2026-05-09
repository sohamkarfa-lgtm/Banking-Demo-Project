
  
    
        create or replace table `banking_catalog`.`dbt_marts`.`dim_customer`
      
      
    using delta
  
      
      
      
      
      
      
      
      as
      SELECT
    md5(cast(concat(coalesce(cast(customer_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(updated_at as string), '_dbt_utils_surrogate_key_null_')) as string)) AS dim_customer_id,
    customer_id,
    customer_name,
    customer_email,
    updated_at,
    is_current,
    start_date,
    end_date,
    
  current_timestamp() as stg_loaded_at,
  'fac1a800-b3e7-427c-8725-548465639d24' as invocation_id,
  'demo_dbt_profile' as target_user

FROM `banking_catalog`.`dbt_staging`.`stg_customers`
  