# Import the PIM module
Import-Module AzureADPrivilegedIdentityManagement

# Connect to Azure AD
Connect-AzureAD

# Replace <role-name> with the name of the PIM role you want to approve
$roleName = "<role-name>"

# Replace <user-principal-name> with the user principal name of the user you want to approve the role for
$userPrincipalName = "<user-principal-name>"

# Get the PIM role object
$role = Get-AzureADMSPrivilegedRoleDefinition -Filter "displayName eq '$roleName'"

# Check if the role is available for approval
if ($role.Status -eq "Available") {
  # Get the PIM role request object for the specified user
  $roleRequest = Get-AzureADMSPrivilegedRoleMember -ObjectId $role.Id | Where-Object { $_.UserPrincipalName -eq $userPrincipalName }

  # Check if the user has requested the role
  if ($roleRequest.Status -eq "Requested") {
    # Approve the role for the user
    Approve-AzureADMSPrivilegedRoleRequest -ObjectId $roleRequest.ObjectId -ApprovalType ApproveForUser
  }
}
