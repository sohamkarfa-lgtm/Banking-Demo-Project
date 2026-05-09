select
    transaction_id,
    account_id,
    amount,
    timestamp as transaction_ts,
    {{ demo_project_audit_column() }} 
from {{ source('databricks_silver', 'transactions') }}S