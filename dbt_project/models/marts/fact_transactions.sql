WITH stg_transactions AS (
    SELECT * FROM {{ ref('stg_transactions') }}
),

dim_account AS (
    SELECT * FROM {{ ref('dim_account') }}
    WHERE is_current = TRUE
),

dim_customer AS (
    SELECT * FROM {{ ref('dim_customer') }}
    WHERE is_current = TRUE
),

joined AS (
    SELECT
        -- Surrogate key for the fact row
        {{ dbt_utils.generate_surrogate_key([
            'txn.transaction_id',
            'txn.account_id'
        ]) }}                                       AS fact_transaction_id,

        -- Foreign keys to dimensions
        da.dim_account_id,
        dc.dim_customer_id,

        -- Degenerate / natural keys kept on the fact
        txn.transaction_id,
        txn.account_id,
        da.customer_id,

        -- Date / time grain
        txn.transaction_ts,
        CAST(txn.transaction_ts AS DATE)            AS transaction_date,
        DATE_TRUNC('month', txn.transaction_ts)     AS transaction_month,
        DATE_TRUNC('year',  txn.transaction_ts)     AS transaction_year,

        -- Measures
        txn.amount                                  AS transaction_amount,

        -- Categorised amounts (positive = credit, negative = debit)
        CASE WHEN txn.amount >= 0
             THEN txn.amount
             ELSE 0
        END                                         AS credit_amount,

        CASE WHEN txn.amount < 0
             THEN ABS(txn.amount)
             ELSE 0
        END                                         AS debit_amount,

        -- Descriptive attributes carried forward from dimensions
        da.account_type_cd,
        da.account_balance                          AS account_balance_at_time,

        -- Audit columns
        {{ demo_project_audit_column() }}

    FROM stg_transactions AS txn

    LEFT JOIN dim_account AS da
        ON txn.account_id = da.account_id

    LEFT JOIN dim_customer AS dc
        ON da.customer_id = dc.customer_id
)

SELECT * FROM joined
