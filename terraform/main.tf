// Variables
variable "astra_token" {
  type = string
}

// Define the Astra provider for Terraform
terraform {
  backend "azurerm" {
    resource_group_name  = "StorageAccount-ResourceGroup"
    storage_account_name = "stdemotfstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
    // access_key = "export ARM_ACCESS_KEY environment variable"
  }
  required_providers {
    astra = {
      source  = "datastax/astra"
      version = "1.0.11"
    }
  }
}

// Provide your Astra token
provider "astra" {
  // Will read from environment variable ASTRA_API_TOKEN, else define as follows:
  token = var.astra_token
}

// Get the regions that are available within Astra
data "astra_available_regions" "regions" {
}

// Output the regions
output "available_regions" {
  value = [for region in data.astra_available_regions.regions.results : "${region.cloud_provider}, ${region.display_name}, ${region.region}, ${region.zone}"]
}

data "astra_databases" "databaselist" {
  status = "ONLINE"
}

output "existing_dbs" {
  value = [for db in data.astra_databases.databaselist.results : db.id]
}

// Create the database and initial keyspace
resource "astra_database" "dev" {
  name           = "development"
  keyspace       = "cloudops"
  cloud_provider = "AZURE"
  region         = "eastus2"
}

// Get the location of the secure connect bundle
data "astra_secure_connect_bundle_url" "dev" {
  database_id = astra_database.dev.id
}

// Output the created database id
output "database_id" {
  value = astra_database.dev.id
}

// Output the download location for the secure connect bundle
output "secure_connect_bundle_url" {
  value = data.astra_secure_connect_bundle_url.dev.url
}
