# Databricks notebook source
from src.config.config import Config
from src.config.entity_config import EntityConfig
from src.utils.read import Reader
from src.utils.write import Writer
from src.utils.scd import SCDType2
from src.utils.logger import Logger
from src.utils.monitoring import Monitoring
from src.utils.context import Context
from src.pipelines.silver_pipeline import SilverPipeline

config = Config()
entity_config = EntityConfig()

context = Context(dbutils)

pipeline = SilverPipeline(
    spark,
    config,
    entity_config,
    Reader(spark),
    Writer(),
    SCDType2(spark),
    Logger("silver"),
    Monitoring(spark, "banking_catalog.monitoring.pipeline_runs", context)
)

for entity in entity_config.entities:
    pipeline.run(entity)

# COMMAND ----------
