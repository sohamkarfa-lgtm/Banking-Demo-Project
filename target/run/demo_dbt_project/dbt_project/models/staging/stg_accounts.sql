
  
  
  create or replace view `banking_catalog`.`dbt_staging`.`stg_accounts`
  
  as (
    select
    account_id,
    customer_id,
    type as account_type,
    balance as account_balance,
    updated_at,
    is_current,
    end_date,
    
  current_timestamp() as stg_loaded_at,
  'fac1a800-b3e7-427c-8725-548465639d24' as invocation_id,
  'demo_dbt_profile' as target_user

from `banking_catalog`.`silver`.`accounts`
  )
