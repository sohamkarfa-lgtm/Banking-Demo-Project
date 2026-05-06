from datetime import datetime
from pyspark.sql.types import StructType, StructField, StringType, TimestampType

class Monitoring:
    def __init__(self, spark, table, context):
        self.spark = spark
        self.table = table
        self.context = context

    def log(self, entity, layer, status, error=None):
        job_id = self.context.get_job_id()

        data = [(job_id, entity, layer, datetime.now(), datetime.now(), status, error)]

        
        schema = StructType([
                StructField("job_id", StringType(), False),
                StructField("entity", StringType(), False),
                StructField("layer", StringType(), False),
                StructField("start_time", TimestampType(), False),
                StructField("end_time", TimestampType(), False),
                StructField("status", StringType(), False),
                StructField("error_message", StringType(), True)
            ])


        self.spark.createDataFrame(data, schema) \
            .write.mode("append") \
            .saveAsTable(self.table)
