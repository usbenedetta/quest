# Azure BLS Pipeline

# Dear Rearc Friends

    Thank you so much for this opportunity! 
    I have never used AWS, or an SQS queue or a terraform Lambda function but seems like these might be AWS things. So I provided the same in Azure.  
    For the terraform I used a template from work (gasp!) because I don't write very many terraform scripts. For the population API call, I initially wrote it in the same notebook as the bls.gov data, but then rewrote it as an Azure function to go with this script.
    Application Insights can be used for logging - added to bottom of this script
    I wrote calculations using SQL/tempviews because the instructions didn't say not to.
    Requested reports are inline with the notebook
    There's no "publish" in Azure - created this SAS link to view the bls.gov datasets....but public access is not allowed on the tenant that I used so the link won't work.

    https://benedettaml7710181910.blob.core.windows.net/bls?sp=r&st=2025-07-09T04:14:33Z&se=2025-07-09T12:14:33Z&spr=https&sv=2024-11-04&sr=c&sig=t%2B4BaxeFxzVK70BbWZKht%2FGQ6a8loIQEUzKizhRmT7w%3D
    

    A few things occurred that I would normally troubleshoot, but was running out of time:
    - I didn't have any trouble with the population API....until it started throwing a 404 error.
    - I used Autoloader for "syncing" the load and although schemas were offered.....it jammed all the data into one column which I then had  to parse to read.
    - Certain of the files didn't resolve to bls centric schemas - maybe they are only header files
    - It needs a GitHub Actions CI/CD pipeline

This project deploys a serverless data pipeline using Terraform that:

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
