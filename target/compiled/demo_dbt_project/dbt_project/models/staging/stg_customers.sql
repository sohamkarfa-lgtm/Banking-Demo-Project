select
    customer_id,
    name as customer_name,
    email as customer_email,
    updated_at,
    is_current,
    start_date,
    end_date,
    
  current_timestamp() as stg_loaded_at,
  'fac1a800-b3e7-427c-8725-548465639d24' as invocation_id,
  'demo_dbt_profile' as target_user

from `banking_catalog`.`silver`.`customers`