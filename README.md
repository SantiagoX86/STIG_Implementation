# STIG Implementation
Security Technical Implementation Guides project in which I used the Tenable Vulnerability Management platform to scan Windows11 VM on an Azure Network, identified STIG audit failures, developed Powershell scripts to implement STIGS, and applied STIG scripts in Powershell.

---


<img width="1000" alt="image" src="https://github.com/SantiagoX86/STIG_Implementation/blob/main/1684777317266.png">

# Technology Utilized
- Tenable (enterprise vulnerability management platform)
- Azure Virtual Machines (Nessus scan engine + scan targets)
- PowerShell & BASH (STIG scripts)
- ChatGPT (STIG script development)

---


# Table of Contents

- [STIG Implementation](#stig-implementation)
- [Technology Utilized](#technology-utilized)
- [Table of Contents](#table-of-contents)
    - [Initial STIG Audit Scan of Azure VM LogNPacific3446](#initial-stig-audit-scan-of-azure-vm-lognpacific3446)
    - [Traige and Prioritization](#traige-and-prioritization)
    - [Development of Remediation Scripts](#development-of-remediation-scripts)
- [Remediation Development Documentation](#remediation-development-documentation)
  - [1. Purpose and Scope](#1-purpose-and-scope)
  - [2. Methodology Overview](#2-methodology-overview)
  - [3. Documented Remediation Cases](#3-documented-remediation-cases)
  - [3.1 – Structured Exception Handling Overwrite Protection (SEHOP) must be enabled](#31--structured-exception-handling-overwrite-protection-sehop-must-be-enabled)
    - [Summary](#summary)
    - [Remediation Approach](#remediation-approach)
    - [Testing and Iteration](#testing-and-iteration)
    - [Outcome](#outcome)
    - [Final Status](#final-status)
  - [3.2 – WDigest Authentication must be disabled](#32--wdigest-authentication-must-be-disabled)
    - [Summary](#summary-1)
    - [Remediation Approach](#remediation-approach-1)
    - [Testing and Iteration](#testing-and-iteration-1)
    - [Outcome](#outcome-1)
    - [Final Status](#final-status-1)
  - [3.3 Microsoft Teams for Desktop Remote Code Execution](#33-microsoft-teams-for-desktop-remote-code-execution)
    - [Summary](#summary-2)
    - [Remediation Approach](#remediation-approach-2)
    - [Challenges Encountered](#challenges-encountered)
    - [Testing Results](#testing-results)
    - [Conclusion](#conclusion)
    - [Final Status](#final-status-2)
  - [3.4 SSL Certificate Trust Issues](#34-ssl-certificate-trust-issues)
    - [Summary](#summary-3)
    - [Remediation Approach](#remediation-approach-3)
    - [Iteration and Analysis](#iteration-and-analysis)
    - [Limitations Identified](#limitations-identified)
    - [Final Status](#final-status-3)
  - [3.5 ICMP Timestamp Request Remote Date Disclosure](#35-icmp-timestamp-request-remote-date-disclosure)
    - [Summary](#summary-4)
    - [Remediation Approach](#remediation-approach-4)
    - [Testing Results](#testing-results-1)
    - [Risk Analysis](#risk-analysis)
    - [Final Status](#final-status-4)
  - [5. Risk Management and Exception Handling](#5-risk-management-and-exception-handling)
  - [6. Conclusion](#6-conclusion)
  - [7. Appendix: Evidence Artifacts](#7-appendix-evidence-artifacts)

---

### Initial STIG Audit Scan of Azure VM LogNPacific3446

In this phase the initial scan was conducted and STIG failures were identified.

---

### Traige and Prioritization

This stage consisted of analyzing STIG failures to ensure Powershell implementation is feasible and that implementation would not break any necessary functionality such as subsequent Tenable scans, remote access, etc.

---

### Development of Remediation Scripts

Through the use of AI, remediation scripts were developed. Iterative process was used in development in which language processing engines were prompted for scripts and scripts were manually analyzed, tested in a sandbox environment for execution success, and results were observed, documented, and actioned until intended results were achieved.

# Remediation Development Documentation  
**Enterprise Vulnerability Remediation Lifecycle**

---

## 1. Purpose and Scope

This document provides formal documentation of the STIG implementation development lifecycle for identified findings on Microsoft Azure Windows 11 virtual machines. It details the methodology used to design, test, validate, and disposition remediations.

The documentation includes evidence of iterative testing, validation through subsequent vulnerability scans, and final remediation outcomes or risk disposition decisions.

---

## 2. Methodology Overview

The remediation lifecycle followed a standardized enterprise approach:

1. **Identification**  
   STIG failures were identified through authenticated Tenable STIG audit scans.

2. **Analysis**  
   Each finding was reviewed to determine applicability, technical impact, and remediation feasibility.

3. **Remediation Development**  
   For each vulnerability, an implementation script was developed using AI prompting and manual evaluation.

4. **Testing**  
   Scripts were executed in sandbox environments to validate behavior and error handling.

5. **Verification**  
   Tenable scans were rerun to confirm STIG implementation effectiveness.

6. **Disposition**  
   STIG were either:
   - Successfully implemented leading to 
   - Determined not applicable
   - Determined not fully remediable via automation
   - Escalated for formal risk acceptance

---

## 3. Documented Remediation Cases

---

## 3.1 – Structured Exception Handling Overwrite Protection (SEHOP) must be enabled
**WN11-00-000150**

### Summary
A STIG failure was identified in which structured Exception Handling Overwrite Protection(SEHOP) was not enabled and it should be enabled..

### Remediation Approach
ChatGPT was prompted to develop a STIG implementation script to be used on this VM and scaleable to enterprise environment.

### Testing and Iteration
- Initial execution of script returned that SEHOP had been implemented and that audit failure should be remediated
- Subseqquent scan showed STIG passed audit

### Outcome
- The execution of script successfully enabled SEHOP

### Final Status
**STIG Implemented Successfully**

---

## 3.2 – WDigest Authentication must be disabled 
**WN11-CC-000038**

### Summary
WDigest authentication stores passwords in memory in clear text for HTTP/S authentication. This is a security risk because an attacker who gains memory access could retrieve user passwords. Disabling WDigest prevents this exposure.

### Remediation Approach
ChatGPT was prompted to develop a STIG implementation script to be used on this VM and scaleable to enterprise environment.

### Testing and Iteration
- Implementation script run resulting in message that STIG had been implemented effectively and that VM should pass audit for this STIG
- Subsequent Tenable STIG audit scan run to verify implementation

### Outcome
- WDigest effectively disabled

### Final Status
**STIG implemented successfully**

---

## 3.3 Microsoft Teams for Desktop Remote Code Execution  
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

## 3.4 SSL Certificate Trust Issues  
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

## 3.5 ICMP Timestamp Request Remote Date Disclosure  
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

