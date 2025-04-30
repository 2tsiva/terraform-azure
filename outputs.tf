output "resource_group_id" {
  value = azurerm_resource_group.sts-rg-1-uks-href.id
}

output "public_ip_address_1" {
  value = azurerm_public_ip.sts-pip-1-uks-href.ip_address
}

output "public_ip_address_2" {
  value = azurerm_public_ip.sts-pip-2-uks-href.ip_address
}

output "linux_vm_name_1" {
  # value = azurerm_linux_virtual_machine.sts-vm-1inux-1-uks-href.computer_name
  value = azurerm_linux_virtual_machine.sts-vm-1inux-1-uks-href.name
}

output "linux_vm_name_2" {
  # value = azurerm_linux_virtual_machine.sts-vm-1inux-1-uks-href.computer_name
  value = azurerm_virtual_machine.sts-vm-1inux-2-uks-href.name
}
