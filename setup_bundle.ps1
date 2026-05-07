# Databricks Bundle Setup & Deployment Script for Windows
# Run this in PowerShell as Administrator

Write-Host "========================================" -ForegroundColor Blue
Write-Host "Databricks Bundle Setup & Deployment" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

# Step 1: Check Prerequisites
Write-Host "[Step 1/9] Checking Prerequisites..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✓ Python found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Python is not installed" -ForegroundColor Red
    exit 1
}

# Step 2: Install Databricks CLI
Write-Host "[Step 2/9] Installing Databricks CLI..." -ForegroundColor Yellow
pip install --upgrade databricks-cli databricks-labs-python-sdk
Write-Host "✓ Databricks CLI installed" -ForegroundColor Green

# Step 3: Configure Authentication
Write-Host "[Step 3/9] Configuring Databricks Authentication..." -ForegroundColor Yellow
$dbHost = Read-Host "Enter Databricks Host URL (e.g., https://adb-xxxxx.cloud.databricks.com)"
$dbToken = Read-Host -AsSecureString "Enter Databricks Personal Access Token"
$plainToken = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbToken))

# Create .databrickscfg directory
$configDir = "$env:USERPROFILE\.databrickscfg"
if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Path $configDir -Force | Out-Null
}

# Add profile to .databrickscfg
$configContent = @"
[BANKING_DEMO]
host = $dbHost
token = $plainToken
"@

Add-Content -Path "$configDir\databrickscfg" -Value $configContent
Write-Host "✓ Profile BANKING_DEMO created" -ForegroundColor Green

# Step 4: Test Authentication
Write-Host "[Step 4/9] Testing Databricks Connection..." -ForegroundColor Yellow
try {
    databricks workspace list --profile BANKING_DEMO | Out-Null
    Write-Host "✓ Successfully connected to Databricks" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to connect to Databricks" -ForegroundColor Red
    exit 1
}

# Step 5: Validate Bundle Configuration
Write-Host "[Step 5/9] Validating Bundle Configuration..." -ForegroundColor Yellow
if (databricks bundle validate --profile BANKING_DEMO) {
    Write-Host "✓ Bundle configuration is valid" -ForegroundColor Green
} else {
    Write-Host "✗ Bundle validation failed" -ForegroundColor Red
    exit 1
}

# Step 6: Preview Deployment
Write-Host "[Step 6/9] Previewing Deployment (Dry-Run)..." -ForegroundColor Yellow
databricks bundle deploy --profile BANKING_DEMO --dry-run

# Step 7: Confirm Deployment
Write-Host "[Step 7/9] Ready to Deploy" -ForegroundColor Yellow
$confirm = Read-Host "Do you want to proceed with deployment? (y/n)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Deployment cancelled" -ForegroundColor Yellow
    exit 0
}

# Step 8: Deploy Bundle
Write-Host "[Step 8/9] Deploying Bundle..." -ForegroundColor Yellow
databricks bundle deploy --profile BANKING_DEMO
Write-Host "✓ Bundle deployed successfully" -ForegroundColor Green

# Step 9: Verify Deployment
Write-Host "[Step 9/9] Verifying Deployment..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Deployed Jobs:" -ForegroundColor Cyan
databricks jobs list --profile BANKING_DEMO

Write-Host ""
Write-Host "✓ Deployment Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Blue
Write-Host "1. Visit your Databricks workspace: $dbHost"
Write-Host "2. Check Workflows > Jobs to see deployed jobs"
Write-Host "3. Run a test job: databricks bundle run banking_bronze_job --profile BANKING_DEMO"
Write-Host ""
