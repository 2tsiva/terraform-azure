output "resource_group_id" {
  value = azurerm_resource_group.sts-rg-1-uks-href.id
}

output "public_ip_address" {
  value = azurerm_public_ip.sts-pip-1-uks-href.ip_address
}

output "linux_vm_name" {
  value = azurerm_linux_virtual_machine.sts-vm-1inux-1-uks-href.computer_name
}

output "linux_vm_public_ip" {
  value = azurerm_linux_virtual_machine.sts-vm-1inux-1-uks-href.public_ip_address
}