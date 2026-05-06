from pyspark.sql.functions import current_timestamp

class CommonUtils:
    def __init__(self):
        pass

    def add_audit_columns(self, df):
        return df.withColumn("ingestion_time", current_timestamp())
