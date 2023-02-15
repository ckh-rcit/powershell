# Connect to Exchange Online PowerShell session
Connect-ExchangeOnline -UserPrincipalName <UPN>

# Get all mailboxes in the organization and iterate through them
$allMailboxes = Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq 'UserMailbox'}
foreach ($mailbox in $allMailboxes) {
    # Check if a litigation hold note exists on the mailbox
    $hold = Get-Mailbox -Identity $mailbox.EmailAddress | Select-Object LitigationHoldDate, LitigationHoldOwner, LitigationHoldStatus
    if ($hold.LitigationHoldDate -ne $null -or $hold.LitigationHoldOwner -ne $null -or $hold.LitigationHoldStatus -ne $null) {
        # If a litigation hold note exists, remove it
        try {
            $hold.LitigationHoldDate = $null
            $hold.LitigationHoldOwner = $null
            $hold.LitigationHoldStatus = $null
            Set-Mailbox -Identity $mailbox.EmailAddress -LitigationHoldDate $hold.LitigationHoldDate -LitigationHoldOwner $hold.LitigationHoldOwner -LitigationHoldStatus $hold.LitigationHoldStatus -ErrorAction Stop
            Write-Output "Litigation hold note removed for mailbox $($mailbox.EmailAddress)"
        } catch {
            Write-Warning "Error removing litigation hold note for mailbox $($mailbox.EmailAddress): $($_.Exception.Message)"
        }
    } else {
        Write-Output "No litigation hold note found for mailbox $($mailbox.EmailAddress)"
    }
}
