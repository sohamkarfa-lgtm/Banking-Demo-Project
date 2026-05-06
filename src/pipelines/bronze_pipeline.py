from .base_pipeline import BasePipeline

class BronzePipeline(BasePipeline):
    def __init__(self, spark, config, entity_config, reader, writer, path_utils, logger, monitoring):
        super().__init__(spark, config, entity_config, logger, monitoring)
        self.reader = reader
        self.writer = writer
        self.path_utils = path_utils

    def run(self, entity):
        try:
            df = self.reader.read_csv(self.path_utils.raw_path(entity))

            table = f"{self.config.catalog}.bronze.{entity}"
            checkpoint = self.path_utils.checkpoint_path(entity, "bronze")

            self.writer.write_bronze(df, table, checkpoint)

            self.monitoring.log(entity, "bronze", "SUCCESS")

        except Exception as e:
            self.monitoring.log(entity, "bronze", "FAILED", str(e))
            raise
