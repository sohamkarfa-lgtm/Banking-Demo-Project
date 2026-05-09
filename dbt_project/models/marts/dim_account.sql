WITH stg_accounts AS (
    SELECT * FROM {{ ref('stg_accounts') }}
),

seed_demo AS (
    SELECT * FROM {{ ref('seed_demo_cd') }}
),

logic AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['account_id', 'updated_at']) }} AS dim_account_id,
        act.account_id,
        act.customer_id,
        sat.id AS account_type_cd,
        act.account_balance,
        act.updated_at,
        act.is_current,
        act.end_date,
        {{ demo_project_audit_column() }}
    FROM stg_accounts AS act
    LEFT JOIN seed_demo AS sat ON act.account_type = sat.cd_value 
    AND sat.cd_name = 'Account_Type'
)

SELECT * FROM logic