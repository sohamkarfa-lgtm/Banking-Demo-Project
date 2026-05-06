class Context:
    def __init__(self, dbutils):
        self.dbutils = dbutils

    def get_job_id(self):
        try:
            ctx = self.dbutils.notebook.entry_point.getDbutils().notebook().getContext()

            job_id = ctx.jobId().get() if ctx.jobId().isDefined() else None

            if job_id is None:
                job_id = ctx.tags().get("jobId")

            return str(job_id) if job_id else "interactive_run"

        except Exception:
            return "unknown_job"
