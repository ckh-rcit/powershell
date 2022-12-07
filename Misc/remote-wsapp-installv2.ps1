# Replace <app-name> with the name of the app you want to install
$appName = "<app-name>"

# Replace <app-download-url> with the URL of the appxbundle or msixbundle file
$appDownloadUrl = "<app-download-url>"

# Replace <computer-name> with the name or IP address of the remote computer
$computerName = "<computer-name>"

# Replace <user-name> and <password> with the credentials of a user on the remote computer
$username = "<user-name>"
$password = "<password>"

# Connect to the remote computer
$creds = New-Object System.Management.Automation.PSCredential($username, (ConvertTo-SecureString $password -AsPlainText -Force))
$session = New-PSSession -ComputerName $computerName -Credential $creds

# Download the appxbundle or msixbundle file
Invoke-Command -Session $session -ScriptBlock {
  Invoke-WebRequest -Uri $appDownloadUrl -OutFile "$env:TEMP\$appName.appxbundle"
}

# Install the app on the remote computer
Invoke-Command -Session $session -ScriptBlock {
  Add-AppxPackage -Path "$env:TEMP\$appName.appxbundle"
}

# Close the remote connection
Remove-PSSession $session
