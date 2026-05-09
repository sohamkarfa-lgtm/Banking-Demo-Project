select
    account_id,
    customer_id,
    type as account_type,
    balance as account_balance,
    updated_at,
    is_current,
    end_date,
    {{ demo_project_audit_column() }}
from {{ source('databricks_silver', 'accounts') }}