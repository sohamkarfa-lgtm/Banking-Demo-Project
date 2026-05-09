SELECT
    {{ dbt_utils.generate_surrogate_key(['customer_id', 'updated_at']) }} AS dim_customer_id,
    customer_id,
    customer_name,
    customer_email,
    updated_at,
    is_current,
    start_date,
    end_date,
    {{ demo_project_audit_column() }}
FROM {{ ref('stg_customers') }}