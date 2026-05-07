# Databricks Bundle Deployment - Quick Start

## 📋 Overview
This guide provides a condensed, step-by-step procedure to deploy the Banking-Demo-Project to Databricks using Databricks Automation Bundle.

---

## ⚡ Quick Start (5 Minutes)

### Step 1: Install Databricks CLI
```bash
pip install databricks-cli databricks-labs-python-sdk
```

### Step 2: Authenticate with Databricks
```bash
# Get your Personal Access Token from Databricks UI:
# Settings > User Settings > Access Tokens > Generate New Token

# Configure authentication
databricks configure --token --profile BANKING_DEMO

# You'll be prompted for:
# - Databricks Host: https://adb-xxxxx.cloud.databricks.com
# - Token: Your PAT
```

### Step 3: Verify Connection
```bash
databricks workspace list --profile BANKING_DEMO
```

### Step 4: Validate Bundle
```bash
databricks bundle validate
```

### Step 5: Deploy
```bash
databricks bundle deploy --target dev
```

### Step 6: Verify Deployment
```bash
databricks jobs list | grep Banking
```

**Done!** Check your Databricks workspace > Workflows > Jobs to see deployed jobs.

---

## 📁 Files Created

| File | Purpose |
|------|---------|
| `databricks.yml` | Main bundle configuration |
| `databricks.dev.yml` | Development environment overrides |
| `databricks.staging.yml` | Staging environment overrides |
| `databricks.prod.yml` | Production environment overrides |
| `setup_bundle.sh` | Automated setup script (Linux/Mac) |
| `setup_bundle.ps1` | Automated setup script (Windows) |
| `DATABRICKS_BUNDLE_DEPLOYMENT_GUIDE.md` | Detailed 17-step guide |
| `DATABRICKS_COMMANDS_REFERENCE.md` | Command reference |
| `DATABRICKS_TROUBLESHOOTING.md` | Troubleshooting guide |

---

## 🎯 Core Concepts

### Variables
Configurable values in `databricks.yml`:
```yaml
variables:
  notebook_path: /Shared/banking-demo
  data_path: /Volumes/main/default/banking_data
  node_type: i3.xlarge
  num_workers: 2
```

### Resources
What gets deployed:
- **Jobs**: `banking_bronze_job`, `banking_silver_job`, `banking_gold_job`
- **Notebooks**: `01_bronze_notebook.py`, `02_silver_notebook.py`, `03_gold_notebook.py`

### Targets
Different environments:
- **dev**: Development deployment
- **staging**: Staging deployment
- **prod**: Production deployment

---

## 🔑 Common Commands

```bash
# Validation
databricks bundle validate
databricks bundle validate --target prod

# Preview (Dry-Run)
databricks bundle deploy --dry-run

# Deploy
databricks bundle deploy --target dev
databricks bundle deploy --target staging
databricks bundle deploy --target prod

# Run Jobs
databricks bundle run banking_bronze_job
databricks bundle run banking_bronze_job --target prod

# Monitor
databricks jobs list
databricks jobs list-runs --job-name "Banking_Bronze_Ingestion"
databricks runs get-output --run-id <run_id>

# Cleanup
databricks bundle destroy --target dev
```

---

## 🚀 Deployment Workflow

### For Development
```bash
# 1. Validate
databricks bundle validate --target dev

# 2. Deploy
databricks bundle deploy --target dev

# 3. Run test job
databricks bundle run banking_bronze_job --target dev

# 4. Monitor
databricks jobs list-runs --job-name "Banking_Bronze_Ingestion"
```

### For Production
```bash
# 1. Validate for prod
databricks bundle validate --target prod

# 2. Dry-run to see what will be deployed
databricks bundle deploy --target prod --dry-run

# 3. Review output and confirm

# 4. Deploy to production
databricks bundle deploy --target prod

# 5. Verify
databricks jobs list | grep Banking
```

---

## ⚙️ Configuration Customization

### Change Notebook Path
Edit `databricks.yml`:
```yaml
variables:
  notebook_path: /Shared/my-custom-path
```

### Change Cluster Size
Edit `databricks.yml`:
```yaml
variables:
  node_type: i3.2xlarge
  num_workers: 4
```

### Add Environment Variable
Edit `databricks.yml`:
```yaml
variables:
  my_custom_var:
    description: My custom variable
    default: default_value
```

### Override Variables at Deploy Time
```bash
databricks bundle deploy \
  --var "notebook_path=/Shared/custom-path" \
  --var "num_workers=4"
```

---

## 📊 Monitoring Deployments

### Check Job Status
```bash
databricks jobs list
```

### View Job Runs
```bash
databricks jobs list-runs --job-name "Banking_Bronze_Ingestion" --limit 10
```

### Get Run Output
```bash
databricks runs get-output --run-id <run_id>
```

### Stream Logs
```bash
databricks runs get --run-id <run_id> --watch
```

---

## ⚠️ Common Issues & Quick Fixes

| Issue | Solution |
|-------|----------|
| `Profile not found` | Run: `databricks configure --token --profile BANKING_DEMO` |
| `Unauthorized` | Regenerate token in Databricks UI and reconfigure |
| `Notebook not found` | Ensure `databricks bundle deploy` completes successfully first |
| `Validation failed` | Run: `databricks bundle validate --verbose` to see details |
| `Timeout` | Increase `timeout_seconds` in job configuration |
| `No clusters available` | Reduce `num_workers` or use smaller `node_type` |

For more issues, see `DATABRICKS_TROUBLESHOOTING.md`

---

## 🔄 Updating Deployments

### Update Notebook Code
```bash
# 1. Edit your notebook file: notebooks/01_bronze_notebook.py
# 2. Validate bundle
databricks bundle validate

# 3. Redeploy
databricks bundle deploy --target dev

# 4. Manually re-run job from Databricks UI or CLI
databricks jobs run-now --job-id <job_id> --wait
```

### Update Job Configuration
```bash
# 1. Edit databricks.yml
# 2. Validate and deploy
databricks bundle validate
databricks bundle deploy --target dev
```

---

## 🔐 Authentication Options

### Option 1: Profile Configuration (Recommended)
```bash
# Create profile
databricks configure --token --profile BANKING_DEMO

# Use it
databricks bundle deploy --profile BANKING_DEMO
```

### Option 2: Environment Variables
```bash
export DATABRICKS_HOST=https://adb-xxxxx.cloud.databricks.com
export DATABRICKS_TOKEN=dapi_xxxxxxxxxxxxx

# Now just use
databricks bundle deploy
```

### Option 3: For CI/CD Pipelines
```yaml
# In GitHub Actions or other CI/CD:
env:
  DATABRICKS_HOST: ${{ secrets.DATABRICKS_HOST }}
  DATABRICKS_TOKEN: ${{ secrets.DATABRICKS_TOKEN }}
```

---

## 📚 Full Documentation

For comprehensive guides, see:
- **Full Setup Guide**: `DATABRICKS_BUNDLE_DEPLOYMENT_GUIDE.md`
- **Command Reference**: `DATABRICKS_COMMANDS_REFERENCE.md`
- **Troubleshooting**: `DATABRICKS_TROUBLESHOOTING.md`

---

## 🎓 Next Steps

1. ✅ Run setup script or follow Quick Start
2. ✅ Deploy to dev environment
3. ✅ Test jobs in Databricks workspace
4. ✅ Deploy to staging environment
5. ✅ Set up CI/CD pipeline for automated deployments
6. ✅ Deploy to production
7. ✅ Configure monitoring and alerts

---

## 💡 Pro Tips

- **Always use `--dry-run` for prod**: `databricks bundle deploy --target prod --dry-run`
- **Test in dev first**: Always deploy to dev environment before other environments
- **Version your bundle**: Commit all changes to Git
- **Monitor job runs**: Check logs after each deployment
- **Use meaningful names**: Keep job and notebook names descriptive
- **Document variables**: Maintain a README with variable descriptions
- **Separate profiles per environment**: Prevents accidental deployments

---

## 📞 Support

- **Databricks Docs**: https://docs.databricks.com/en/dev-tools/bundles/
- **Bundle CLI**: https://docs.databricks.com/en/dev-tools/cli/
- **Questions**: Contact your Databricks account manager

---

**Happy Deploying! 🚀**
