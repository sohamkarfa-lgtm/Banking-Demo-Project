class GoldPipeline:
    def __init__(self, spark, config):
        self.spark = spark
        self.config = config

    def run(self):
        self.spark.sql(f"""
        CREATE OR REPLACE TABLE {self.config.catalog}.gold.customer_dim AS
        SELECT * FROM {self.config.catalog}.silver.customers WHERE is_current = true
        """)

        self.spark.sql(f"""
        CREATE OR REPLACE TABLE {self.config.catalog}.gold.account_dim AS
        SELECT * FROM {self.config.catalog}.silver.accounts WHERE is_current = true
        """)

        self.spark.sql(f"""
        CREATE OR REPLACE TABLE {self.config.catalog}.gold.transaction_fact AS
        SELECT t.*, a.customer_id
        FROM {self.config.catalog}.silver.transactions t
        JOIN {self.config.catalog}.silver.accounts a
        ON t.account_id = a.account_id
        """)
