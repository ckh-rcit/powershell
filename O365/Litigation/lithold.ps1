# Connect to Exchange Online
Connect-ExchangeOnline

# Prompt for the path to the CSV file containing mailbox display names and email addresses
$filepath = Read-Host "Enter the path to the CSV file containing mailbox display names and email addresses"

# Check if the file exists
if (!(Test-Path $filepath)) {
    Write-Host "The specified file does not exist"
    return
}

# Read the mailbox display names and email addresses from the file
$emailData = Import-Csv $filepath -Header DisplayName, EmailAddress

# Prompt to enable or disable Litigation Hold
$litigationHoldEnabled = $null
$enableChoice = Read-Host "Would you like to enable or disable Litigation Hold? (Enter '1' for enable or '2' for disable)"

if ($enableChoice -eq "1") {
    $litigationHoldEnabled = $true
} elseif ($enableChoice -eq "2") {
    $litigationHoldEnabled = $false
}

# Prompt for Litigation Hold duration if enabling Litigation Hold
$litigationHoldDuration = $null
if ($litigationHoldEnabled) {
    $durationChoice = Read-Host "Would you like to put the mailboxes on indefinite Litigation Hold or for a specific duration? (Enter '1' for indefinite or '2' for specific duration)"

    if ($durationChoice -eq "2") {
        $duration = Read-Host "Enter the duration for Litigation Hold in days (e.g. '365' for 1 year)"
        $litigationHoldDuration = "$duration.00:00:00"
    }
}

# Initialize the array for the report
$report = @()

# Enable or disable Litigation Hold for each mailbox
foreach ($email in $emailData) {
    Write-Host "Processing mailbox: $($email.EmailAddress)"
    Set-Mailbox -Identity $email.EmailAddress -LitigationHoldEnabled $litigationHoldEnabled -LitigationHoldDuration $litigationHoldDuration
    
    # Get the mailbox information after processing
    $mailbox = Get-Mailbox -Identity $email.EmailAddress
    
    # Add the mailbox information to the report array
    $report += [PSCustomObject]@{
        DisplayName = $mailbox.DisplayName
        EmailAddress = $mailbox.PrimarySmtpAddress
        LitigationHoldEnabled = $mailbox.LitigationHoldEnabled
        LitigationHoldDuration = $mailbox.LitigationHoldDuration
    }
}

# Generate the HTML report
if ($report.Count -gt 0) {
    $htmlReport = $report | ConvertTo-Html -Property DisplayName, EmailAddress, LitigationHoldEnabled, LitigationHoldDuration -As Table -Fragment
    $html = "<html><head><style>body{font-family: Arial, sans-serif; font-size: 12px;} table{border-collapse: collapse;} td{border: 1px solid #ccc; padding: 5px;} th{background-color: #ccc; border: 1px solid #ccc; padding: 5px;}</style></head><body>"
    $html += "<h2>Litigation Hold Results</h2>"
    $html += $htmlReport
    $html += "</body></html>"
    $html | Out-File -Encoding UTF8 -FilePath "LitigationHoldResults.html"
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline
