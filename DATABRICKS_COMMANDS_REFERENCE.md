# Quick Reference: Databricks Bundle Commands

## Setup Commands

### 1. Install CLI and SDKs
```bash
pip install databricks-cli databricks-labs-python-sdk
```

### 2. Configure Authentication
```bash
# Interactive configuration
databricks configure --token --profile BANKING_DEMO

# Or set environment variables
export DATABRICKS_HOST=https://adb-xxxxx.cloud.databricks.com
export DATABRICKS_TOKEN=dapi_xxxxxxxxxxxxx
```

### 3. Test Connection
```bash
databricks workspace list --profile BANKING_DEMO
```

## Bundle Commands

### 4. Validate Configuration
```bash
# Validate current directory bundle
databricks bundle validate

# Validate specific target
databricks bundle validate --target dev
databricks bundle validate --target staging
databricks bundle validate --target prod

# Verbose validation
databricks bundle validate --verbose
```

### 5. Preview Deployment (Dry Run)
```bash
# See what will be deployed without making changes
databricks bundle deploy --dry-run
databricks bundle deploy --target dev --dry-run
```

### 6. Deploy Bundle
```bash
# Deploy to development
databricks bundle deploy --target dev

# Deploy to staging
databricks bundle deploy --target staging

# Deploy to production
databricks bundle deploy --target prod

# Deploy with specific profile
databricks bundle deploy --profile BANKING_DEMO
```

### 7. Run Jobs
```bash
# List all resources in bundle
databricks bundle list

# Run specific job
databricks bundle run banking_bronze_job

# Run with target environment
databricks bundle run banking_bronze_job --target prod

# Run job and wait for completion
databricks jobs run-now --job-id <job_id> --wait
```

### 8. Monitor Execution
```bash
# List all job runs
databricks jobs list-runs --job-name "Banking_Bronze_Ingestion"

# Get specific run details
databricks runs get --run-id <run_id>

# Get run output/logs
databricks runs get-output --run-id <run_id>

# Stream logs in real-time
databricks runs get --run-id <run_id> --watch
```

### 9. Workspace Operations
```bash
# List workspace items
databricks workspace list /Shared/banking-demo

# Import notebooks
databricks workspace import --source-format SOURCE_CODE ./notebooks/01_bronze_notebook.py /Shared/banking-demo/01_bronze_notebook

# Export notebooks
databricks workspace export /Shared/banking-demo/01_bronze_notebook --format SOURCE_CODE
```

### 10. Cluster Operations
```bash
# List all clusters
databricks clusters list

# Get cluster details
databricks clusters get --cluster-id <cluster_id>

# Start cluster
databricks clusters start --cluster-id <cluster_id>

# Stop cluster
databricks clusters permanentDelete --cluster-id <cluster_id>
```

### 11. Job Management
```bash
# List all jobs
databricks jobs list

# Get job details
databricks jobs get --job-id <job_id>

# Trigger job run
databricks jobs run-now --job-id <job_id>

# Cancel job run
databricks runs cancel --run-id <run_id>

# Delete job
databricks jobs delete --job-id <job_id>
```

## Advanced Commands

### 12. Deploy with Variable Overrides
```bash
# Set variables at deploy time
databricks bundle deploy \
  --var "notebook_path=/Shared/custom-path" \
  --var "num_workers=4"
```

### 13. Destroy Bundle Resources
```bash
# Dry-run destruction
databricks bundle destroy --dry-run

# Destroy all resources
databricks bundle destroy

# Confirm destruction prompt
databricks bundle destroy --force
```

### 14. Update and Redeploy
```bash
# After making changes to databricks.yml or notebooks:
databricks bundle validate
databricks bundle deploy --target dev
```

### 15. Rollback (Manual)
```bash
# Export current workspace state
databricks workspace export /Shared/banking-demo --format SOURCE_CODE --output-dir ./backup

# Destroy current bundle
databricks bundle destroy --target dev

# Redeploy previous version from Git
git checkout <previous-commit>
databricks bundle deploy --target dev
```

## Environment-Specific Deployment

### For Development
```bash
databricks bundle deploy --target dev
databricks bundle run banking_bronze_job --target dev
```

### For Staging
```bash
databricks bundle deploy --target staging
databricks bundle run banking_bronze_job --target staging
```

### For Production
```bash
# With approval workflow
databricks bundle deploy --target prod --dry-run
# Review output...
databricks bundle deploy --target prod
```

## Troubleshooting Commands

### Check Configuration
```bash
# Print resolved bundle configuration
databricks bundle debug

# Show all variables
databricks bundle inspect
```

### Test Profile
```bash
# List profiles
cat ~/.databrickscfg

# Test specific profile
databricks workspace list --profile BANKING_DEMO
```

### Verify Deployment
```bash
# Check if jobs exist
databricks jobs list | grep Banking

# Check if notebooks exist
databricks workspace list /Shared/banking-demo

# Verify cluster configuration
databricks clusters get --cluster-id <cluster_id>
```

## Common Workflows

### Initial Setup
```bash
1. databricks configure --token --profile BANKING_DEMO
2. databricks workspace list --profile BANKING_DEMO
3. databricks bundle validate
4. databricks bundle deploy --target dev
5. databricks bundle run banking_bronze_job --target dev
```

### Update and Redeploy
```bash
1. Edit databricks.yml or notebooks
2. databricks bundle validate
3. databricks bundle deploy --target dev --dry-run
4. databricks bundle deploy --target dev
```

### Monitor Job Execution
```bash
1. databricks jobs list-runs --job-name "Banking_Bronze_Ingestion"
2. databricks runs get --run-id <latest-run-id>
3. databricks runs get-output --run-id <latest-run-id>
```

### Promote to Production
```bash
1. databricks bundle validate --target prod
2. databricks bundle deploy --target prod --dry-run
3. Review and approve changes
4. databricks bundle deploy --target prod
5. databricks bundle run banking_bronze_job --target prod
```

## Tips & Best Practices

- **Always validate before deploying**: `databricks bundle validate`
- **Use dry-run for production**: `databricks bundle deploy --dry-run --target prod`
- **Keep profiles in ~/.databrickscfg**: Avoid hardcoding credentials
- **Use environment variables for CI/CD**: Export DATABRICKS_HOST and DATABRICKS_TOKEN
- **Test in dev first**: Deploy to dev before staging/prod
- **Monitor jobs regularly**: Check logs after each deployment
- **Version your bundle**: Commit all changes to Git
- **Document variables**: Maintain a README with variable descriptions
