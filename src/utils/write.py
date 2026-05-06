class Writer:
    def __init__(self):
        pass

    def write_bronze(self, df, table, checkpoint):
        return (df.write
                .format("delta")
                .mode("append")
                .option("mergeSchema", "true")
                .saveAsTable(table))

    def write_table(self, df, table):
        df.write.mode("overwrite").saveAsTable(table)
