# VulnerabilityManagement
Vulnerability Management project in which I used the Tenable Vulnerability Management platform to scan Windows11 VM on an Azure Network, applied pre-built remediation scripts in Powershell, and developed/applied additional scripts to remediate remaining vulnerabilities

---


<img width="1000" alt="image" src="https://github.com/user-attachments/assets/cfc5dbcf-3fcb-4a71-9c13-2a49f8bab3e6">

# Technology Utilized
- Tenable (enterprise vulnerability management platform)
- Azure Virtual Machines (Nessus scan engine + scan targets)
- PowerShell & BASH (remediation scripts)
- ChatGPT (additional remediation script development)

---


# Table of Contents

- [VulnerabilityManagement](#vulnerabilitymanagement)
- [Technology Utilized](#technology-utilized)
- [Table of Contents](#table-of-contents)
    - [Initial Vulnerability Scan of Azure VM LogNPacific3286](#initial-vulnerability-scan-of-azure-vm-lognpacific3286)
    - [Traige and Prioritization](#traige-and-prioritization)
    - [Application of Pre-built Remediation Scripts](#application-of-pre-built-remediation-scripts)
    - [Secondary Scan Following Application of Remediation Scripts](#secondary-scan-following-application-of-remediation-scripts)
    - [Development of Additional Remediation Scripts](#development-of-additional-remediation-scripts)
- [Remediation Development Documentation](#remediation-development-documentation)
  - [1. Purpose and Scope](#1-purpose-and-scope)
  - [2. Methodology Overview](#2-methodology-overview)
  - [3. Control Alignment Summary](#3-control-alignment-summary)
  - [4. Documented Remediation Cases](#4-documented-remediation-cases)
  - [4.1 WinVerifyTrust Signature Validation](#41-winverifytrust-signature-validation)
    - [Summary](#summary)
    - [Remediation Approach](#remediation-approach)
    - [Testing and Iteration](#testing-and-iteration)
    - [Outcome](#outcome)
    - [Final Status](#final-status)
  - [4.2 Security Updates – Outlook for Windows (April 2024)](#42-security-updates--outlook-for-windows-april-2024)
    - [Summary](#summary-1)
    - [Remediation Approach](#remediation-approach-1)
    - [Testing and Iteration](#testing-and-iteration-1)
    - [Verification](#verification)
    - [Final Status](#final-status-1)
  - [4.3 Microsoft Teams for Desktop Remote Code Execution](#43-microsoft-teams-for-desktop-remote-code-execution)
    - [Summary](#summary-2)
    - [Remediation Approach](#remediation-approach-2)
    - [Challenges Encountered](#challenges-encountered)
    - [Testing Results](#testing-results)
    - [Conclusion](#conclusion)
    - [Final Status](#final-status-2)
  - [4.4 SSL Certificate Trust Issues](#44-ssl-certificate-trust-issues)
    - [Summary](#summary-3)
    - [Remediation Approach](#remediation-approach-3)
    - [Iteration and Analysis](#iteration-and-analysis)
    - [Limitations Identified](#limitations-identified)
    - [Final Status](#final-status-3)
  - [4.5 ICMP Timestamp Request Remote Date Disclosure](#45-icmp-timestamp-request-remote-date-disclosure)
    - [Summary](#summary-4)
    - [Remediation Approach](#remediation-approach-4)
    - [Testing Results](#testing-results-1)
    - [Risk Analysis](#risk-analysis)
    - [Final Status](#final-status-4)
  - [5. Risk Management and Exception Handling](#5-risk-management-and-exception-handling)
  - [6. Conclusion](#6-conclusion)
  - [7. Appendix: Evidence Artifacts](#7-appendix-evidence-artifacts)

---

### Initial Vulnerability Scan of Azure VM LogNPacific3286

In this phase the initial scan was conducted and vulnerabilities were identified and prioritized. Existing related remediation scripts were identified for patch application via powershell execution.

---

### Traige and Prioritization

This stage consisted of analyzing vulnerabilities in terms of criticality using Tenable platform, assets affected, and ease of remediation based on existence of remediation script as opposed to those for which a script would need to be developed.

---

### Application of Pre-built Remediation Scripts

Role out of applications of the various scripts that had been identified in the previous phase to automate vulnerability remediation in a way that would be easily applicable at scale. Remediation application will vary by vulnerability based on information gathered in Triage and after a consultation with stakeholders. Significant remediation script application would ideally be conducted in stages as follows:
- Roleback developed and put in place
- Sandbox stage role out in a synthetic environment
- Small scale role out on minimal number of least critical assets
- Small scale role out on minimal number of assets of all criticality levels
- Full scale role out on all vulnerable assets

---

### Secondary Scan Following Application of Remediation Scripts

Following application of existing remediation scripts a scan was conducted to confirm remediation of vulnerabilities. Identification of remaining vulnerabilities was also conducted during this stage for development of remediation automation scripts.

---

### Development of Additional Remediation Scripts

Through the use of AI, additional remediation scripts were developed including reversal scripts for role back during testing in case remediation scripts have unintended consequnces affecting dependent network assets. Iterative process was used in development in development in which language processing engines were prompted for scripts and scripts were tested in a sandbox environment for execution success and results were observed, documented, and actioned until intended results were achieved. Same process was followed for reversal scripts.

# Remediation Development Documentation  
**Enterprise Vulnerability Remediation Lifecycle**

---

## 1. Purpose and Scope

This document provides formal documentation of the vulnerability remediation development lifecycle for identified findings on Microsoft Azure Windows 11 virtual machines. It details the methodology used to design, test, validate, and disposition remediations in alignment with recognized security frameworks, including:

- **NIST Cybersecurity Framework (CSF)**
- **NIST SP 800-53 Rev. 5**
- **CIS Critical Security Controls**
- **ISO/IEC 27001:2022**

The documentation includes evidence of iterative testing, validation through subsequent vulnerability scans, and final remediation outcomes or risk disposition decisions.

---

## 2. Methodology Overview

The remediation lifecycle followed a standardized enterprise approach:

1. **Identification**  
   Vulnerabilities were identified through authenticated Tenable vulnerability scans.

2. **Analysis**  
   Each finding was reviewed to determine applicability, technical impact, and remediation feasibility.

3. **Remediation Development**  
   For each vulnerability, a standardized three-script model was developed:
   - **Backup Script** – Captures system state to enable rollback
   - **Remediation Script** – Implements corrective controls
   - **Rollback Script** – Restores the system to its pre-remediation state if required

4. **Testing**  
   Scripts were executed in sandbox environments to validate behavior and error handling.

5. **Verification**  
   Tenable scans were rerun to confirm remediation effectiveness.

6. **Disposition**  
   Vulnerabilities were either:
   - Successfully remediated
   - Determined not applicable
   - Determined not fully remediable via automation
   - Escalated for formal risk acceptance

---

## 3. Control Alignment Summary

| Framework | Alignment |
|---------|----------|
| **NIST CSF** | PR.IP-1, PR.IP-3, PR.MA-1 |
| **NIST SP 800-53** | SI-2, CM-3, CM-6, CP-9 |
| **CIS Controls** | Control 7 (Continuous Vulnerability Management), Control 4 (Secure Configuration) |
| **ISO/IEC 27001** | Annex A.8.8, A.8.9, A.8.32 |

---

## 4. Documented Remediation Cases

---

## 4.1 WinVerifyTrust Signature Validation  
**CVE-2013-3900 | Tenable Plugin ID 166555**

### Summary
A vulnerability was identified related to improper certificate padding validation in the WinVerifyTrust API.

### Remediation Approach
ChatGPT was prompted to develop three PowerShell scripts (backup, remediation, rollback) to enable the `EnableCertPaddingCheck` registry setting.

### Testing and Iteration
- Initial backup attempts failed due to missing or inaccessible paths.
- Scripts were rewritten to handle missing path errors gracefully.
- The final backup script executed successfully but was unable to generate backups, triggering user notification and caution messaging.

### Outcome
- The remediation script executed successfully.
- The registry setting was applied as intended.
- A subsequent Tenable scan confirmed successful remediation.

### Final Status
**Remediated Successfully**

---

## 4.2 Security Updates – Outlook for Windows (April 2024)  
**Tenable Plugin ID 193266 | Severity: High**

### Summary
A vulnerability related to missing Outlook security updates was detected.

### Remediation Approach
Three scripts were developed to detect the Office installation type (Click-to-Run versus MSI) and remediate accordingly.

### Testing and Iteration
- The backup script failed to create backups due to missing artifacts.
- The remediation script initially failed due to missing Click-to-Run components.
- The script was rewritten to detect MSI-based installations and residual registry artifacts.

### Verification
- The script correctly identified that Outlook was not installed.
- A Tenable scan confirmed the vulnerability was no longer applicable.

### Final Status
**Not Applicable – Software Not Installed**

---

## 4.3 Microsoft Teams for Desktop Remote Code Execution  
**Version < 25122.1415.3698.6812 | Plugin ID 250276 | Severity: High**

### Summary
A remote code execution vulnerability affecting Microsoft Teams for Desktop was identified.

### Remediation Approach
Multiple remediation strategies were attempted to:
- Remove legacy (Classic) Teams components
- Validate or install New Teams
- Clear residual caches
- Enforce machine-wide installation

### Challenges Encountered
- Architectural differences between Classic Teams (per-user) and New Teams (MSIX-based)
- Azure VM Microsoft Store and MSIX restrictions
- Installer failures related to:
  - Missing prerequisites
  - User-versus-system installation context
  - Stub installer behavior

### Testing Results
Despite multiple script iterations and troubleshooting logic:
- Remediation scripts executed successfully
- Tenable scans continued to report the vulnerability

### Conclusion
The vulnerability could not be reliably remediated via PowerShell automation due to platform and installer limitations.

### Final Status
**Not Remediable via Automation – Requires Platform or Vendor Resolution**

---

## 4.4 SSL Certificate Trust Issues  
**Tenable Plugin IDs 51192, 57582 | Severity: Medium**

### Summary
Tenable identified SSL certificates that were either self-signed or not trusted.

### Remediation Approach
Initial scripts attempted certificate replacement but were determined to provide superficial scanner remediation without materially improving security posture.

### Iteration and Analysis
- Legitimate remediation requires CA-issued certificates.
- Azure Key Vault–based certificate deployment was explored.
- Azure PowerShell dependencies (NuGet and Az modules) were incorporated into the scripts.

### Limitations Identified
Remediation requires:
- Existing CA-issued certificates
- Azure Key Vault access
- Credential configuration

These prerequisites exist outside the VM and cannot be fully automated.

### Final Status
**Conditionally Remediable – Requires PKI and Azure Key Vault Integration**

---

## 4.5 ICMP Timestamp Request Remote Date Disclosure  
**Tenable Plugin ID 10114 | Severity: Low**

### Summary
A low-risk reconnaissance vulnerability related to ICMP timestamp responses was identified.

### Remediation Approach
Scripts were developed to block ICMP timestamp traffic for both IPv4 and IPv6.

### Testing Results
- Firewall rules were applied successfully.
- Tenable scans continued to report the vulnerability.

### Risk Analysis
- This vulnerability is common in cloud environments.
- It does not provide authentication bypass or system access.
- Microsoft and Tenable acknowledge platform-level constraints for this finding.

### Final Status
**Risk Accepted – Documented Exception Recommended**

---

## 5. Risk Management and Exception Handling

For vulnerabilities determined to be:
- Not applicable
- Not fully automatable
- Platform-constrained

A formal risk exception is recommended in accordance with:
- ISO/IEC 27001 risk treatment requirements
- NIST risk management guidance

Exceptions should be reviewed and approved by appropriate management authority.

---

## 6. Conclusion

This remediation effort demonstrates a structured, repeatable, and auditable approach to vulnerability management. Where automation was feasible, vulnerabilities were successfully remediated and verified. Where technical or platform limitations existed, risks were clearly documented and escalated for appropriate governance decisions.

---

## 7. Appendix: Evidence Artifacts

- Tenable scan reports (pre- and post-remediation)

