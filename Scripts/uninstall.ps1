$AppLocalPath = [System.Environment]::GetFolderPath("ApplicationData")
$SqlrPath = Join-Path -Path $AppLocalPath -ChildPath "SQLR"

$Confirm = Read-Host "do you want to uninstall sqlr cli (y/n)"

if ($null -ne $Confirm) {
    $Confirm = $Confirm.ToLower()
    
    if ("y" -eq $Confirm) {
        if (Test-Path $SqlrPath -PathType Container) {
            Remove-Item $SqlrPath -Recurse -Force
        }

        Write-Host "uninstall successfully"
    }
}
