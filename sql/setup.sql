CREATE CATALOG IF NOT EXISTS banking_catalog;

CREATE SCHEMA IF NOT EXISTS banking_catalog.raw;
CREATE SCHEMA IF NOT EXISTS banking_catalog.bronze;
CREATE SCHEMA IF NOT EXISTS banking_catalog.silver;
CREATE SCHEMA IF NOT EXISTS banking_catalog.gold;
CREATE SCHEMA IF NOT EXISTS banking_catalog.monitoring;

CREATE TABLE IF NOT EXISTS banking_catalog.monitoring.pipeline_runs (
    job_id STRING,
    entity STRING,
    layer STRING,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    status STRING,
    error_message STRING
);
