# Banking-Demo-Project
This is for learning purposes.

## Features
✔ End-to-end Databricks project  
✔ Streaming + batch + SCD  
✔ Job-aware monitoring  
✔ Clean modular architecture  
✔ GitHub-ready structure  
✔ **Databricks Automation Bundle support for IaC deployments**

## Quick Start: Deploy with Databricks Bundle

### 1. Install Databricks CLI
```bash
pip install databricks-cli databricks-labs-python-sdk
```

### 2. Authenticate
```bash
databricks configure --token --profile BANKING_DEMO
```

### 3. Validate & Deploy
```bash
databricks bundle validate
databricks bundle deploy --target dev
```

✅ **Done!** Your jobs are now deployed to Databricks.

For detailed instructions, see [QUICK_START.md](./QUICK_START.md)

## Documentation

- **[QUICK_START.md](./QUICK_START.md)** - 5-minute quick start guide
- **[DATABRICKS_BUNDLE_DEPLOYMENT_GUIDE.md](./DATABRICKS_BUNDLE_DEPLOYMENT_GUIDE.md)** - Comprehensive 17-step setup guide
- **[DATABRICKS_COMMANDS_REFERENCE.md](./DATABRICKS_COMMANDS_REFERENCE.md)** - CLI command reference
- **[DATABRICKS_TROUBLESHOOTING.md](./DATABRICKS_TROUBLESHOOTING.md)** - Troubleshooting guide

## Project Structure
```
banking-demo-project/
├── notebooks/                    # Databricks notebooks
│   ├── 01_bronze_notebook.py    # Bronze layer - Data ingestion
│   ├── 02_silver_notebook.py    # Silver layer - Data transformation
│   └── 03_gold_notebook.py      # Gold layer - Analytics tables
├── src/                         # Python source code
│   ├── config/                  # Configuration modules
│   ├── pipelines/              # Pipeline definitions
│   └── utils/                  # Utility functions
├── sql/                        # SQL scripts
├── databricks.yml              # Main bundle configuration
├── databricks.dev.yml          # Dev environment config
├── databricks.staging.yml      # Staging environment config
├── databricks.prod.yml         # Production environment config
├── setup_bundle.sh             # Setup script (Linux/Mac)
├── setup_bundle.ps1            # Setup script (Windows)
└── README.md                   # This file

```

## Deployment Environments

- **Development**: `databricks bundle deploy --target dev`
- **Staging**: `databricks bundle deploy --target staging`
- **Production**: `databricks bundle deploy --target prod`

## Key Commands

```bash
# Validate configuration
databricks bundle validate

# Preview deployment
databricks bundle deploy --dry-run

# Deploy to environment
databricks bundle deploy --target dev

# Run a job
databricks bundle run banking_bronze_job

# Check deployment status
databricks jobs list | grep Banking
```

## Troubleshooting

See [DATABRICKS_TROUBLESHOOTING.md](./DATABRICKS_TROUBLESHOOTING.md) for common issues and solutions.
