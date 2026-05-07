# Databricks Bundle Troubleshooting Guide

## Common Issues and Solutions

### 1. Authentication Issues

#### Error: "Unauthorized. Ensure correct credentials in profile"
```
Error: Unauthorized
```

**Solution:**
```bash
# Verify token is still valid (tokens can expire)
# Regenerate token in Databricks UI:
# Settings > User Settings > Access Tokens > Generate New Token

# Reconfigure profile
databricks configure --token --profile BANKING_DEMO

# Test connection
databricks workspace list --profile BANKING_DEMO

# For CI/CD, ensure environment variables are set:
export DATABRICKS_HOST=https://adb-xxxxx.cloud.databricks.com
export DATABRICKS_TOKEN=dapi_xxxxxxxxxxxxx
```

#### Error: "Profile 'BANKING_DEMO' not found"
```
Error: Profile BANKING_DEMO not found in ~/.databrickscfg
```

**Solution:**
```bash
# Create the profile
databricks configure --token --profile BANKING_DEMO

# Or manually edit ~/.databrickscfg:
cat >> ~/.databrickscfg << EOF
[BANKING_DEMO]
host = https://adb-xxxxx.cloud.databricks.com
token = dapi_xxxxxxxxxxxxx
EOF

# Verify profile exists
cat ~/.databrickscfg | grep BANKING_DEMO
```

---

### 2. Configuration Validation Issues

#### Error: "Unknown field in resource configuration"
```
Error: Unknown field 'invalid_field' in jobs configuration
```

**Solution:**
```bash
# Check YAML syntax using a validator:
# https://www.yamllint.com/

# Compare with official Databricks documentation:
# https://docs.databricks.com/en/dev-tools/bundles/

# Common typos to check:
# - notebook_task vs notebook-task
# - base_parameters vs base-parameters
# - max_retries vs max-retries

# Run verbose validation to get details:
databricks bundle validate --verbose
```

#### Error: "Variable not found: ${var.undefined_variable}"
```
Error: Variable 'undefined_variable' not defined
```

**Solution:**
```yaml
# Ensure all variables used are defined in databricks.yml:
variables:
  undefined_variable:
    description: Description of the variable
    default: some_value

# Or use defined variables:
# Use: ${var.notebook_path}
# Don't use: ${var.undefined_var}

# List all available variables:
databricks bundle inspect
```

---

### 3. Notebook Path Issues

#### Error: "Notebook path /Shared/banking-demo/01_bronze_notebook not found"
```
Error: Resource not found: /Shared/banking-demo/01_bronze_notebook
```

**Solution:**
```bash
# Check if notebooks exist in workspace
databricks workspace list /Shared/banking-demo

# Verify source file path in bundle config
# In databricks.yml, check the 'source' field:
#   source: ../notebooks/01_bronze_notebook.py  # Must exist locally

# Upload notebooks first:
databricks workspace import \
  --source-format SOURCE_CODE \
  ./notebooks/01_bronze_notebook.py \
  /Shared/banking-demo/01_bronze_notebook

# Or let bundle handle it (notebooks section will auto-deploy)
# Ensure bundle deploy completes successfully first:
databricks bundle deploy --target dev

# Verify deployment:
databricks workspace list /Shared/banking-demo
```

#### Error: "Source file ../notebooks/01_bronze_notebook.py not found"
```
Error: Source file not found: ../notebooks/01_bronze_notebook.py
```

**Solution:**
```bash
# Check file exists
ls -la ./notebooks/01_bronze_notebook.py  # Linux/Mac
dir notebooks\01_bronze_notebook.py       # Windows

# Verify path from bundle directory
# If running from project root:
#   source: ./notebooks/01_bronze_notebook.py
# If running from databricks/ subdirectory:
#   source: ../notebooks/01_bronze_notebook.py

# Ensure working directory is correct
pwd  # Should be project root
```

---

### 4. Cluster and Resource Issues

#### Error: "No available clusters matching resource specifications"
```
Error: No available clusters match: node_type_id=i3.2xlarge, num_workers=4
```

**Solution:**
```yaml
# Reduce resource requirements in databricks.yml:
new_cluster:
  spark_version: "13.3.x-scala2.12"
  node_type_id: i3.xlarge        # Smaller node type
  num_workers: 2                 # Fewer workers

# Check available node types in workspace:
# Workspace Settings > Compute > Available instance types

# Common instance types by region:
# AWS: i3.xlarge, i3.2xlarge, i4i.xlarge, m5.xlarge
# Azure: Standard_DS3_v2, Standard_DS4_v2
# GCP: n1-highmem-4, n1-highmem-8
```

#### Error: "Job cluster resource exhausted"
```
Error: Workspace cluster resource quota exceeded
```

**Solution:**
```bash
# Check workspace quotas
# Workspace Settings > Compute > Resource quotas

# Scale down cluster configuration:
databricks bundle deploy \
  --var "num_workers=1" \
  --var "node_type=i3.xlarge"

# Use existing cluster instead of creating new one:
# Add to jobs section:
# existing_cluster_id: <cluster_id>

# List available clusters:
databricks clusters list
```

---

### 5. Job Execution Issues

#### Error: Job run failed with "Notebook not found"
```
Error: Notebook not found at path /Shared/banking-demo/01_bronze_notebook
```

**Solution:**
```bash
# Ensure notebooks are deployed first
databricks bundle deploy --target dev

# Verify notebook exists
databricks workspace list /Shared/banking-demo

# Check exact notebook path in workspace
# Might need to add .py extension or check case sensitivity

# Manually run to test
databricks workspace run /Shared/banking-demo/01_bronze_notebook
```

#### Error: "Job timed out after 3600 seconds"
```
Error: Job run timed out after 3600 seconds
```

**Solution:**
```yaml
# Increase timeout in databricks.yml:
tasks:
  - task_key: bronze_layer
    timeout_seconds: 7200        # Increased to 2 hours

# Or optimize the notebook for performance:
# - Add partitioning to data
# - Use parallel processing
# - Cache intermediate results
# - Profile slow operations
```

#### Error: "Task failed with error code 1"
```
Error: Task 'bronze_layer' failed with error code 1
```

**Solution:**
```bash
# Get detailed error logs
databricks runs get-output --run-id <run_id>

# Stream logs in real-time
databricks runs get --run-id <run_id> --watch

# Check notebook execution
# Go to Databricks workspace and manually run notebook to see errors

# Common causes:
# 1. Missing dependencies (install in notebook)
# 2. Data format issues (validate data path)
# 3. Permission issues (check workspace ACLs)
# 4. Schema mismatches (validate data structure)
```

---

### 6. Deployment Issues

#### Error: "Bundle deploy failed"
```
Error: Failed to deploy bundle
```

**Solution:**
```bash
# Run validation first
databricks bundle validate --verbose

# Try dry-run to see what would happen
databricks bundle deploy --dry-run

# Check permissions
# Ensure you have:
# - Admin or Developer role
# - Permission to create jobs
# - Permission to access workspace paths

# Try deploying specific resource
# Identify which part fails and debug individually
```

#### Error: "Workspace path already exists"
```
Error: /Shared/banking-demo already exists
```

**Solution:**
```bash
# Delete existing path first
databricks workspace delete --recursive /Shared/banking-demo

# Or change deployment path
# Edit databricks.yml:
variables:
  notebook_path: /Shared/banking-demo-v2

# Or use overwrite flag (if supported)
databricks bundle deploy --force
```

---

### 7. Profile and Environment Issues

#### Error: "~/.databrickscfg: No such file or directory"
```
Error: Configuration file ~/.databrickscfg not found
```

**Solution:**
```bash
# Create configuration directory
mkdir -p ~/.databrickscfg

# Configure profile
databricks configure --token --profile BANKING_DEMO

# Or set environment variables instead
export DATABRICKS_HOST=https://adb-xxxxx.cloud.databricks.com
export DATABRICKS_TOKEN=dapi_xxxxxxxxxxxxx
```

#### Error: "Multiple profiles found, specify --profile"
```
Error: Multiple profiles defined. Specify which profile to use with --profile
```

**Solution:**
```bash
# Specify profile explicitly
databricks bundle deploy --profile BANKING_DEMO
databricks bundle validate --profile BANKING_DEMO

# Or set default profile
export DATABRICKS_HOST=...
export DATABRICKS_TOKEN=...
```

---

### 8. Debugging Techniques

#### Enable Verbose Logging
```bash
# Most detailed output
databricks bundle validate --verbose
databricks bundle deploy --verbose

# For API-level debugging (Linux/Mac)
DEBUG=1 databricks bundle deploy

# For Windows PowerShell
$env:DEBUG = "1"; databricks bundle deploy
```

#### Inspect Bundle Configuration
```bash
# See fully resolved configuration
databricks bundle inspect

# Output to file for review
databricks bundle inspect > bundle_config.json
```

#### Test Individual Commands
```bash
# Test workspace access
databricks workspace list /

# Test job creation manually
databricks jobs create --json-file job-config.json

# Test notebook upload
databricks workspace import --source-format SOURCE_CODE \
  ./notebooks/01_bronze_notebook.py \
  /Shared/banking-demo/01_bronze_notebook
```

#### Check Workspace Health
```bash
# List clusters
databricks clusters list

# List jobs
databricks jobs list

# Check workspace usage
databricks workspace list /Shared

# View recent runs
databricks runs list --job-name "Banking_Bronze_Ingestion"
```

---

### 9. Rollback Procedures

#### If Deployment Goes Wrong
```bash
# 1. Stop any running jobs
databricks jobs run-now --job-id <job_id> --wait

# 2. Destroy current deployment
databricks bundle destroy --target dev

# 3. Verify removal
databricks workspace list /Shared/banking-demo
databricks jobs list | grep Banking

# 4. Check out previous version from Git
git checkout <previous-commit>

# 5. Redeploy from previous version
databricks bundle deploy --target dev

# 6. Verify deployment
databricks jobs list | grep Banking
```

---

### 10. Performance Optimization

#### Slow Job Execution
```yaml
# Optimize cluster configuration:
new_cluster:
  spark_version: "13.3.x-scala2.12"
  node_type_id: i3.2xlarge       # Larger instances
  num_workers: 4                 # More parallelism
  spark_conf:
    "spark.sql.shuffle.partitions": "200"
    "spark.default.parallelism": "200"

# Increase timeout if needed
timeout_seconds: 7200
```

#### Bundle Deploy Takes Too Long
```bash
# Check what's being deployed
databricks bundle deploy --dry-run

# Deploy only specific resources (if supported)
# Or split into multiple bundles:
# - databricks-bronze.yml
# - databricks-silver.yml
# - databricks-gold.yml
```

---

## Quick Diagnostic Checklist

```bash
□ Check CLI version: databricks --version
□ Test authentication: databricks workspace list --profile BANKING_DEMO
□ Validate bundle: databricks bundle validate --verbose
□ Check file paths exist: ls -la notebooks/
□ Verify variables: databricks bundle inspect
□ Dry run deploy: databricks bundle deploy --dry-run
□ Check workspace access: databricks workspace list /Shared
□ Review job definitions: databricks jobs list | grep Banking
□ Check recent runs: databricks runs list --job-name "..."
□ Review logs: databricks runs get-output --run-id <run_id>
```

---

## Support Resources

- **Databricks Documentation**: https://docs.databricks.com/
- **Bundle Documentation**: https://docs.databricks.com/en/dev-tools/bundles/
- **CLI Reference**: https://docs.databricks.com/en/dev-tools/cli/
- **API Documentation**: https://docs.databricks.com/api/
- **Community Forums**: https://community.databricks.com/

---
