WITH stg_accounts AS (
    SELECT * FROM `banking_catalog`.`dbt_staging`.`stg_accounts`
),

seed_demo AS (
    SELECT * FROM `banking_catalog`.`dbt_seed`.`seed_demo_cd`
),

logic AS (
    SELECT
        md5(cast(concat(coalesce(cast(account_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(updated_at as string), '_dbt_utils_surrogate_key_null_')) as string)) AS dim_account_id,
        act.account_id,
        act.customer_id,
        sat.id AS account_type_cd,
        act.account_balance,
        act.updated_at,
        act.is_current,
        act.end_date,
        
  current_timestamp() as stg_loaded_at,
  'b07be56d-ba53-4dec-a113-cdf774c6366c' as invocation_id,
  'demo_dbt_profile' as target_user

    FROM stg_accounts AS act
    LEFT JOIN seed_demo AS sat ON act.account_type = sat.cd_value 
    AND sat.cd_name = 'Account_Type'
)

SELECT * FROM logic