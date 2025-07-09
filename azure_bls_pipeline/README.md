# Azure BLS Pipeline

# Dear Rearc Friends

# 🙌 Thank You!

Thank you so much for this opportunity! Since I haven't worked with AWS services like Lambda, SQS, or Terraform-based Lambda functions before,  I implemented the equivalent architecture using Azure services.

---

## 🧱 Architecture Choices

-  Used Azure Function App instead of AWS Lambda  
-  Used Azure Queue Storage instead of SQS  
-  Used Terraform to provision all infrastructure (based on a template from work)  
-  Refactored the population API call into a separate Azure Function  
-  Used Application Insights for logging (added at the bottom of the Terraform script)  
-  Created a SAS link to share the bls.gov dataset (though public access is restricted on my tenant)

---

## 📊 Notebook & Data Processing

- I initially wrote the population API logic in the same notebook as the BLS.gov data, but later moved it to an Azure Function to align with the infrastructure-as-code approach.
- I used SQL and temporary views in Databricks for calculations, since the instructions didn’t specify otherwise.
- The requested reports are included inline within the notebook.

---

## ⚠️ Known Issues & Observations

A few things occurred that I would normally troubleshoot, but I was running out of time:

- The population API worked initially, but later began returning 404 errors.
- I used Autoloader for syncing the load, and while schemas were offered, the data was jammed into a single column and had to be parsed manually.
- Some files didn’t resolve to bls-centric schemas — possibly header-only or malformed files.
- The SAS link to the dataset won’t work because public access is not allowed on the tenant I used.
  https://benedettaml7710181910.blob.core.windows.net/bls?sp=r&st=2025-07-09T04:14:33Z&se=2025-07-09T12:14:33Z&spr=https&sv=2024-11-04&sr=c&sig=t%2B4BaxeFxzVK70BbWZKht%2FGQ6a8loIQEUzKizhRmT7w%3D
    
## This project deploys a serverless data pipeline using Terraform that:

- Deploys an Azure Function to fetch population data from an API call
- Writes the data to Azure Blob Storage as JSON
- Sends a message to Azure Queue Storage when the file is written
- Deploys and schedules a Databricks notebook (.ipynb) to run daily to retrieve bls.gov data
- Uses Application Insights to log the results of the azure function/notebook runs

## Project Structure

- `main.tf` – Terraform infrastructure
- `function/` – Azure Function code
- `databricks/` – Databricks notebook (.ipynb)
<!-- - `.github/workflows/` – GitHub Actions CI/CD pipeline -->
