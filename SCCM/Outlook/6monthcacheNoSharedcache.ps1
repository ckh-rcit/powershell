$Outlook = New-Object -ComObject Outlook.Application
$Namespace = $Outlook.GetNamespace("MAPI")

# Enable cached mode for the user's primary mailbox
$Namespace.CachedExchangeMode = 1
$Namespace.GetDefaultFolder(6).SetCustomProperties("http://schemas.microsoft.com/mapi/proptag/0x66140003", "6")

# Disable cached mode for shared mailboxes
$SharedMailboxes = $Namespace.Stores | Where-Object {$_.ExchangeStoreType -eq 0}
ForEach ($Mailbox in $SharedMailboxes)
{
    $Mailbox.PropertyAccessor.SetProperty("http://schemas.microsoft.com/mapi/proptag/0x66140003", "0")
}

