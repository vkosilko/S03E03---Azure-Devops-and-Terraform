provider "azurerm" {
    version = "2.5.0"
    features {}
}

terraform {
  backend "azurerm" {
    resource_group_name   = "vkosilko"
    storage_account_name  = "testtfstorageacc"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}


resource "azurerm_resource_group" "test_tf" {
  name = "test_tf"
  location = "northeurope"
}

resource "azurerm_container_registry" "terraformcr" {
  name                     = "terraformcr"
  resource_group_name      = azurerm_resource_group.test_tf.name
  location                 = azurerm_resource_group.test_tf.location
  admin_enabled            = true
  sku                      = "Premium"
}


resource "azurerm_container_group" "test_tfcg" {
  name                  = "weatherapi"
  location              = azurerm_resource_group.test_tf.location
  resource_group_name   = azurerm_resource_group.test_tf.name

  ip_address_type       = "public"
  dns_name_label        = "binarythisleapifewa"
  os_type               = "Linux"

  container {
    name             = "weatherapi"
    image            = "terraformcr.azurecr.io/weatherapi:latest"
      cpu               = "1"
      memory            = "1"

      ports {
        port            = "80"
        protocol        = "TCP"
      }
  }
}