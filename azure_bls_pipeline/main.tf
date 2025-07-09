provider "azurerm" {
  features {}
}

provider "databricks" {
  azure_workspace_resource_id = var.databricks_workspace_resource_id
  azure_client_id             = var.azure_client_id
  azure_client_secret         = var.azure_client_secret
  azure_tenant_id             = var.azure_tenant_id
}

#### this ensures the storage has a unique name
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "${var.storage_account_name}${random_integer.rand.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Blob Container
resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# Queue
resource "azurerm_storage_queue" "queue" {
  name                 = var.queue_name
  storage_account_name = azurerm_storage_account.storage.name
}

# App Service Plan
resource "azurerm_app_service_plan" "plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"
  reserved            = true
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

# Azure Function App
resource "azurerm_function_app" "func" {
  name                       = var.function_app_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  version                    = "~4"
  os_type                    = "linux"

  site_config {
    application_stack {
      python_version = "3.10"
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
    AzureWebJobsStorage      = azurerm_storage_account.storage.primary_connection_string
    STORAGE_ACCOUNT_NAME     = azurerm_storage_account.storage.name
    STORAGE_ACCOUNT_KEY      = azurerm_storage_account.storage.primary_access_key
    POPULATION_URL           = var.population_url
    BLOB_CONTAINER           = var.container_name
    QUEUE_NAME               = var.queue_name
  }
}

# Databricks Notebook (.ipynb)
resource "databricks_notebook" "bls_notebook" {
  path           = "/Shared/bls_notebook"
  language       = "SQL"
  format         = "SOURCE"
  content_base64 = base64encode(file("databricks/bls_notebook.ipynb"))
}

# Databricks Job to run notebook daily
resource "databricks_job" "bls_job" {
  name = "Run BLS Notebook"

  new_cluster {
    spark_version = "13.3.x-scala2.12"
    node_type_id  = "Standard_DS3_v2"
    num_workers   = 2
  }

  notebook_task {
    notebook_path = databricks_notebook.bls_notebook.path
  }

  #### change schedule as needed
  schedule {
    quartz_cron_expression = "0 0 0 * * ?"  # Daily at midnight UTC
    timezone_id            = "UTC"
  }
}
resource "azurerm_application_insights" "app_insights" {
  name                = "${var.function_app_name}-ai"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

resource "azurerm_function_app" "func" {
  # ... existing config ...
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
    AzureWebJobsStorage      = azurerm_storage_account.storage.primary_connection_string
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.app_insights.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.app_insights.connection_string
    # your other settings...
  }
}

