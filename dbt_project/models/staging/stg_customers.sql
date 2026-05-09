select
    customer_id,
    name as customer_name,
    email as customer_email,
    updated_at,
    is_current,
    start_date,
    end_date,
    {{ demo_project_audit_column() }}
from {{ source('databricks_silver', 'customers') }}
