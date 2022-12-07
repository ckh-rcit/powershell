# pim-approval

This script first imports the ***AzureADPrivilegedIdentityManagement*** module, which contains the cmdlets you need to work with PIM roles. It then connects to Azure AD and specifies the name of the PIM role you want to approve, as well as the user principal name of the user you want to approve the role for. It retrieves the PIM role object and checks if it is available for approval, and if so, it gets the PIM role request object for the specified user. If the user has requested the role, it approves the role for the user using the ***Approve-AzureADMSPrivilegedRoleRequest*** cmdlet.

Note that this script assumes that you have already installed and configured the Azure AD PowerShell module on your computer, and that you have the necessary permissions to approve PIM roles in your Azure AD tenant. You may need to modify the script if you want to approve the role with a different approval type or for a different user.

# pim-request

In the script, replace ***<User_Email>*** with the email address of the user you want to activate the PIM role for.

Note that this script assumes that you have already installed and configured the AzureAD PowerShell module on your machine. You can learn more about how to install and configure the AzureAD PowerShell module by visiting the following Microsoft documentation page:

https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-4.5.0

You can also find more information about the PIM role and how to activate it for users in the Azure AD Privileged Identity Management documentation:

https://docs.microsoft.com/en-us/azure/active-directory/privileged-identity-management/pim-configure
