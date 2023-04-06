# INSTALL & CONFIG WINRM
Write-Host "Delete any existing WinRM listeners"
winrm delete winrm/config/listener?Address=*+Transport=HTTP  2>$Null
winrm delete winrm/config/listener?Address=*+Transport=HTTPS 2>$Null

Write-Host "Create a new WinRM listener and configure"
winrm create winrm/config/listener?Address=*+Transport=HTTP
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="0"}'
winrm set winrm/config '@{MaxTimeoutms="7200000"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service '@{MaxConcurrentOperationsPerUser="12000"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client/auth '@{Basic="true"}'

Write-Host "Configure UAC to allow privilege elevation in remote shells"
$Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$Setting = 'LocalAccountTokenFilterPolicy'
Set-ItemProperty -Path $Key -Name $Setting -Value 1 -Force

Write-Host "turn off PowerShell execution policy restrictions"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine

Write-Host "Configure and restart the WinRM Service; Enable the required firewall exception"
Stop-Service -Name WinRM
Set-Service -Name WinRM -StartupType Automatic
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new action=allow localip=any remoteip=any
Start-Service -Name WinRM


Start-Sleep -Seconds 2

# Install IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools

#Wait 2s
Start-Sleep -Seconds 2


# Download antivirus
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://github.com/EurysPikulas/Antivirus-su/raw/main/QualysCloudAgent.exe -OutFile c:\terraform\QualysCloudAgent.exe
Invoke-WebRequest -Uri https://github.com/EurysPikulas/Antivirus-su/raw/main/WindowsSensor.exe -OutFile c:\terraform\WindowsSensor.exe


#Wait 2s
Start-Sleep -Seconds 2


#Install QualysCloudAgent
Start-Process -FilePath  C:\terraform\QualysCloudAgent.exe -ArgumentList "CustomerId={f5845722-29e7-5170-802b-b96290c5e87d} ActivationId={bd208cdc-07e7-443d-8a2e-44a8039d4f33} WebServiceUri=//qagpublic.qg2.apps.qualys.eu/CloudAgent/"   

#Wait 2s
Start-Sleep -Seconds 1

#Install WindowsSensor
Start-Process -FilePath  C:\terraform\WindowsSensor.exe -ArgumentList "/install /norestart CID=6E6E6BD048F64D1EA5BC75F714CEB9FF-D9  GROUPING_TAGS=SES-3S-SW,WayoProd,Prod" 


#Wait 5s
Start-Sleep -Seconds 5


# Select WindowsSensor windows
$notepadWindow = Get-Process -Name notepad | Select-Object -First 1 | Foreach-Object {$_.MainWindowHandle}
[Windows.Win32.User32]::SetForegroundWindow($notepadWindow)



#Wait 3s
Start-Sleep -Seconds 3



Add-Type -AssemblyName Microsoft.VisualBasic
$app = Get-Process | Where-Object {$_.MainWindowTitle -match "CrowdStrike Falcon Sensor Setup"}
[Microsoft.VisualBasic.Interaction]::AppActivate($app.Id)


# Simulator touch 
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
[System.Windows.Forms.SendKeys]::SendWait(" ")

[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
[System.Windows.Forms.SendKeys]::SendWait(" ")
