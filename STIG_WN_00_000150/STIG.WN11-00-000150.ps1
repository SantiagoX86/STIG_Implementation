<#
.SYNOPSIS
    Enforces Group Policy reprocessing even when no changes are detected.
    This remediates STIG WN11-CC-000090 by ensuring security policies
    are continuously reapplied to prevent configuration drift.

.NOTES
    Author        : Sean Santiago
    Date Created  : 2026-01-14
    Last Modified : 2026-01-14
    Github        : https://github.com/SantiagoX86
    Version       : 1.0
    CVEs          : N/A
    Plugin IDs    : N/A
    STIG-ID       : WN11-CC-000090

.TESTED ON
    Date(s) Tested  :
    Tested By       :
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Must be run with Administrator privileges.

    Example syntax:
    PS C:\> .\Remediate-WN11-CC-000090.ps1
#>

# -------------------------------
# Verify script is running as Administrator
# -------------------------------
If (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Error "This script must be run with Administrator privileges."
    Exit 1
}

# -------------------------------
# Define the registry path required by the STIG
# -------------------------------
$RegistryPath = "HKLM:\Software\Policies\Microsoft\Windows\Group Policy"

# -------------------------------
# Ensure the registry path exists
# If it does not exist, it will be created
# -------------------------------
If (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# -------------------------------
# Set the NoGPOListChanges value
# A value of 0 forces Group Policy to reprocess
# all policies even if no changes are detected
# -------------------------------
New-ItemProperty `
    -Path $RegistryPath `
    -Name "NoGPOListChanges" `
    -PropertyType DWORD `
    -Value 0 `
    -Force | Out-Null

# -------------------------------
# Force a Group Policy refresh to apply the change
# -------------------------------
gpupdate /force | Out-Null

# -------------------------------
# Confirm remediation success
# -------------------------------
$CurrentValue = Get-ItemProperty `
    -Path $RegistryPath `
    -Name "NoGPOListChanges" `
    -ErrorAction SilentlyContinue

If ($CurrentValue.NoGPOListChanges -eq 0) {
    Write-Host "STIG WN11-CC-000090 successfully remediated." -ForegroundColor Green
} else {
    Write-Warning "Remediation attempted but verification failed."
}
