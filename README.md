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
    - [Development of STIG Implementation Scripts](#development-of-stig-implementation-scripts)
- [STIG Implementation Development Documentation](#stig-implementation-development-documentation)
  - [1. Purpose and Scope](#1-purpose-and-scope)
  - [2. Methodology Overview](#2-methodology-overview)
  - [3. Documented STIG Implementation Cases](#3-documented-stig-implementation-cases)
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
  - [3.3 – Camera access from the lock screen must be disabled](#33--camera-access-from-the-lock-screen-must-be-disabled)
    - [Summary](#summary-2)
    - [Remediation Approach](#remediation-approach-2)
    - [Testing and Iteration](#testing-and-iteration-2)
    - [Outcome](#outcome-2)
    - [Final Status](#final-status-2)
  - [3.4 – Internet connection sharing must be disabled.](#34--internet-connection-sharing-must-be-disabled)
    - [Summary](#summary-3)
    - [Remediation Approach](#remediation-approach-3)
    - [Testing and Iteration](#testing-and-iteration-3)
    - [Outcome](#outcome-3)
    - [Final Status](#final-status-3)
  - [3.5 – Command line data must be included in process creation events](#35--command-line-data-must-be-included-in-process-creation-events)
    - [Summary](#summary-4)
    - [Remediation Approach](#remediation-approach-4)
    - [Testing and Iteration](#testing-and-iteration-4)
    - [Outcome](#outcome-4)
    - [Final Status](#final-status-4)
  - [3.6 – Microsoft consumer experiences must be turned off](#36--microsoft-consumer-experiences-must-be-turned-off)
    - [Summary](#summary-5)
    - [Remediation Approach](#remediation-approach-5)
    - [Testing and Iteration](#testing-and-iteration-5)
    - [Outcome](#outcome-5)
    - [Final Status](#final-status-5)
  - [4. Conclusion](#4-conclusion)
  - [5. Appendix: Evidence Artifacts](#5-appendix-evidence-artifacts)

---

### Initial STIG Audit Scan of Azure VM LogNPacific3446

In this phase the initial scan was conducted and STIG failures were identified.

---

### Traige and Prioritization

This stage consisted of analyzing STIG failures to ensure Powershell implementation is feasible and that implementation would not break any necessary functionality such as subsequent Tenable scans, remote access, etc.

---

### Development of STIG Implementation Scripts

Through the use of AI, STIG Implementation scripts were developed. Iterative process was used in development in which language processing engines were prompted for scripts and scripts were manually analyzed, tested in a sandbox environment for execution success, and results were observed, documented, and actioned until intended results were achieved.

# STIG Implementation Development Documentation  
**Enterprise STIG Implementation Lifecycle**

---

## 1. Purpose and Scope

This document provides formal documentation of the STIG implementation development lifecycle for identified findings on Microsoft Azure Windows 11 virtual machines. It details the methodology used to design, test, validate, and disposition STIG implementations.

The documentation includes evidence of iterative testing, validation through subsequent vulnerability scans, and final implementaiton outcomes or risk disposition decisions.

---

## 2. Methodology Overview

The STIG implementation lifecycle followed a standardized enterprise approach:

1. **Identification**  
   STIG failures were identified through authenticated Tenable STIG audit scans.

2. **Analysis**  
   Each finding was reviewed to determine applicability, technical impact, and implementation feasibility.

3. **STIG Implementation Development**  
   For each STIG, an implementation script was developed using AI prompting and manual evaluation.

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

## 3. Documented STIG Implementation Cases

---

## 3.1 – Structured Exception Handling Overwrite Protection (SEHOP) must be enabled
**WN11-00-000150**

### Summary
A STIG failure was identified in which structured Exception Handling Overwrite Protection(SEHOP) was not enabled and it should be enabled..

### Remediation Approach
- ChatGPT was prompted to develop a STIG implementation script to be used on this VM that is scaleable to enterprise environment.
- Script was manually reviewed and run on VM to test effectiveness

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
- ChatGPT was prompted to develop a STIG implementation script to be used on this VM that is scaleable to enterprise environment.
- Script was manually reviewed and run on VM to test effectiveness

### Testing and Iteration
- Implementation script run resulting in message that STIG had been implemented effectively and that VM should pass audit for this STIG
- Subsequent Tenable STIG audit scan run to verify implementation

### Outcome
- WDigest effectively disabled

### Final Status
**STIG implemented successfully**

---

## 3.3 – Camera access from the lock screen must be disabled  
**WN11-CC-000005**

### Summary
Disabling camera access from the Windows lock screen to prevent use of imaging hardware before user authentication. Allowing camera functionality at the lock screen could enable unauthorized image or video capture without valid credentials, increasing the system’s pre-authentication attack surface. Enforcing this setting ensures hardware resources are only available after sign-in and supports least-privilege and enterprise security compliance requirements.

### Remediation Approach
- ChatGPT was prompted to develop a STIG implementation script to be used on this VM that is scaleable to enterprise environment.
- Script was manually reviewed and run on VM to test effectiveness

### Testing and Iteration
- Implementation script run resulting in message that STIG had been implemented effectively and that VM should pass audit for this STIG
- Subsequent Tenable STIG audit scan run to verify implementation

### Outcome
- Camera access while VM in lock-screen state effectively disabled

### Final Status
**STIG implemented successfully**

---

## 3.4 – Internet connection sharing must be disabled.
**WN11-CC-000044**

### Summary
Internet connection sharing makes it possible for an existing internet connection, such as through wireless, to be shared and used by other systems essentially creating a mobile hotspot. This exposes the system sharing the connection to others with potentially malicious purpose.

### Remediation Approach
- ChatGPT was prompted to develop a STIG implementation script to be used on this VM that is scaleable to enterprise environment.
- Script was manually reviewed and run on VM to test effectiveness

### Testing and Iteration
- Implementation script run resulting in message that STIG had been implemented effectively and that VM should pass audit for this STIG
- Subsequent Tenable STIG audit scan run to verify implementation and found that VM passed this STIG audit item

### Outcome
- Internet connection sharing disabled

### Final Status
**STIG implemented successfully**

---

## 3.5 – Command line data must be included in process creation events
**WN11-CC-000066**

### Summary
Maintaining an audit trail of system activity logs can help identify configuration errors, troubleshoot service disruptions, and analyze compromises that have occurred, as well as detect attacks. Audit logs are necessary to provide a trail of evidence in case the system or network is compromised. Collecting this data is essential for analyzing the security of information assets and detecting signs of suspicious and unexpected behavior.Enabling 'Include command line data for process creation events' will record the command line information with the process creation events in the log. This can provide additional detail when malware has run on a system.

### Remediation Approach
- ChatGPT was prompted to develop a STIG implementation script to be used on this VM that is scaleable to enterprise environment.
- Script was manually reviewed and run on VM to test effectiveness

### Testing and Iteration
- Implementation script run resulting in message that STIG had been implemented effectively and that VM should pass audit for this STIG
- Subsequent Tenable STIG audit scan run to verify implementation

### Outcome
- Command line data is enabled for process creation events

### Final Status
**STIG implemented successfully**

---

## 3.6 – Microsoft consumer experiences must be turned off
**WN11-CC-000197**

### Summary
Microsoft consumer experiences provides suggestions and notifications to users, which may include the installation of Windows Store apps. Organizations may control the execution of applications through other means such as allowlisting. Turning off Microsoft consumer experiences will help prevent the unwanted installation of suggested applications.

### Remediation Approach
- ChatGPT was prompted to develop a STIG implementation script to be used on this VM that is scaleable to enterprise environment.
- Script was manually reviewed and run on VM to test effectiveness

### Testing and Iteration
- Implementation script run resulting in message that STIG had been implemented effectively and that VM should pass audit for this STIG
- Subsequent Tenable STIG audit scan run to verify implementation

### Outcome
- Microsoft consumer experiences effectively disabled

### Final Status
**STIG implemented successfully**

---

## 4. Conclusion

This STIG implementation effort demonstrates a structured, repeatable, and auditable approach to STIG audit failure management. Where automation was feasible, STIG failures were successfully remediated and verified. Where technical or platform limitations existed, risks were clearly documented and escalated for appropriate governance decisions.

---

## 5. Appendix: Evidence Artifacts

- Tenable scan reports (pre- and post-remediation)

