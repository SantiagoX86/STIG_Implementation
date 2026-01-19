<#
.SYNOPSIS
    Disables Microsoft consumer experiences to enforce DISA STIG compliance
    for WN11-CC-000197.

.DESCRIPTION
    This script enforces the DISA STIG requirement:
    "Microsoft consumer experiences must be turned off."

    The control is implemented by configuring a machine-level
    Group Policy–backed registry value. This prevents Windows from
    installing or promoting consumer-focused content such as
    suggested apps, tips, and advertisements.

    The script performs:
     - A pre-check to determine current compliance (aligned with Tenable logic)
     - A backup of the existing registry state for rollback
     - Remediation if non-compliant
     - A post-check to confirm compliance for Tenable STIG audits

.NOTES
    Author        : Sean Santiago
    Date Created  : 2026-01-16
    Last Modified : 2026-01-16
    Github        : https://github.com/SantiagoX86
    Version       : 1.0
    CVEs          : N/A
    Plugin IDs    : N/A
    STIG-ID       : WN11-CC-000197

.TESTED ON
    Date(s) Tested  :
    Tested By       :
    Systems Tested  :
    PowerShell Ver. :

.USAGE
    - This script MUST be run with Administrator privileges.
    - A system reboot is NOT required.
    - Rollback can be performed by restoring the backup registry value
      created during execution.
#>

# -------------------------------
# Configuration
# -------------------------------

# Define the registry path used by Group Policy for Cloud Content settings
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"

# Define the registry value that controls Microsoft consumer experiences
$RegName = "DisableWindowsConsumerFeatures"

# Define the compliant value required by the STIG
$CompliantValue = 1

# -------------------------------
# Pre-Check (Tenable-aligned)
# -------------------------------

Write-Host "[Pre-Check] Evaluating WN11-CC-000197 compliance..." -ForegroundColor Cyan

# Check if the registry path exists
if (Test-Path $RegPath) {

    # Attempt to read the current registry value
    $CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue |
                    Select-Object -ExpandProperty $RegName -ErrorAction SilentlyContinue

    # If the value exists and is compliant
    if ($CurrentValue -eq $CompliantValue) {
        Write-Host "[Pre-Check] System is already COMPLIANT." -ForegroundColor Green
        $NeedsRemediation = $false
    }
    else {
        Write-Host "[Pre-Check] Non-compliant or not explicitly configured." -ForegroundColor Yellow
        $NeedsRemediation = $true
    }
}
else {
    Write-Host "[Pre-Check] Registry path not found (policy not configured)." -ForegroundColor Yellow
    $NeedsRemediation = $true
}

# -------------------------------
# Backup Existing Configuration
# -------------------------------

if ($NeedsRemediation) {

    Write-Host "[Backup] Backing up existing registry configuration..." -ForegroundColor Cyan

    # Create a backup directory if it does not exist
    $BackupDir = "$env:SystemDrive\STIG_Backups"
    if (-not (Test-Path $BackupDir)) {
        New-Item -Path $BackupDir -ItemType Directory | Out-Null
    }

    # Export the registry key (if it exists) for rollback purposes
    reg export "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" `
        "$BackupDir\WN11-CC-000197_CloudContent_Backup.reg" /y 2>$null
}

# -------------------------------
# Remediation
# -------------------------------

if ($NeedsRemediation) {

    Write-Host "[Remediation] Applying STIG-compliant configuration..." -ForegroundColor Cyan

    # Ensure the registry path exists
    if (-not (Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }

    # Set the registry value required for compliance
    Set-ItemProperty -Path $RegPath `
                     -Name $RegName `
                     -Type DWord `
                     -Value $CompliantValue

    Write-Host "[Remediation] Registry value set successfully." -ForegroundColor Green
}

# -------------------------------
# Post-Check (Tenable-aligned)
# -------------------------------

Write-Host "[Post-Check] Verifying compliance..." -ForegroundColor Cyan

# Re-read the registry value after remediation
$PostValue = Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue |
             Select-Object -ExpandProperty $RegName -ErrorAction SilentlyContinue

# Confirm compliance
if ($PostValue -eq $CompliantValue) {
    Write-Host "[Post-Check] System is COMPLIANT with WN11-CC-000197." -ForegroundColor Green
}
else {
    Write-Host "[Post-Check] System is NOT compliant. Manual investigation required." -ForegroundColor Red
}
