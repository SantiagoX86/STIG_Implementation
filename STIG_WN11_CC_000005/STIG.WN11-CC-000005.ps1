<#
.SYNOPSIS
    Disables camera access from the Windows lock screen to enforce
    DISA STIG compliance for WN11-CC-000005.

.DESCRIPTION
    This script enforces the DISA STIG requirement:
    "Camera access from the lock screen must be disabled."

    The control is implemented by configuring a machine-level
    Group Policy–backed registry value. This mitigation prevents
    camera usage prior to authentication while preserving all
    post-login camera functionality.

    The script performs:
      - A pre-check to determine current compliance
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
    STIG-ID       : WN11-CC-000005

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

#region Variables

$RegPath     = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization'
$RegName     = 'NoLockScreenCamera'
$DesiredValue = 1
$BackupPath  = "$env:ProgramData\STIG-Backups"
$BackupFile  = Join-Path $BackupPath 'WN11-CC-000005_CameraLockScreen.reg'

#endregion Variables

#region Pre-Checks

Write-Host "[Pre-Check] Evaluating current lock screen camera policy..." -ForegroundColor Cyan

# Check if registry path exists
if (Test-Path $RegPath) {
    $CurrentValue = (Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue).$RegName
} else {
    $CurrentValue = $null
}

if ($CurrentValue -eq $DesiredValue) {
    Write-Host "[Pre-Check] System is already COMPLIANT. No remediation required." -ForegroundColor Green
    return
} else {
    Write-Host "[Pre-Check] System is NON-COMPLIANT. Remediation required." -ForegroundColor Yellow
}

#endregion Pre-Checks

#region Backup (Rollback Support)

Write-Host "[Backup] Creating rollback backup..." -ForegroundColor Cyan

# Ensure backup directory exists
if (-not (Test-Path $BackupPath)) {
    New-Item -Path $BackupPath -ItemType Directory -Force | Out-Null
}

# Export existing registry key if it exists
if (Test-Path $RegPath) {
    reg export "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" `
        $BackupFile /y | Out-Null
    Write-Host "[Backup] Registry state backed up to $BackupFile" -ForegroundColor Green
} else {
    Write-Host "[Backup] Registry key does not exist. No backup required." -ForegroundColor Yellow
}

#endregion Backup

#region Remediation

Write-Host "[Remediation] Enforcing STIG WN11-CC-000005..." -ForegroundColor Cyan

# Create registry path if missing
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
    Write-Host "[Remediation] Created missing registry path." -ForegroundColor Gray
}

# Set required policy value
New-ItemProperty -Path $RegPath `
                 -Name $RegName `
                 -PropertyType DWord `
                 -Value $DesiredValue `
                 -Force | Out-Null

Write-Host "[Remediation] Lock screen camera access DISABLED." -ForegroundColor Green

#endregion Remediation

#region Post-Checks

Write-Host "[Post-Check] Validating remediation..." -ForegroundColor Cyan

$PostValue = (Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue).$RegName

if ($PostValue -eq $DesiredValue) {
    Write-Host "[Post-Check] COMPLIANT. STIG requirement successfully enforced." -ForegroundColor Green
} else {
    Write-Host "[Post-Check] FAILED. Registry value not set as expected." -ForegroundColor Red
    Write-Host "[Post-Check] Manual investigation required." -ForegroundColor Red
}

#endregion Post-Checks

#region Rollback Instructions

<#
ROLLBACK INSTRUCTIONS
---------------------
To rollback this change, run the following command as Administrator:

    reg import "C:\ProgramData\STIG-Backups\WN11-CC-000005_CameraLockScreen.reg"

Then run:
    gpupdate /force

A reboot is NOT required.
#>

#endregion Rollback Instructions
