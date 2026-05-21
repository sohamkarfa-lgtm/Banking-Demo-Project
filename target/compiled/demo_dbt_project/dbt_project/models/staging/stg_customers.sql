select
    customer_id,
    name as customer_name,
    email as customer_email,
    updated_at,
    is_current,
    start_date,
    end_date,
    
  current_timestamp() as stg_loaded_at,
  '4116260a-32c9-494b-9608-130b6d52b62f' as invocation_id,
  'demo_dbt_profile' as target_user

from `banking_catalog`.`silver`.`customers`