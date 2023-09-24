provider "azurerm" {
  features {}
}

module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = var.environment
}

module "security" {
  source              = "./modules/security"
  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = var.environment
  public_subnets = {
    public = module.network.public_subnet # Pass the public subnet reference
  }
}


