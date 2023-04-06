#Get variable from main
param (
    [string]$vm_name
)

# Change home page - name of the VM
$vm_name=$($env:computername)
Set-Content -Path C:\inetpub\wwwroot\iisstart.htm -Value "<h1 style='background-color:powderblue;text-align:center;color:black;font-size:50px;'>$vm_name</h1>"

