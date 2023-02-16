$Outlook = New-Object -ComObject Outlook.Application
$Namespace = $Outlook.GetNamespace("MAPI")

# Disable cached mode for all mailboxes
$Namespace.CachedExchangeMode = 0
