# SQLR_INSTALLER

windows install (run script on powershell)
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://github.com/nilphumiphat212/SQLR_INSTALLER/raw/main/Scripts/install.ps1'))
```

windows uninstall (run script on powershell)
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://github.com/nilphumiphat212/SQLR_INSTALLER/raw/main/Scripts/uninstall.ps1'))
```

linux/macos install (run script with terminal)
```bash
/bin/bash -c "$(curl -fsSL https://github.com/nilphumiphat212/SQLR_INSTALLER/raw/main/Scripts/install)"
```

linux/macos (run script with terminal)
```bash
/bin/bash -c "$(curl -fsSL https://github.com/nilphumiphat212/SQLR_INSTALLER/raw/main/Scripts/uninstall)"
```
# SQLR SERVER

**Docker**

build image
```bash
```

