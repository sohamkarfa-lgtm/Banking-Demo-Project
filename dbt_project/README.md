# dbt Demo Project

This is a self-contained demo dbt project built for local execution using the Databricks adapter.

## Install

1. Create and activate a Python virtual environment:
   ```powershell
   python -m venv .venv
   .\.venv\Scripts\activate
   ```
2. Install dbt core and databricks adapter:
   ```powershell
   pip install dbt-core dbt-databricks
   ```

## Configure profiles

Copy `profiles.yml.sample` to your user profile location:

```powershell
copy .\profiles.yml.sample $env:USERPROFILE\.dbt\profiles.yml
```

Then run:

```powershell
dbt debug
```

## Run the demo

```powershell
cd dbt_project
dbt seed
dbt run
dbt test
```
