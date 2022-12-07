# Import the AzureAD PowerShell module
Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Define the user to activate the PIM role for
$user = "<User_Email>"

# Request activation of the PIM role for the user
$pimRole = Get-AzureADDirectoryRole | Where-Object {$_.displayName -eq "PIM Role"}
$pimRoleMem = New-Object Microsoft.Open.AzureAD.Model.DirectoryRoleMembership
$pimRoleMem.objectId = $user
$pimRoleMem.directoryRoleId = $pimRole.objectId
Add-AzureADDirectoryRoleMember -ObjectId $pimRole.objectId -RefObjectId $pimRoleMem.objectId
