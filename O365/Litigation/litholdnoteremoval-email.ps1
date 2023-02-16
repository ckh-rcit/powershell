# Connect to Exchange Online PowerShell session
Connect-ExchangeOnline -UserPrincipalName <UPN>

# Set up email parameters
$to = "<recipient email address>"
$from = "<sender email address>"
$smtpServer = "<SMTP server address>"
$subject = "Litigation hold note removal status"

# Get all mailboxes in the organization and iterate through them
$allMailboxes = Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq 'UserMailbox'}
$errors = @()
$successes = @()
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
            $successes += $mailbox.EmailAddress
            Write-Output "Litigation hold note removed for mailbox $($mailbox.EmailAddress)"
        } catch {
            $errors += "$($mailbox.EmailAddress): $($_.Exception.Message)"
            Write-Warning "Error removing litigation hold note for mailbox $($mailbox.EmailAddress): $($_.Exception.Message)"
        }
    } else {
        Write-Output "No litigation hold note found for mailbox $($mailbox.EmailAddress)"
    }
}

# Send an email with the results
$body = "Litigation hold note removal status:`n"
$body += "Successes: $($successes -join ', ')`n"
$body += "Errors:`n$($errors -join '`n')"

Send-MailMessage -To $to -From $from -SmtpServer $smtpServer -Subject $subject -Body $body
