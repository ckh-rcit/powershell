# license-report.ps1

This script will create an HTML file called Office365UserLicenses.html in the root of your C: drive. The file will contain a table with two columns: one for the user's principal name, and one for their licenses.

Note that in order to use this script, you will need to have the MSOnline and AzureAD PowerShell modules installed on your computer. You will also need to have the appropriate permissions to connect to Azure AD and Office 365, and to retrieve the list of users and their licenses.

# azure-user-license-report.ps1

This script first gets a list of all Azure users using the Get-AzureADUser cmdlet. It then loops through each user and uses the Get-AzureADUserLicenseDetail cmdlet to get a list of licenses assigned to the user. The user's information (including their user principal name, display name, and licenses) is stored in an object and added to an array.

Finally, the script creates an HTML report using the ConvertTo-Html cmdlet, which is saved to a file using the Out-File cmdlet. You can adjust the script as needed to customize the report to your specific requirements.
