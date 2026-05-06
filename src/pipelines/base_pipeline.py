class BasePipeline:
    def __init__(self, spark, config, entity_config, logger, monitoring):
        self.spark = spark
        self.config = config
        self.entity_config = entity_config
        self.logger = logger
        self.monitoring = monitoring
