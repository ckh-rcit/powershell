## PowerShell Script to Remove Litigation Hold Notes
This PowerShell script removes litigation hold notes from all Exchange Online mailboxes in an organization. It checks for the presence of a litigation hold note on each mailbox, and if a note is found, the script removes it by setting the LitigationHoldDate, LitigationHoldOwner, and LitigationHoldStatus properties to $null.

## Prerequisites
Before you can run the script, you need to meet the following prerequisites:

- You must have an Exchange Online administrator account with the necessary permissions to manage mailboxes.
- You must have the Exchange Online PowerShell module installed on your computer.

The script will iterate through all Exchange Online mailboxes in the organization and remove any litigation hold notes that it finds.

### Error Handling
The script includes error handling to handle any errors that may occur during the script execution. If an error occurs, the script outputs a warning message that includes the mailbox email address and the error message.

