# Create network interface vm1
resource "azurerm_network_interface" "nic-vms" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create Virtual Machine (VMS)
resource "azurerm_linux_virtual_machine" "vms" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  #admin_password                  = var.admin_password
  #disable_password_authentication = false

  admin_ssh_key {
    public_key = file("~/.ssh/id_rsa.pub")
    username   = var.admin_username
  }


  zone = var.vm_zone
  network_interface_ids = [
    azurerm_network_interface.nic-vms.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }


  # Remote provisioner added to automate Docker install
  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      user        = var.admin_username
      host        = var.host_ip
      port        = var.nat_port
      private_key = file("~/.ssh/id_rsa")
      timeout     = "5m"
    }
    inline = [
      "sudo apt update",
      "sudo apt install apt-transport-https ca-certificates curl software-properties-common -y ",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - ",
      "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'",
      "apt-cache policy docker-ce",
      "sudo apt install docker-ce -y",
      "sudo usermod -aG docker ${var.admin_username}",
      "sudo chmod 666 /var/run/docker.sock"

    ]
  }
}

# NIC & NSG (association) - VMS
resource "azurerm_network_interface_security_group_association" "nsg-nic-vms" {
  network_interface_id      = azurerm_network_interface.nic-vms.id
  network_security_group_id = var.network_security_group_id
}

# NIC VMS & Nat rule association
resource "azurerm_network_interface_nat_rule_association" "nic_natrule_association-vms" {
  ip_configuration_name = azurerm_network_interface.nic-vms.ip_configuration[0].name
  nat_rule_id           = var.nat_rule_id
  network_interface_id  = azurerm_network_interface.nic-vms.id
}

# Backend Pool and NIC vm1 - association
resource "azurerm_network_interface_backend_address_pool_association" "backend_pool_association-vms" {
  backend_address_pool_id = var.backend_address_pool_id
  ip_configuration_name   = azurerm_network_interface.nic-vms.ip_configuration[0].name
  network_interface_id    = azurerm_network_interface.nic-vms.id
}
