from pyspark.sql.functions import col, current_timestamp, lit
from delta.tables import DeltaTable


class SCDType2:
    def __init__(self, spark):
        self.spark = spark

    def apply(self, df, target_table, pk):
        """
        Production-grade SCD Type 2 using Delta MERGE

        Assumptions:
        - Source DF contains:
            pk (primary key)
            operation (INSERT/UPDATE/DELETE)
            updated_at (timestamp)
        """

        # Deduplicate latest record per PK
        windowed_df = (
            df.orderBy(col("updated_at").desc())
              .dropDuplicates([pk])
        )

        # Add SCD columns
        staged_df = (
            windowed_df
            .withColumn("is_current", lit(True))
            .withColumn("start_date", col("updated_at"))
            .withColumn("end_date", lit(None).cast("timestamp"))
        )

        # If table doesn't exist → create
        if not self.spark.catalog.tableExists(target_table):
            (staged_df.write
             .format("delta")
             .saveAsTable(target_table))
            return

        delta_table = DeltaTable.forName(self.spark, target_table)

        # -------------------------
        # 1. EXPIRE EXISTING RECORDS
        # -------------------------
        (
            delta_table.alias("target")
            .merge(
                staged_df.alias("source"),
                f"target.{pk} = source.{pk} AND target.is_current = true"
            )
            .whenMatchedUpdate(
                condition="""
                    source.operation IN ('UPDATE','DELETE')
                """,
                set={
                    "is_current": "false",
                    "end_date": "source.updated_at"
                }
            )
            .execute()
        )

        # -------------------------
        # 2. INSERT NEW RECORDS
        # -------------------------
        (
            delta_table.alias("target")
            .merge(
                staged_df.alias("source"),
                f"target.{pk} = source.{pk} AND target.is_current = true"
            )
            .whenNotMatchedInsert(
                condition="""
                    source.operation IN ('INSERT','UPDATE')
                """,
                values={
                    **{c: f"source.{c}" for c in staged_df.columns}
                }
            )
            .execute()
        )
