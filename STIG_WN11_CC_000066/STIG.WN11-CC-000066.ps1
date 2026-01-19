<#
.SYNOPSIS
    Enables command line data in process creation events to enforce
    DISA STIG compliance for WN11-CC-000066.

.DESCRIPTION
    This script enforces the DISA STIG requirement:
    "Command line data must be included in process creation events."

    The control is implemented by configuring a machine-level,
    Group Policy–backed registry value that instructs Windows
    to include full command-line arguments in Event ID 4688.

    The script performs:
      - A pre-check aligned to Tenable audit logic
      - A backup of the existing registry state
      - Remediation if non-compliant
      - A post-check to validate enforcement

.NOTES
    Author        : Sean Santiago
    Date Created  : 2026-01-19
    Last Modified : 2026-01-19
    Github        : https://github.com/SantiagoX86
    Version       : 1.0
    CVEs          : N/A
    Plugin IDs    : N/A
    STIG-ID       : WN11-CC-000066

.TESTED ON
    Date(s) Tested  :
    Tested By       :
    Systems Tested  :
    PowerShell Ver. :

.USAGE
    - This script MUST be run with Administrator privileges.
    - A system reboot is NOT required.
    - Rollback can be performed using the registry backup created
      during execution.
#>

# ------------------------------------------------------------
# Configuration Section
# ------------------------------------------------------------

# Define the registry path used by Group Policy for audit settings
$RegPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit'

# Define the registry value that controls command-line logging
$RegName = 'ProcessCreationIncludeCmdLine_Enabled'

# Define the STIG-required value (1 = Enabled)
$DesiredValue = 1

# Define a backup file path to allow rollback if needed
$BackupFile = "$env:SystemDrive\STIG_Backup_WN11-CC-000066.reg"

# ------------------------------------------------------------
# Pre-Check (Tenable-aligned logic)
# ------------------------------------------------------------

# Inform the operator that the compliance check is starting
Write-Host "[Pre-Check] Evaluating current compliance state..." -ForegroundColor Cyan

# Initialize variable to hold the current registry value
$CurrentValue = $null

# Check whether the audit registry path exists
if (Test-Path $RegPath) {

    try {
        # Attempt to read the registry value if it exists
        $CurrentValue = (Get-ItemProperty `
            -Path $RegPath `
            -Name $RegName `
            -ErrorAction Stop).$RegName

        # Output the detected value for visibility
        Write-Host "[Pre-Check] Current registry value detected: $CurrentValue"
    }
    catch {
        # Handle the case where the value is not configured
        Write-Host "[Pre-Check] Registry value not set (Not Configured)." -ForegroundColor Yellow
    }
}
else {
    # Handle the case where the entire registry path does not exist
    Write-Host "[Pre-Check] Audit registry path does not exist." -ForegroundColor Yellow
}

# Determine compliance based on Tenable STIG expectations
if ($CurrentValue -eq $DesiredValue) {

    # System already meets STIG requirements
    Write-Host "[Pre-Check] System is already COMPLIANT. No remediation required." -ForegroundColor Green
    $RemediationRequired = $false
}
else {
    # System does not meet STIG requirements
    Write-Host "[Pre-Check] System is NON-COMPLIANT. Remediation required." -ForegroundColor Red
    $RemediationRequired = $true
}

# ------------------------------------------------------------
# Backup Existing Registry Configuration
# ------------------------------------------------------------

# Only perform backup if remediation is needed
if ($RemediationRequired) {

    # Notify operator that backup is being created
    Write-Host "[Backup] Exporting existing registry configuration..." -ForegroundColor Cyan

    # Export the current registry key to a .reg file for rollback
    reg export `
        "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit" `
        "$BackupFile" `
        /y | Out-Null

    # Confirm backup location
    Write-Host "[Backup] Registry backup created at: $BackupFile" -ForegroundColor Green
}

# ------------------------------------------------------------
# Remediation Section
# ------------------------------------------------------------

# Proceed only if remediation is required
if ($RemediationRequired) {

    # Inform operator that remediation is starting
    Write-Host "[Remediation] Enabling command line auditing for process creation..." -ForegroundColor Cyan

    # Ensure the registry path exists (creates it if missing)
    if (-not (Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }

    # Create or update the registry value to the STIG-required setting
    New-ItemProperty `
        -Path $RegPath `
        -Name $RegName `
        -Value $DesiredValue `
        -PropertyType DWord `
        -Force | Out-Null

    # Confirm successful configuration
    Write-Host "[Remediation] Registry value successfully configured." -ForegroundColor Green
}

# ------------------------------------------------------------
# Post-Check (Tenable-aligned validation)
# ------------------------------------------------------------

# Notify operator that validation is occurring
Write-Host "[Post-Check] Validating compliance state..." -ForegroundColor Cyan

try {
    # Read the registry value after remediation
    $PostValue = (Get-ItemProperty `
        -Path $RegPath `
        -Name $RegName `
        -ErrorAction Stop).$RegName

    # Confirm the value matches the STIG requirement
    if ($PostValue -eq $DesiredValue) {
        Write-Host "[Post-Check] COMPLIANT: Command line data is enabled for process creation events." -ForegroundColor Green
    }
    else {
        Write-Host "[Post-Check] NON-COMPLIANT: Registry value does not match required configuration." -ForegroundColor Red
    }
}
catch {
    # Handle missing registry value after remediation attempt
    Write-Host "[Post-Check] NON-COMPLIANT: Registry value missing after remediation." -ForegroundColor Red
}

# Final informational message
Write-Host "[Info] STIG WN11-CC-000066 remediation completed." -ForegroundColor Cyan
