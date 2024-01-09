$DotnetVersionName = "net8.0"

$GitArtifactBaseUrl = "https://api.github.com/repos"
$GitApiVersion = "2022-11-28"
$GitReadOnlyToken = Read-Host "enter github token "
$GitOwnerName = "nilphumiphat212"
$GitRepoName = "SQLR_CLI"

$RequestHeaders = @{
    'Content-Type'         = 'application/vnd.github+json'
    'X-GitHub-Api-Version' = $GitApiVersion
    'Authorization'        = 'Bearer ' + $GitReadOnlyToken
}

$LocalAppData = [System.Environment]::GetFolderPath("ApplicationData")

function Die()
{
    param (
        [String]$message
    )

    Write-Host $message -ForegroundColor Red
    $ = Read-Host "press any key to exit "
    exit -1
}
function Get-Arch-String {
    $Arch = $env:PROCESSOR_ARCHITECTURE
    if ($Arch -eq "AMD64") {
        return "x64"
    }
    else {
        return "x86"
    }
}

function Get-Is-Windows {
    return $env:OS -like "Windows_NT" -or $IsWindows
}

function Get-Github-Api {
    param (
        [String]$Url,
        [String]$Method
    )

    $Response = Invoke-RestMethod -Uri $Url -Method $Method -Headers $RequestHeaders

    return $Response 
}

function Get-File() {
    param (
        [String]$Url,
        [String]$DestPath
    )

    try {
        Invoke-WebRequest -Uri $Url -OutFile $DestPath -Headers $RequestHeaders
    }
    catch {
        Die "fail : can not download sqlr execuable file"
    }
}

function Get-Artifact-List {
    Write-Host "geting..."

    $Url = $GitArtifactBaseUrl + "/" + $GitOwnerName + "/" + $GitRepoName + "/actions/artifacts"

    try {
        $Response = Get-Github-Api -Url $Url -Method Get
        return $Response.artifacts
    }
    catch {
        Die "fail : can not fetch sqlr version list"
    }
}

$IsWindowsOs = Get-Is-Windows

if ($IsWindowsOs -ne $true) {
    Die "fail : this script support windows os only"
}

$Artifacts = Get-Artifact-List

if ($null -ne $Artifacts) {
    $Arch = Get-Arch-String
    $ArtifactFileName = "win-" + $Arch + ".zip"
    $Artifact = $Artifacts | Where-Object { $_.name -eq $ArtifactFileName }

    if ($null -ne $Artifact) {
        Write-Host "downloading sqlr cli..."

        $TempPath = Join-Path -Path $LocalAppData -ChildPath "SQLR_TEMP"

        if (Test-Path $TempPath -PathType Container) {
            Remove-Item $TempPath -Recurse -Force
        }

        $null = New-Item -Path $TempPath -ItemType Directory

        $DlFilePath = Join-Path -Path $TempPath -ChildPath $ArtifactFileName

        Get-File -Url $Artifact.archive_download_url -DestPath $DlFilePath
        Write-Host "download success..."

        $ExtractPath = Join-Path -Path $TempPath -ChildPath "Extract"
        
        Write-Host "extracting..."
        Expand-Archive -Path $DlFilePath -DestinationPath $ExtractPath

        $ExtractDeepPath = Join-Path -Path $ExtractPath -ChildPath $ArtifactFileName

        Write-Host "deep extracting..."
        Expand-Archive -Path $ExtractDeepPath -DestinationPath $TempPath

        $BinarySubPath = "/bin/Release/" + $DotnetVersionName + "/win-x64/publish"
        $BinaryPath = Join-Path -Path $TempPath -ChildPath $BinarySubPath
        $InstallDestinationPath = Join-Path -Path $LocalAppData -ChildPath "SQLR"

        if (Test-Path $InstallDestinationPath -PathType Container) {
            Remove-Item $InstallDestinationPath -Recurse -Force
        }

        Move-Item -Path $BinaryPath -Destination $InstallDestinationPath

        Write-Host "cleaning temp..."
        Remove-Item $TempPath -Recurse -Force

        Write-Host "set environment variable..."
        if ($env:PATH -like $InstallDestinationPath) {
            [System.Environment]::SetEnvironmentVariable("PATH", $InstallDestinationPath, [System.EnvironmentVariableTarget]::User)
        }

        Write-Host "install successfully" -ForeGroundColor Green
    }
    else {
        Die "fail : unexpected error"
    }
}
