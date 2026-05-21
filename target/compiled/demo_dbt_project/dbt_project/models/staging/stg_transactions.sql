select
    transaction_id,
    account_id,
    amount,
    timestamp as transaction_ts,
    
  current_timestamp() as stg_loaded_at,
  '4116260a-32c9-494b-9608-130b6d52b62f' as invocation_id,
  'demo_dbt_profile' as target_user
 
from `banking_catalog`.`silver`.`transactions`S