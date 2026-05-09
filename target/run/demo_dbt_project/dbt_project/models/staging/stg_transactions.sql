
  
  
  create or replace view `banking_catalog`.`dbt_staging`.`stg_transactions`
  
  as (
    select
    transaction_id,
    account_id,
    amount,
    timestamp as transaction_ts,
    
  current_timestamp() as stg_loaded_at,
  'fac1a800-b3e7-427c-8725-548465639d24' as invocation_id,
  'demo_dbt_profile' as target_user
 
from `banking_catalog`.`silver`.`transactions`S
  )
