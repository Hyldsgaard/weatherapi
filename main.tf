provider "azurerm" {
    version = "2.5.0"
    features {}
}

terraform {
    backend "azurerm" {
        resource_group_name = "hyd-terraform-storage"
        storage_account_name = "hydterraformsa"
        container_name = "tfstate"
        key = "terraform.tfstate"
    }
}

resource "azurerm_resource_group" "tf_test" {
    name = "hyd-tf-rg"
    location = "westeurope"
    tags = {
        owner = "HYD"
    }
}

resource "azurerm_container_group" "tf_cg" {
    name = "weatherapi"
    location = azurerm_resource_group.tf_test.location
    resource_group_name = azurerm_resource_group.tf_test.name

    ip_address_type = "public"
    dns_name_label = "hyldsgaardwapi"
    os_type = "Linux"

    container {
        name = "weatherapi"
        image = "hyldsgaard/weatherapi"
            cpu = "1"
            memory = "1"

            ports {
                port = 80
                protocol = "TCP"
            }
    }
}