
  
  
  create or replace view `banking_catalog`.`dbt_staging`.`stg_customers`
  
  as (
    select
    customer_id,
    name as customer_name,
    email as customer_email,
    updated_at,
    is_current,
    start_date,
    end_date,
    
  current_timestamp() as stg_loaded_at,
  'b07be56d-ba53-4dec-a113-cdf774c6366c' as invocation_id,
  'demo_dbt_profile' as target_user

from `banking_catalog`.`silver`.`customers`
  )
