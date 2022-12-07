# Get a list of all Azure users
$users = Get-AzureADUser

# Initialize an empty array to store user information
$userData = @()

# Loop through each user
foreach ($user in $users) {
  # Get a list of licenses assigned to the user
  $licenses = Get-AzureADUserLicenseDetail -ObjectId $user.ObjectId

  # Create an object to store the user's information
  $userInfo = [PSCustomObject] @{
    'User Principal Name' = $user.UserPrincipalName
    'Display Name' = $user.DisplayName
    'Licenses' = $licenses.AccountSkuId
  }

  # Add the user's information to the array
  $userData += $userInfo
}

# Create the HTML report
$report = ConvertTo-Html -Title "Azure Users and Licenses" -Head $style -Body "<h1>Azure Users and Licenses</h1><p>This report shows the list of Azure users and the licenses they are assigned to.</p>"
$report += "<table>"
$report += $userData | ConvertTo-Html -Fragment
$report += "</table>"

# Save the HTML report to a file
$report | Out-File "C:\AzureUsersAndLicenses.html"
