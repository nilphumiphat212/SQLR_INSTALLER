# SQLR_INSTALLER

windows install (run script on powershell)
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://github.com/nilphumiphat212/SQLR_INSTALLER/raw/main/scripts/install.ps1'))
```

windows uninstall (run script on powershell)
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://github.com/nilphumiphat212/SQLR_INSTALLER/raw/main/scripts/uninstall.ps1'))
```

Macos install (run script with bash)
```bash
/bin/bash -c "$(curl -fsSL https://github.com/nilphumiphat212/SQLR_INSTALLER/raw/main/scripts/install)"
```
