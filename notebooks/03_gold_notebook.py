# Databricks notebook source
from src.config.config import Config
from src.pipelines.gold_pipeline import GoldPipeline

config = Config()

GoldPipeline(spark, config).run()

# COMMAND ----------
