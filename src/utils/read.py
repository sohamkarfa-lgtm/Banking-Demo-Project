class Reader:
    def __init__(self, spark):
        self.spark = spark

    def read_stream(self, path):
        return (self.spark.readStream
                .format("cloudFiles")
                .option("cloudFiles.format", "csv")
                .option("header", "true")
                .load(path))

    def read_table(self, table):
        return self.spark.read.table(table)
