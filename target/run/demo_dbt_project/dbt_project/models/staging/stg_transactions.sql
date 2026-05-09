
  
  
  create or replace view `banking_catalog`.`dbt_staging`.`stg_transactions`
  
  as (
    select
    transaction_id,
    account_id,
    amount,
    timestamp as transaction_ts,
    
  current_timestamp() as stg_loaded_at,
  'b07be56d-ba53-4dec-a113-cdf774c6366c' as invocation_id,
  'demo_dbt_profile' as target_user
 
from `banking_catalog`.`silver`.`transactions`S
  )
