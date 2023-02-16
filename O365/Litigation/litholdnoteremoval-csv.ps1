# Connect to Exchange Online PowerShell session
Connect-ExchangeOnline -UserPrincipalName <UPN>

# Set the path to the CSV file that contains the list of mailboxes
$csvPath = "C:\path\to\mailboxes.csv"

# Read the CSV file and iterate through the list of mailboxes
$mailboxes = Import-Csv $csvPath
foreach ($mailbox in $mailboxes) {
    try {
        # Get the mailbox object and remove the litigation hold note
        $hold = Get-Mailbox -Identity $mailbox.EmailAddress | Select-Object LitigationHoldDate, LitigationHoldOwner, LitigationHoldStatus
        $hold.LitigationHoldDate = $null
        $hold.LitigationHoldOwner = $null
        $hold.LitigationHoldStatus = $null
        Set-Mailbox -Identity $mailbox.EmailAddress -LitigationHoldDate $hold.LitigationHoldDate -LitigationHoldOwner $hold.LitigationHoldOwner -LitigationHoldStatus $hold.LitigationHoldStatus
    }
    catch {
        Write-Warning "Error removing litigation hold note for mailbox $($mailbox.EmailAddress): $($_.Exception.Message)"
    }
}
