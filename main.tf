# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  # resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}



# Create resources

resource "azurerm_resource_group" "sts-rg-1-uks-href" {
  name     = var.resource_group_name
  location = "Uk South"
}

resource "azurerm_network_security_group" "sts-nsg-1-uks-href" {
  name                = "sts-nsg-1-uks"
  location            = azurerm_resource_group.sts-rg-1-uks-href.location
  resource_group_name = azurerm_resource_group.sts-rg-1-uks-href.name
}

resource "azurerm_virtual_network" "sts-vn-1-uks-href" {
  name                = "sts-vn-1-uks"
  location            = azurerm_resource_group.sts-rg-1-uks-href.location
  resource_group_name = azurerm_resource_group.sts-rg-1-uks-href.name
  address_space       = ["10.0.0.0/16"]
  # dns_servers         = ["10.0.0.4", "10.0.0.5"]


}

resource "azurerm_subnet" "sts-subnet-1-uks-href" {
  name                 = "sts-subnet-1-uks"
  resource_group_name  = azurerm_resource_group.sts-rg-1-uks-href.name
  virtual_network_name = azurerm_virtual_network.sts-vn-1-uks-href.name
  address_prefixes     = ["10.0.1.0/24"]

  #delegation {
  #  name = "delegation"

  #  service_delegation {
  #    name    = "Microsoft.ContainerInstance/containerGroups"
  #    actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
  #  }
  #}
}

resource "azurerm_subnet" "sts-subnet-2-uks-href" {
  name                 = "sts-subnet-2-uks"
  resource_group_name  = azurerm_resource_group.sts-rg-1-uks-href.name
  virtual_network_name = azurerm_virtual_network.sts-vn-1-uks-href.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}


resource "azurerm_network_security_rule" "sts-nsr-1-uks-href" {
  name                        = "sts-nsr-1-uks-href"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.sts-rg-1-uks-href.name
  network_security_group_name = azurerm_network_security_group.sts-nsg-1-uks-href.name
}

resource "azurerm_network_security_rule" "sts-nsr-2-uks-href" {
  name                        = "sts-nsr-2-uks-href"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  # protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  # destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.sts-rg-1-uks-href.name
  network_security_group_name = azurerm_network_security_group.sts-nsg-1-uks-href.name
}


resource "azurerm_network_security_rule" "sts-nsr-3-uks-href" {
  name                        = "sts-nsr-3-uks-href"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.sts-rg-1-uks-href.name
  network_security_group_name = azurerm_network_security_group.sts-nsg-1-uks-href.name
}



resource "azurerm_subnet_network_security_group_association" "sts-subnet_nsg_as-1-uks-href" {
  subnet_id                 = azurerm_subnet.sts-subnet-1-uks-href.id
  network_security_group_id = azurerm_network_security_group.sts-nsg-1-uks-href.id
}


resource "azurerm_network_interface" "sts-nic-1-uks-href" {
  name                = "sts-nic-1-uks"
  location            = azurerm_resource_group.sts-rg-1-uks-href.location
  resource_group_name = azurerm_resource_group.sts-rg-1-uks-href.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sts-subnet-1-uks-href.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sts-pip-1-uks-href.id
  }
}

resource "azurerm_network_interface" "sts-nic-2-uks-href" {
  name                = "sts-nic-2-uks"
  location            = azurerm_resource_group.sts-rg-1-uks-href.location
  resource_group_name = azurerm_resource_group.sts-rg-1-uks-href.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sts-subnet-1-uks-href.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sts-pip-2-uks-href.id
  }
}



resource "azurerm_public_ip" "sts-pip-1-uks-href" {
  name                = "sts-pip-1-uks"
  resource_group_name = azurerm_resource_group.sts-rg-1-uks-href.name
  location            = azurerm_resource_group.sts-rg-1-uks-href.location
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "sts-pip-2-uks-href" {
  name                = "sts-pip-2-uks"
  resource_group_name = azurerm_resource_group.sts-rg-1-uks-href.name
  location            = azurerm_resource_group.sts-rg-1-uks-href.location
  allocation_method   = "Static"
}



resource "azurerm_linux_virtual_machine" "sts-vm-1inux-1-uks-href" {
  name                = var.linux_virtual_machine_name_1
  resource_group_name = azurerm_resource_group.sts-rg-1-uks-href.name
  location            = azurerm_resource_group.sts-rg-1-uks-href.location
  size                = "Standard_F2"
  network_interface_ids = [azurerm_network_interface.sts-nic-1-uks-href.id]

  
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false


  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

}


resource "azurerm_virtual_machine" "sts-vm-1inux-2-uks-href" {
  name                  = "sts-vm-1inux-2-uks"
  location              = azurerm_resource_group.sts-rg-1-uks-href.location
  resource_group_name   = azurerm_resource_group.sts-rg-1-uks-href.name
  network_interface_ids = [azurerm_network_interface.sts-nic-2-uks-href.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "sts-osd-1inux-2-uks"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "sts-vm-1inux-2-uks"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}