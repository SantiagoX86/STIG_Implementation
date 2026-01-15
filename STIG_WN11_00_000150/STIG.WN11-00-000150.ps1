<#
.SYNOPSIS
    Enables Structured Exception Handling Overwrite Protection (SEHOP) to enforce security compliance.
    This remediates STIG WN11-00-000150 by enabling SEHOP, reducing the risk of memory corruption
    and exception handling attacks.

.NOTES
    Author        : Sean Santiago
    Date Created  : 2026-01-15
    Last Modified : 2026-01-15
    Github        : https://github.com/SantiagoX86
    Version       : 1.0
    CVEs          : N/A
    Plugin IDs    : N/A
    STIG-ID       : WN11-00-000150

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : Azure Windows 11 VMs
    PowerShell Ver. : 5.1+

.USAGE
    Run this script with Administrator privileges on the target VM.
    A reboot may be required for the setting to take effect.
    
    Example syntax:
    PS C:\> .\Remediate-WN11-00-000150-SEHOP.ps1
#>

# -----------------------------
# Function: Test-SEHOP
# Purpose: Check if SEHOP is enabled
# -----------------------------
function Test-SEHOP {
    try {
        $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel"
        $sehValue = Get-ItemProperty -Path $regPath -Name "DisableExceptionChainValidation" -ErrorAction Stop
        if ($sehValue.DisableExceptionChainValidation -eq 0) {
            Write-Host "[Pre-Check] SEHOP is ENABLED. No remediation required." -ForegroundColor Green
            return $true
        } else {
            Write-Host "[Pre-Check] SEHOP is DISABLED. Remediation is required." -ForegroundColor Yellow
            return $false
        }
    } catch {
        Write-Warning "[Pre-Check] Registry key not found or cannot be read. Assuming SEHOP remediation is required."
        return $false
    }
}

# -----------------------------
# Function: Enable-SEHOP
# Purpose: Enable SEHOP by setting the correct registry value
# -----------------------------
function Enable-SEHOP {
    try {
        $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel"
        Write-Host "[Remediation] Enabling SEHOP..." -ForegroundColor Cyan
        Set-ItemProperty -Path $regPath -Name "DisableExceptionChainValidation" -Value 0 -Type DWord
        Write-Host "[Remediation] SEHOP registry value set successfully." -ForegroundColor Green
    } catch {
        Write-Error "[Remediation] Failed to enable SEHOP: $_"
    }
}

# -----------------------------
# Function: Verify-SEHOP
# Purpose: Post-check to confirm SEHOP is enabled for Tenable STIG compliance
# -----------------------------
function Verify-SEHOP {
    $compliant = $true
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel"

    try {
        $sehValue = Get-ItemProperty -Path $regPath -Name "DisableExceptionChainValidation" -ErrorAction Stop
        if ($sehValue.DisableExceptionChainValidation -eq 0) {
            Write-Host "[Post-Check] SEHOP is ENABLED. Compliance verified." -ForegroundColor Green
        } else {
            Write-Warning "[Post-Check] SEHOP is DISABLED. Remediation FAILED."
            $compliant = $false
        }
    } catch {
        Write-Error "[Post-Check] Unable to read registry key: $_"
        $compliant = $false
    }

    return $compliant
}

# -----------------------------
# Main Script Execution
# -----------------------------
Write-Host "========== WN11-00-000150: Enable SEHOP Script ==========" -ForegroundColor White

# Step 1: Pre-Check
$sehEnabled = Test-SEHOP

# Step 2: Remediation
if (-not $sehEnabled) {
    Enable-SEHOP
} else {
    Write-Host "[Info] No remediation required. SEHOP is already enabled." -ForegroundColor Green
}

# Step 3: Post-Check
$remediationSuccess = Verify-SEHOP

# Step 4: Final Result Logging
if ($remediationSuccess) {
    Write-Host "[Result] STIG WN11-00-000150 remediation complete and verified for Tenable audit." -ForegroundColor Green
} else {
    Write-Warning "[Result] STIG WN11-00-000150 remediation FAILED. Manual review required."
}

Write-Host "===================================================================" -ForegroundColor White
