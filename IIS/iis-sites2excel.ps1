# Assuming you've already established a session with the remote server named $session

# Fetch Site Names and Associated Bindings from the remote server
$scriptBlock = {
    # Load IIS module
    Import-Module WebAdministration

    # Retrieve sites and bindings
    return Get-Website | ForEach-Object {
        $siteName = $_.Name
        $_.bindings.Collection | ForEach-Object {
            [PSCustomObject]@{
                'SiteName' = $siteName
                'Binding'  = $_.bindingInformation
            }
        }
    }
}

$sites = Invoke-Command -Session $session -ScriptBlock $scriptBlock

# Create an Excel File on the Local Machine with the fetched data

# Create an Excel application object
$excelApp = New-Object -ComObject Excel.Application
$excelApp.Visible = $true

# Add a new workbook and retrieve the active worksheet
$workbook = $excelApp.Workbooks.Add()
$worksheet = $workbook.Worksheets.Item(1)

# Set headers
$worksheet.Cells.Item(1, 1).Value2 = "Site Name"
$worksheet.Cells.Item(1, 2).Value2 = "Binding"

# Populate data
$row = 2
foreach ($site in $sites) {
    $worksheet.Cells.Item($row, 1).Value2 = $site.SiteName
    $worksheet.Cells.Item($row, 2).Value2 = $site.Binding
    $row++
}

# Auto-fit columns
$worksheet.Columns.Item(1).AutoFit()
$worksheet.Columns.Item(2).AutoFit()

# Save the Excel file
$excelFile = "C:\temp\IIS_Sites_Bindings.xlsx"
$workbook.SaveAs($excelFile)

# Close Excel
$excelApp.Quit()

# Cleanup
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($worksheet) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excelApp) | Out-Null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

Write-Output "Excel file saved to: $excelFile"
