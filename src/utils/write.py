class Writer:
    def __init__(self):
        pass

    def write_stream(self, df, table, checkpoint):
        return (df.writeStream
                .format("delta")
                .option("checkpointLocation", checkpoint)
                .trigger(availableNow=True)
                .toTable(table))

    def write_table(self, df, table):
        df.write.mode("overwrite").saveAsTable(table)
