
#Create NiC
resource "azurerm_network_interface" "vm_nic" {

  name                = "nic-${local.common_name}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "the-ip"
    subnet_id                     = data.azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    }
  
   tags = local.tags
}


#Create NSG
resource "azurerm_network_security_group" "vm_nsg" {

  name                = "nsg-${local.common_name}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.vm_rg.name

  #Inbound rules to allow ports
      security_rule {
          name                       = "AllowP"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "*" #["3389","80","5985"]
          source_address_prefix      = "*"
          destination_address_prefix = "*"
       }

   tags = local.tags
}
 

#create the actual VM
resource "azurerm_virtual_machine" "vm" {

  name                  = "vm-${local.common_name}"
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.vm_rg.name
  vm_size               = var.size
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]
 

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.image
    version   = "latest"
  }

  storage_os_disk {
    name              = "${local.computer_name}_OsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.diskType
  }

  os_profile {
    computer_name  = "${local.computer_name}"
    admin_username = var.admin
    admin_password = var.admin_password
    custom_data    = file("./files/winrm.ps1")
  }

  os_profile_windows_config {
    provision_vm_agent = true
    winrm {
      protocol = "HTTP"
    }
    # Auto-Login's required to configure WinRM
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${var.admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin}</Username></AutoLogon>"
    }

    # Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "FirstLogonCommands"
      content      = file("./files/FirstLogonCommands.xml")
    }
  }


   connection {
      host     = azurerm_network_interface.vm_nic.private_ip_address
      type     = "winrm"
      port     = 5985
      https    = false
      timeout  = "300s"
      insecure = "true"
      user     = var.admin
      password = var.admin_password
    }

    provisioner "file" {
      source      = "${path.module}/files/config.ps1" 
      destination = "c:/terraform/config.ps1"
    }
    

    provisioner "remote-exec" {
      inline = [
        "powershell -ExecutionPolicy Unrestricted -File c:\\terraform\\config.ps1 -vm_name vm-${local.common_name}"
 
      ]
    }

    tags = local.tags
  
}






