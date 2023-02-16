$Outlook = New-Object -ComObject Outlook.Application
$Namespace = $Outlook.GetNamespace("MAPI")

$Namespace.CachedExchangeMode = 1
$Namespace.GetDefaultFolder(6).SetCustomProperties("http://schemas.microsoft.com/mapi/proptag/0x66140003", "6")
