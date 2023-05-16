
# Install IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools
# Change home page - name of the VM
$vm_name=$($env:computername)
Set-Content -Path C:\inetpub\wwwroot\iisstart.htm -Value "<h1 style='background-color:powderblue;text-align:center;color:black;font-size:50px;'>$vm_name</h1>"


Start-Sleep -Seconds 2


# Download antivirus
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://github.com/EurysPikulas/Antivirus-su/raw/main/QualysCloudAgent.exe -OutFile c:\terraform\QualysCloudAgent.exe
Invoke-WebRequest -Uri https://github.com/EurysPikulas/Antivirus-su/raw/main/WindowsSensor.exe -OutFile c:\terraform\WindowsSensor.exe


Start-Sleep -Seconds 2


#Install QualysCloudAgent
Start-Process -FilePath  C:\terraform\QualysCloudAgent.exe -ArgumentList "CustomerId={5854546df-ty874256-87Dz7888} ActivationId={5854546df-ty874256-87Dz7888} WebServiceUri=//qagpublic.qg2.apps.qualys.eu/CloudAgent/"   
Start-Sleep -Seconds 1
#Install WindowsSensor
# Update these variables as needed
$CID = '4878446343154975462-dD55899'
$SensorShare = 'C:\terraform\WindowsSensor.exe'

# The sensor is copied to the following directory
$SensorLocal = 'C:\Temp\WindowsSensor.exe'

# Create a TEMP directory if one does not already exist
if (!(Test-Path -Path 'C:\Temp' -ErrorAction SilentlyContinue)) {

    New-Item -ItemType Directory -Path 'C:\Temp' -Force

}
# Now copy the sensor installer if the share is available
if (Test-Path -Path $SensorShare) {

    Copy-Item -Path $SensorShare -Destination $SensorLocal -Force

}
# Now check to see if the service is already present and if so, don't bother running installer.
if (!(Get-Service -Name 'CSFalconService' -ErrorAction SilentlyContinue)) {

    & $SensorLocal /install /quiet /norestart CID=$CID

}



