
terraform {
backend "azurerm" {
    resource_group_name  = "state"
    storage_account_name = "statefilestask"
    container_name       = "qaa"
    key                  = "qa.terraform.tfstate"
  }
}
