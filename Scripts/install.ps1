$DotnetVersionName = "net8.0"

$GitArtifactBaseUrl = "https://api.github.com/repos"
$GitApiVersion = "2022-11-28"
$GitReadOnlyToken = "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"
$GitOwnerName = "nilphumiphat212"
$GitRepoName = "SQLR_CLI"

$RequestHeaders = @{
    'Content-Type' = 'application/vnd.github+json'
    'X-GitHub-Api-Version' = $GitApiVersion
    'Authorization' = 'Bearer ' + $GitReadOnlyToken
}

$LocalAppData = [System.Environment]::GetFolderPath("ApplicationData")

function Get-Arch-String {
    $Arch = $env:PROCESSOR_ARCHITECTURE
    if ($Arch -eq "AMD64") {
        return "x64"
    }
    else {
        return "x86"
    }
}

function Is-Windows {
    return $env:OS -like "Windows_NT" -or $IsWindows
}

function Call-Github-Api {
    param (
        [String]$Url,
        [String]$Method
    )

    $Response = Invoke-RestMethod -Uri $Url -Method $Method -Headers $RequestHeaders

    return $Response 
}

function Download-File() {
    param (
        [String]$Url,
        [String]$DestPath
    )

    try
    {
        Invoke-WebRequest -Uri $Url -OutFile $DestPath -Headers $RequestHeaders
    }
    catch {
        Write-Host "fail : can not download sqlr execuable file" -ForeGroundColor Red
        exit -1
    }
}

function Get-Artifact-List {
    Write-Host "geting..."

    $Url = $GitArtifactBaseUrl + "/" + $GitOwnerName + "/" + $GitRepoName + "/actions/artifacts"

    try {
        $Response = Call-Github-Api -Url $Url -Method Get
        return $Response.artifacts
    }
    catch {
        Write-Host "fail : can not fetch sqlr version list" -ForeGroundColor Red
        exit -1
    }
}

$IsWindowsOs = Is-Windows

if ($IsWindowsOs -ne $true) {
    Write-Host "fail : this script support windows os only" -ForeGroundColor Red
    exit 0
}

$Artifacts = Get-Artifact-List

if ($null -ne $Artifacts)
{
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

        Download-File -Url $Artifact.archive_download_url -DestPath $DlFilePath
        Write-Host "download success..."

        $ExtractPath = Join-Path -Path $TempPath -ChildPath "Extract"
        
        Write-Host "extracting..."
        Expand-Archive -Path $DlFilePath -DestinationPath $ExtractPath

        $ExtractDeepPath = Join-Path -Path $ExtractPath -ChildPath $ArtifactFileName

        Write-Host "deep extracting..."
        Expand-Archive -Path $ExtractDeepPath -DestinationPath $TempPath

        $BinaryPath = Join-Path -Path $TempPath -ChildPath "/bin/Release/" + $DotnetVersionName + "/win-x64/publish"
        $InstallDestinationPath = Join-Path -Path $LocalAppData -ChildPath "SQLR"

        if (Test-Path $InstallDestinationPath -PathType Container) {
            Remove-Item $InstallDestinationPath -Recurse -Force
        }

        Move-Item -Path $BinaryPath -Destination $InstallDestinationPath

        Write-Host "cleaning temp..."
        Remove-Item $TempPath -Recurse -Force

        Write-Host "set environment variable..."
        [System.Environment]::SetEnvironmentVariable("PATH", $InstallDestinationPath, [System.EnvironmentVariableTarget]::User)

        Write-Host "install successfully" -ForeGroundColor Green
    }
    else {
        Write-Host "fail : unexpected error" -ForeGroundColor Red
        exit -1
    }
}
