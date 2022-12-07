# Replace <app-name> with the name of the app you want to install
$appName = "<app-name>"

# Replace <computer-name> with the name or IP address of the remote computer
$computerName = "<computer-name>"

# Replace <user-name> and <password> with the credentials of a user on the remote computer
$username = "<user-name>"
$password = "<password>"

# Connect to the remote computer
$creds = New-Object System.Management.Automation.PSCredential($username, (ConvertTo-SecureString $password -AsPlainText -Force))
$session = New-PSSession -ComputerName $computerName -Credential $creds

# Install the app on the remote computer
Invoke-Command -Session $session -ScriptBlock {
  Add-AppxPackage -Name $appName
}

# Close the remote connection
Remove-PSSession $session
