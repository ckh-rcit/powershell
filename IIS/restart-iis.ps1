# Define the remote server and app pool name
$server = "server1"
$appPool = "DefaultAppPool"

# Import the WebAdministration module
Import-Module WebAdministration

# Connect to the remote server
$cred = Get-Credential
$session = New-PSSession -ComputerName $server -Credential $cred

# Restart the app pool on the remote server
Invoke-Command -Session $session -ScriptBlock {
    Restart-WebAppPool -Name $using:appPool
}
