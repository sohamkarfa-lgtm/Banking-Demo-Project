from .base_pipeline import BasePipeline

class SilverPipeline(BasePipeline):
    def __init__(self, spark, config, entity_config, reader, writer, scd, logger, monitoring):
        super().__init__(spark, config, entity_config, logger, monitoring)
        self.reader = reader
        self.writer = writer
        self.scd = scd

    def run(self, entity):
        try:
            cfg = self.entity_config.entities[entity]

            bronze = f"{self.config.catalog}.bronze.{entity}"
            silver = f"{self.config.catalog}.silver.{entity}"

            df = self.reader.read_table(bronze)

            if cfg["scd_type2"]:
                self.scd.apply(df, silver, cfg["primary_key"])
            else:
                self.writer.write_table(df, silver)

            self.monitoring.log(entity, "silver", "SUCCESS")

        except Exception as e:
            self.monitoring.log(entity, "silver", "FAILED", str(e))
            raise
