from datetime import datetime

class Monitoring:
    def __init__(self, spark, table, context):
        self.spark = spark
        self.table = table
        self.context = context

    def log(self, entity, layer, status, error=None):
        job_id = self.context.get_job_id()

        data = [(job_id, entity, layer, datetime.now(), datetime.now(), status, error)]

        cols = [
            "job_id","entity","layer",
            "start_time","end_time","status","error_message"
        ]

        self.spark.createDataFrame(data, cols) \
            .write.mode("append") \
            .saveAsTable(self.table)
