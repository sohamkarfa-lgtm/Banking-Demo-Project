#!/bin/bash
# Databricks Bundle Setup and Deployment Script
# This script automates the setup and deployment process

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Databricks Bundle Setup & Deployment${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Step 1: Check Prerequisites
echo -e "${YELLOW}[Step 1/9] Checking Prerequisites...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗ Python 3 is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Python 3 found: $(python3 --version)${NC}"

# Step 2: Install Databricks CLI
echo -e "${YELLOW}[Step 2/9] Installing Databricks CLI...${NC}"
pip install --upgrade databricks-cli databricks-labs-python-sdk
echo -e "${GREEN}✓ Databricks CLI installed${NC}"

# Step 3: Configure Authentication
echo -e "${YELLOW}[Step 3/9] Configuring Databricks Authentication...${NC}"
echo "Please provide the following information:"
read -p "Enter Databricks Host URL (e.g., https://adb-xxxxx.cloud.databricks.com): " DB_HOST
read -sp "Enter Databricks Personal Access Token: " DB_TOKEN
echo ""

# Create profile
mkdir -p ~/.databrickscfg
echo -e "\n[BANKING_DEMO]\nhost = $DB_HOST\ntoken = $DB_TOKEN" >> ~/.databrickscfg

echo -e "${GREEN}✓ Profile BANKING_DEMO created${NC}"

# Step 4: Test Authentication
echo -e "${YELLOW}[Step 4/9] Testing Databricks Connection...${NC}"
if databricks workspace list --profile BANKING_DEMO > /dev/null; then
    echo -e "${GREEN}✓ Successfully connected to Databricks${NC}"
else
    echo -e "${RED}✗ Failed to connect to Databricks${NC}"
    exit 1
fi

# Step 5: Validate Bundle Configuration
echo -e "${YELLOW}[Step 5/9] Validating Bundle Configuration...${NC}"
if databricks bundle validate --profile BANKING_DEMO; then
    echo -e "${GREEN}✓ Bundle configuration is valid${NC}"
else
    echo -e "${RED}✗ Bundle validation failed${NC}"
    exit 1
fi

# Step 6: Preview Deployment
echo -e "${YELLOW}[Step 6/9] Previewing Deployment (Dry-Run)...${NC}"
databricks bundle deploy --profile BANKING_DEMO --dry-run

# Step 7: Confirm Deployment
echo -e "${YELLOW}[Step 7/9] Ready to Deploy${NC}"
read -p "Do you want to proceed with deployment? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Deployment cancelled${NC}"
    exit 0
fi

# Step 8: Deploy Bundle
echo -e "${YELLOW}[Step 8/9] Deploying Bundle...${NC}"
databricks bundle deploy --profile BANKING_DEMO
echo -e "${GREEN}✓ Bundle deployed successfully${NC}"

# Step 9: Verify Deployment
echo -e "${YELLOW}[Step 9/9] Verifying Deployment...${NC}"
echo -e "\nDeployed Jobs:"
databricks jobs list --profile BANKING_DEMO

echo -e "${GREEN}✓ Deployment Complete!${NC}"
echo -e "\n${BLUE}Next Steps:${NC}"
echo "1. Visit your Databricks workspace: $DB_HOST"
echo "2. Check Workflows > Jobs to see deployed jobs"
echo "3. Run a test job: databricks bundle run banking_bronze_job --profile BANKING_DEMO"
echo ""
