# Import the necessary modules
Import-Module MSOnline
Import-Module AzureAD

# Connect to Azure AD and Office 365
Connect-AzureAD
Connect-MsolService

# Get a list of all Office 365 users
$users = Get-MsolUser -All

# Create an HTML report
$report = "<html><head><title>Office 365 User Licenses Report</title></head><body><h1>Office 365 User Licenses Report</h1><table><tr><th>User Principal Name</th><th>Licenses</th></tr>"

# Loop through each user and add their information to the report
foreach ($user in $users)
{
    $upn = $user.UserPrincipalName
    $licenses = $user.Licenses

    $report += "<tr><td>$upn</td><td>$licenses</td></tr>"
}

# Finish the HTML report
$report += "</table></body></html>"

# Save the HTML report to a file
$report | Out-File "C:\Office365UserLicenses.html"
