# Connect to Exchange Online PowerShell session
Connect-ExchangeOnline -UserPrincipalName <UPN>

try {
    # Get the first 1000 mailboxes in the organization and iterate through them
    $allMailboxes = Get-Mailbox -ResultSize 1000 -Filter {RecipientTypeDetails -eq 'UserMailbox'}
    foreach ($mailbox in $allMailboxes) {
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
}
catch {
    Write-Warning "Error getting mailboxes: $($_.Exception.Message)"
}
