<#
.SYNOPSIS
    Disables WDigest Authentication to enforce security compliance.
    This remediates STIG WN11-CC-000038 by preventing storage of user credentials
    in clear text in memory, reducing credential theft risk.

.DESCRIPTION
    WDigest authentication can store user passwords in memory in plain text.
    Disabling it ensures that credentials cannot be easily harvested from memory.
    This script performs a pre-check, applies the remediation, and validates
    the configuration change.

.NOTES
    Author        : Sean Santiago
    Date Created  : 2026-01-15
    Last Modified : 2026-01-15
    Tested On     : Windows 11 Pro, Azure VM

.LINK
    STIG Reference: https://public.cyber.mil/stigs/

.USAGE
    1. This script must be run **as an Administrator**.
    2. After successful remediation, a **system reboot is required** for the changes to take effect.
    3. Run in PowerShell ISE or elevated PowerShell prompt.
#>

# Ensure script is running as administrator
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator")) {
    Write-Host "[Error] This script must be run as Administrator." -ForegroundColor Red
    Exit 1
}

# Define the registry path and value
$regPath  = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest"
$regName  = "UseLogonCredential"
$desiredValue = 0

Write-Host "[Pre-Check] Checking current WDigest Authentication setting..." -ForegroundColor Cyan

# Check if the registry key exists
if (Test-Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regName
    if ($currentValue -eq $desiredValue) {
        Write-Host "[Info] WDigest Authentication is already DISABLED. No remediation required." -ForegroundColor Green
    }
    else {
        Write-Host "[Warning] WDigest Authentication is ENABLED. Remediation required." -ForegroundColor Yellow

        # Remediation: Set UseLogonCredential to 0
        try {
            Write-Host "[Remediation] Disabling WDigest Authentication..." -ForegroundColor Cyan
            Set-ItemProperty -Path $regPath -Name $regName -Value $desiredValue -Force
            Write-Host "[Remediation] Registry updated successfully." -ForegroundColor Green
        }
        catch {
            Write-Host "[Error] Failed to update registry: $_" -ForegroundColor Red
        }

        # Post-check
        $newValue = Get-ItemProperty -Path $regPath -Name $regName | Select-Object -ExpandProperty $regName
        if ($newValue -eq $desiredValue) {
            Write-Host "[Post-Check] WDigest Authentication is now DISABLED." -ForegroundColor Green
            Write-Host "[Info] A system reboot is required for changes to take effect." -ForegroundColor Yellow
        }
        else {
            Write-Host "[Post-Check] Remediation failed. WDigest Authentication is still ENABLED." -ForegroundColor Red
        }
    }
}
else {
    Write-Host "[Error] WDigest registry key does not exist on this system. No action taken." -ForegroundColor Red
}

# End of script
