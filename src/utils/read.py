class Reader:
    def __init__(self, spark):
        self.spark = spark

    def read_csv(self, path):
        return (self.spark.read
                .format("csv")
                .option("header", "true")
                .option("inferSchema", "true")
                .load(path))

    def read_table(self, table):
        return self.spark.read.table(table)
