# Define the remote server name or IP address
$server = "127.0.0.1"

# Import the required PowerShell module
Import-Module WebAdministration

# Connect to the remote server
$cred = Get-Credential
$session = New-PSSession -ComputerName $server -Credential $cred

# Restart the app pools on the remote server
Invoke-Command -Session $session -ScriptBlock {
    Restart-WebAppPool -Name "DefaultAppPool"
}

# Close the remote session
Remove-PSSession -Session $session
