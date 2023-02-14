# Import the Exchange Management Shell module
if ( (Get-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction SilentlyContinue) -eq $null )
{
    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
}

# Get a list of all certificates installed on the Exchange Server
$certs = Get-ExchangeCertificate

# Create an array to store the certificate information
$certInfo = @()

# Loop through each certificate and check its expiration date
foreach ($cert in $certs)
{
    $expiration = $cert.NotAfter
    $daysUntilExpiration = ($expiration - (Get-Date)).Days
    $issuedTo = $cert.Subject
    $friendlyName = $cert.FriendlyName

    # If the certificate will expire in the next 30 days, add a warning to the certificate information
    if ($daysUntilExpiration -le 30)
    {
        $certInfo += New-Object PSObject -Property @{
            'Thumbprint' = $cert.Thumbprint
            'IssuedTo' = $issuedTo
            'Expiration' = $expiration
            'DaysUntilExpiration' = $daysUntilExpiration
            'FriendlyName' = $friendlyName
            'Warning' = 'Expires soon'
        }
    }
    else
    {
        $certInfo += New-Object PSObject -Property @{
            'Thumbprint' = $cert.Thumbprint
            'IssuedTo' = $issuedTo
            'Expiration' = $expiration
            'DaysUntilExpiration' = $daysUntilExpiration
            'FriendlyName' = $friendlyName
            'Warning' = ''
        }
    }
}

# Create an HTML table from the certificate information
$table = $certInfo | ConvertTo-Html -As Table -Fragment

# Create the email message
$from = "<from_address>"
$to = "<to_address>"
$subject = "Exchange Server Certificate Expiration"
$body = "The following certificates on the Exchange Server will expire soon:<br><br>$table"
$headers = @{'content-type'='text/html'}

# Send the email
Send-MailMessage -From $from -To $to -Subject $subject -Body $body -SmtpServer "<smtp_server>" -BodyAsHtml -Priority High -DeliveryNotificationOption Never -Encoding ([System.Text.Encoding]::UTF8) -UseSsl -Port 587 -Credential (Get-Credential) -Attachments $attachments -Attachments (Get-ChildItem "C:\Logs\CertificateChecks\*.log") -ErrorAction Stop -ErrorVariable errors -ErrorAction Stop

# Output the certificate information to the console for reference
$certInfo
