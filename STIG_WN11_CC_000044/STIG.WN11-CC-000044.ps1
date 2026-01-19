<#
.SYNOPSIS
Explicitly disables Internet Connection Sharing (ICS) to enforce
DISA STIG compliance for WN11-CC-000044.

.DESCRIPTION
This script ensures the Internet Connection Sharing policy is
EXPLICITLY enforced via Group Policy–backed registry settings.
This resolves STIG audit failures where ICS is implicitly disabled
but not formally configured.

.NOTES
Author        : Sean Santiago
Date Created  : 2026-01-17
Last Modified : 2026-01-17
Github        : https://github.com/SantiagoX86
Version       : 1.1
STIG-ID       : WN11-CC-000044
#>

# -----------------------------
# Define the registry path used by Group Policy
# -----------------------------
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections"

# -----------------------------
# Define the policy value name that controls ICS UI exposure
# -----------------------------
$RegName = "NC_ShowSharedAccessUI"

# -----------------------------
# Define the STIG-compliant value
# 0 = ICS disabled / UI hidden
# -----------------------------
$CompliantValue = 0

# -----------------------------
# Define backup storage location
# -----------------------------
$BackupDirectory = "$env:SystemDrive\STIG_Backups"
$BackupFile = "$BackupDirectory\WN11-CC-000044_Backup.reg"

# -----------------------------
# PRE-CHECK: Determine current compliance state
# -----------------------------
Write-Host "[Pre-Check] Checking current ICS policy configuration..."

# Test whether the policy registry path exists
if (Test-Path $RegPath) {

    # Attempt to read the policy value
    try {
        $CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction Stop

        # Check if the value is already STIG compliant
        if ($CurrentValue.$RegName -eq $CompliantValue) {
            Write-Host "[Pre-Check] Policy explicitly set and COMPLIANT."
            $IsCompliant = $true
        } else {
            Write-Host "[Pre-Check] Policy exists but is NON-COMPLIANT."
            $IsCompliant = $false
        }

    } catch {
        # Registry key exists but the value does not
        Write-Host "[Pre-Check] Policy path exists but value is NOT configured."
        $IsCompliant = $false
    }

} else {
    # Policy path itself does not exist
    Write-Host "[Pre-Check] Policy path does NOT exist. ICS is not explicitly controlled."
    $IsCompliant = $false
}

# -----------------------------
# BACKUP: Preserve existing policy state before making changes
# -----------------------------
if (-not $IsCompliant) {

    Write-Host "[Backup] Saving existing registry configuration..."

    # Create backup directory if missing
    if (-not (Test-Path $BackupDirectory)) {
        New-Item -Path $BackupDirectory -ItemType Directory -Force | Out-Null
    }

    # Export registry key (if it exists) for rollback purposes
    reg export `
        "HKLM\SOFTWARE\Policies\Microsoft\Windows\Network Connections" `
        $BackupFile `
        /y 2>$null

    Write-Host "[Backup] Registry backup saved to $BackupFile"
}

# -----------------------------
# REMEDIATION: Explicitly enforce STIG policy
# -----------------------------
if (-not $IsCompliant) {

    Write-Host "[Remediation] Enforcing STIG-compliant ICS policy..."

    # Create the policy path if it does not exist
    if (-not (Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }

    # Create or overwrite the policy value with the STIG-required setting
    New-ItemProperty `
        -Path $RegPath `
        -Name $RegName `
        -PropertyType DWord `
        -Value $CompliantValue `
        -Force | Out-Null

    Write-Host "[Remediation] Internet Connection Sharing explicitly DISABLED."
}

# -----------------------------
# POST-CHECK: Validate compliance for Tenable audit logic
# -----------------------------
Write-Host "[Post-Check] Validating enforcement..."

try {
    $PostCheck = Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction Stop

    if ($PostCheck.$RegName -eq $CompliantValue) {
        Write-Host "[Post-Check] COMPLIANT. Tenable will report PASS."
    } else {
        Write-Warning "[Post-Check] Policy present but NOT compliant."
    }

} catch {
    Write-Warning "[Post-Check] Policy value missing. STIG enforcement FAILED."
}
