terraform {
backend "remote" {
    resource_group_name  = "state"
    storage_account_name = "statefilestask"
    container_name       = "prod"
    key                 = "prod.terraform.tfstate"
  }
}
