# Databricks notebook source
from src.config.config import Config
from src.config.entity_config import EntityConfig
from src.utils.read import Reader
from src.utils.write import Writer
from src.utils.path import PathUtils
from src.utils.logger import Logger
from src.utils.monitoring import Monitoring
from src.utils.context import Context
from src.pipelines.bronze_pipeline import BronzePipeline

config = Config()
entity_config = EntityConfig()

context = Context(dbutils)

pipeline = BronzePipeline(
    spark,
    config,
    entity_config,
    Reader(spark),
    Writer(),
    PathUtils(config),
    Logger("bronze"),
    Monitoring(spark, "banking_catalog.monitoring.pipeline_runs", context)
)

for entity in entity_config.entities:
    pipeline.run(entity)

# COMMAND ----------
