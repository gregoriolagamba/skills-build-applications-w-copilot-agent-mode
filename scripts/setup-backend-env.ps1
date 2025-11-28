<#
PowerShell helper script to create the backend virtual environment and install requirements
Run this from the repository root (or pass a full path) in PowerShell (Windows) using an elevated shell if required.
#>
set-StrictMode -Version Latest

# Determine repository root (current working directory) and resolve backend paths
$RepoRoot = (Get-Location).Path
$BackendDir = Join-Path $RepoRoot "octofit-tracker\backend"
$VenvDir = Join-Path $BackendDir "venv"
$ReqFile = Join-Path $BackendDir "requirements.txt"

Write-Host "Repo root: $RepoRoot" -ForegroundColor Cyan
Write-Host "Backend dir: $BackendDir" -ForegroundColor Cyan
Write-Host "Venv dir: $VenvDir" -ForegroundColor Cyan
Write-Host "Requirements: $ReqFile" -ForegroundColor Cyan

# Helper to run a command and fail early
function Run-Checked($program, $args) {
    $proc = Start-Process -FilePath $program -ArgumentList $args -NoNewWindow -Wait -PassThru -WindowStyle Hidden
    if ($proc.ExitCode -ne 0) { throw "Command failed: $program $args (exit $($proc.ExitCode))" }
}

try {
    # Make sure Python launcher is available
    $pyver = & py -3 --version 2>$null
    if (!$?) {
        throw 'Python (py -3) not found. Please install Python 3 and make sure `py -3` runs from Powershell.'
    }

    # Create virtual environment (skips if already exists)
    if (-Not (Test-Path -Path $VenvDir)) {
        Write-Host "Creating virtual environment..." -ForegroundColor Yellow
        Run-Checked "py" "-3 -m venv `"$VenvDir`""
    } else {
        Write-Host "Virtual environment already exists at $VenvDir" -ForegroundColor Yellow
    }

    # Prepare paths to python inside the venv
    $VenvPython = Join-Path $VenvDir "Scripts\python.exe"
    if (-Not (Test-Path -Path $VenvPython)) { throw "Created virtualenv but python executable not found at $VenvPython" }

    Write-Host "Upgrading pip inside venv..." -ForegroundColor Yellow
    Run-Checked $VenvPython "-m pip install --upgrade pip"

    # Install requirements. Use --prefer-binary to reduce compile time / avoid building from source.
    if (-Not (Test-Path -Path $ReqFile)) { throw "requirements.txt not found at $ReqFile" }

    Write-Host "Installing requirements from $ReqFile (this may take a while)..." -ForegroundColor Yellow
    Run-Checked $VenvPython "-m pip install --prefer-binary --disable-pip-version-check -r `"$ReqFile`""

    Write-Host "Installation completed successfully." -ForegroundColor Green
    Write-Host "To activate the venv in PowerShell use:`n`n    . $VenvDir\Scripts\Activate.ps1`n" -ForegroundColor White
    Write-Host "Or use the venv python directly:`n`n    $VenvPython -m pip freeze`n" -ForegroundColor White
}
catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    Write-Host "If you run into long compile/installation steps consider: `n - running these steps locally with full toolchain (Visual Studio Build Tools) installed, or `n - using --prefer-binary or adding wheels where available, or `n - using WSL/Unix environments for better build support." -ForegroundColor Yellow
    exit 1
}
