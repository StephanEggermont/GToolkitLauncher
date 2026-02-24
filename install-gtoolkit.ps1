# GToolkit Installer for Windows
# Downloads and installs the latest GToolkit release.

param(
    [string]$InstallDir = ""
)

$ErrorActionPreference = "Stop"

$GitHubApi = "https://api.github.com/repos/feenkcom/gtoolkit/releases/latest"
$GitHubDL  = "https://github.com/feenkcom/gtoolkit/releases/download"
$FeenkDL   = "https://dl.feenk.com/gt"

# --- Output helpers ---

function Write-Info([string]$Msg) {
    Write-Host $Msg -ForegroundColor Cyan
}

function Write-Ok([string]$Msg) {
    Write-Host $Msg -ForegroundColor Green
}

function Write-Warn([string]$Msg) {
    Write-Host "WARNING: $Msg" -ForegroundColor Yellow
}

function Write-Err([string]$Msg) {
    Write-Host "ERROR: $Msg" -ForegroundColor Red
}

# --- Architecture detection ---

function Get-PlatformArch {
    $arch = $env:PROCESSOR_ARCHITECTURE
    switch ($arch) {
        "AMD64" { return "x86_64"  }
        "x86"   { return "x86_64"  }
        "ARM64" { return "aarch64" }
        default {
            Write-Err "Unsupported architecture: $arch"
            exit 1
        }
    }
}

# --- Version detection ---

function Get-LatestVersion {
    Write-Info "Querying GitHub for the latest GToolkit release..."

    $headers = @{}
    if ($env:GITHUB_TOKEN) {
        $headers["Authorization"] = "token $env:GITHUB_TOKEN"
    }

    $tag = $null
    try {
        $response = Invoke-RestMethod -Uri $GitHubApi -Headers $headers -UseBasicParsing
        $tag = $response.tag_name
    } catch {
        Write-Err "Failed to query GitHub API: $_"
        exit 1
    }

    if (-not $tag) {
        Write-Err "Could not determine latest version from GitHub API."
        exit 1
    }

    Write-Info "Latest version: $tag"
    return $tag
}

# --- Download helper ---

function Get-File([string]$Url, [string]$Destination) {
    $ProgressPreference = "SilentlyContinue"
    Invoke-WebRequest -Uri $Url -OutFile $Destination -UseBasicParsing
}

# --- Checksum verification ---

function Test-Checksum([string]$FilePath, [string]$ExpectedHash) {
    $actualHash = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash.ToLower()
    $expected   = $ExpectedHash.ToLower()

    if ($actualHash -eq $expected) {
        Write-Ok "Checksum verified."
        return $true
    } else {
        Write-Err "Checksum mismatch!"
        Write-Err "  Expected: $expected"
        Write-Err "  Actual:   $actualHash"
        return $false
    }
}

# --- Post-install: load GToolkitLauncher ---

function Install-LauncherPackage([string]$Dir, [string]$TmpDir) {

    $cliBin = Join-Path $Dir "bin\GlamorousToolkit-cli.exe"
    if (-not (Test-Path $cliBin)) {
        Write-Warn "GlamorousToolkit-cli binary not found - skipping launcher package install."
        return
    }
    $gtCli = $cliBin

    $imageFile = Get-ChildItem -Path $Dir -Filter "*.image" | Select-Object -First 1
    if (-not $imageFile) {
        Write-Warn "GToolkit image file not found - skipping launcher package install."
        return
    }

    $stFile = Join-Path $TmpDir "load-launcher.st"

    $lines = @(
        "EpMonitor current disable.",
        "[",
        "Metacello new",
        "  repository: 'github://StephanEggermont/GToolkitLauncher:main/src';",
        "  baseline: 'GToolkitLauncher';",
        "  load.",
        "] ensure: [ EpMonitor current enable ].",
        "15 seconds wait.",
        "EpMonitor current disable.",
        "[",
        "#BaselineOfGToolkitLauncher asClass loadLepiter.",
        "] ensure: [ EpMonitor current enable ].",
        "15 seconds wait.",
        "BlHost pickHost universe snapshot: true andQuit: true."
    )
    $stContent = $lines -join "`r`n"
    Set-Content -Path $stFile -Value $stContent -Encoding UTF8

    Write-Info "Loading GToolkitLauncher package (this may take several minutes)..."

    try {
        $procParams = @{
            FilePath         = $gtCli
            ArgumentList     = @($imageFile.Name, "st", $stFile, "--interactive", "--no-quit")
            WorkingDirectory = $Dir
            Wait             = $true
            PassThru         = $true
            NoNewWindow      = $true
        }
        $proc = Start-Process @procParams
        if ($proc.ExitCode -eq 0) {
            Write-Ok "GToolkitLauncher loaded successfully."
        } else {
            Write-Warn "GToolkitLauncher install exited with code $($proc.ExitCode) - GToolkit is still usable without it."
        }
    } catch {
        Write-Warn "GToolkitLauncher install failed: $_ - GToolkit is still usable without it."
    }
}

# --- Main install ---

function Install-GToolkit([string]$Dir, [string]$Tag, [string]$Arch) {

    $assetName        = "GlamorousToolkit-Windows-${Arch}-${Tag}.zip"
    $checksumName     = "${assetName}.sha256"
    $githubUrl        = "${GitHubDL}/${Tag}/${assetName}"
    $feenkUrl         = "${FeenkDL}/${assetName}"
    $githubChecksumUrl = "${GitHubDL}/${Tag}/${checksumName}"

    $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null

    try {
        $zipFile = Join-Path $tmpDir $assetName

        # Download zip - try GitHub first, fall back to dl.feenk.com
        Write-Info "Downloading ${assetName}..."
        $downloaded = $false

        try {
            Get-File -Url $githubUrl -Destination $zipFile
            Write-Ok "Downloaded from GitHub."
            $downloaded = $true
        } catch {
            Write-Warn "GitHub download failed - trying dl.feenk.com..."
        }

        if (-not $downloaded) {
            try {
                Get-File -Url $feenkUrl -Destination $zipFile
                Write-Ok "Downloaded from dl.feenk.com."
            } catch {
                Write-Err "Download failed from all sources."
                exit 1
            }
        }

        # Checksum verification
        $checksumFile = Join-Path $tmpDir $checksumName
        try {
            Get-File -Url $githubChecksumUrl -Destination $checksumFile
            $expectedHash = (Get-Content $checksumFile -Raw).Trim().Split(" ")[0]
            $valid = Test-Checksum -FilePath $zipFile -ExpectedHash $expectedHash
            if (-not $valid) { exit 1 }
        } catch {
            Write-Warn "Checksum file not available - skipping verification."
        }

        # Prepare install directory
        if (Test-Path $Dir) {
            Write-Warn "Install directory already exists: $Dir"
            Write-Warn "Existing files may be overwritten."
        }
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null

        # Extract
        Write-Info "Extracting to ${Dir}..."
        Expand-Archive -Path $zipFile -DestinationPath $Dir -Force
        Write-Ok "Extraction complete."
        Write-Host ""

        # Post-install: load GToolkitLauncher into the image
        Install-LauncherPackage -Dir $Dir -TmpDir $tmpDir

    } finally {
        Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
    }

    Write-Host ""
    Write-Ok "GToolkit ${Tag} installed to: ${Dir}"
    Write-Host ""

    $exeBin  = Join-Path $Dir "bin\GlamorousToolkit.exe"
    $exeRoot = Join-Path $Dir "GlamorousToolkit.exe"
    if (Test-Path $exeBin) {
        Write-Info "To launch: $exeBin"
    } elseif (Test-Path $exeRoot) {
        Write-Info "To launch: $exeRoot"
    } else {
        Write-Info "To launch, run GlamorousToolkit.exe in ${Dir}"
    }
}

# --- Entry point ---

function Main {
    $defaultDir = Join-Path $env:USERPROFILE "gtoolkit"

    $dir = ""
    if ($InstallDir -ne "") {
        $dir = $InstallDir
    } elseif ($env:GTOOLKIT_DIR) {
        $dir = $env:GTOOLKIT_DIR
    } elseif ([Environment]::UserInteractive -and -not [Console]::IsInputRedirected) {
        $userDir = Read-Host "Install directory [$defaultDir]"
        if ($userDir -ne "") {
            $dir = $userDir
        } else {
            $dir = $defaultDir
        }
    } else {
        $dir = $defaultDir
    }

    Write-Host ""
    Write-Info "GToolkit Installer"
    Write-Info "=================="
    Write-Host ""

    $arch = Get-PlatformArch
    Write-Info "Platform: Windows $arch"
    Write-Host ""

    $tag = Get-LatestVersion
    Write-Host ""

    Install-GToolkit -Dir $dir -Tag $tag -Arch $arch
}

Main
