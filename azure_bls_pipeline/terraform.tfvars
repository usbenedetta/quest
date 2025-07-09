resource_group_name   = "bls-data-rg"
location              = "Central US"
storage_account_name  = "benedettaml7710181910"
container_name        = "bls"
queue_name            = "jsonnotifications"
function_app_name     = "bls-population-fetcher"
app_service_plan_name = "bls-function-plan"
population_url        = "https://datausa.io/api/data?drilldowns=Nation&measures=Population"

# Databricks credentials
databricks_workspace_resource_id = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Databricks/workspaces/your-workspace"
azure_client_id                  = "your-client-id"
azure_client_secret              = "your-client-secret"
azure_tenant_id                  = "your-tenant-id"
