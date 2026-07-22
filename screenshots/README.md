# Lab 1 — Evidence Screenshots
### Active Directory — Windows Server 2025 on Azure · Completed 27 May 2026

This folder contains sequential evidence screenshots captured during live lab execution.
Every step was performed and verified in real time. Screenshots are numbered in execution order.

---

## Environment Setup

### 01 — Azure VM Creation
![Azure VM Creation](01-azure-vm-creation.png)

**What this proves:** Azure free account configured with Windows Server 2025 Datacenter Gen2, Standard_B2s size (2 vCPU, 4GB RAM), East US region, RDP port 3389 enabled. Correct VM specification for running Active Directory Domain Services.

---

### 02 — VM Running in Azure Portal
![VM Running](02-vm-running.png)

**What this proves:** Virtual machine `testlabVM` provisioned and running in Azure. Public IP assigned. Status confirmed as Running before RDP connection.

---

### 03 — RDP Connection
![RDP Connection](03-rdp-connection.png)

**What this proves:** Connected to the VM using the downloaded RDP file (not browser console) — this enables clipboard sharing for command paste, as documented in the lab guide. Clipboard option confirmed enabled in RDP settings.

---

## Active Directory Domain Services Installation

### 04 — AD DS Role Installation Progress
![AD DS Installation](04-adds-installation.png)

**What this proves:** Add Roles and Features Wizard showing Active Directory Domain Services role selected and installing. Management tools included. Server Manager showing AD DS tile appearing.

---

### 05 — PowerShell — Install-WindowsFeature
![PowerShell AD DS Install](05-powershell-adds-install.png)

**What this proves:** `Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools` executed in PowerShell ISE. Success result confirms role installed. Note use of PowerShell ISE (not standard PS window) to allow full script review before execution.

---

### 06 — GPMC Installed — Server Manager Updated
![GPMC Installed](06-gpmc-installed.png)

**What this proves:** Group Policy Management Console installed immediately after AD DS. `Install-WindowsFeature -Name GPMC` completed. Server Manager Tools menu now shows Group Policy Management as a separate tool from ADUC — a deliberate step to avoid the common mistake of looking for GPO management inside Active Directory Users and Computers.

---

## Domain Controller Promotion

### 07 — Prerequisites Check — All Passed
![DC Promotion Prerequisites](07-dc-promotion-prereqs.png)

**What this proves:** Active Directory Domain Services Configuration Wizard prerequisites check completed. Green banner: "All prerequisite checks passed successfully." Warnings shown are expected and non-blocking for a lab environment (static IP and DNS delegation — normal for Azure-hosted single-DC labs).

---

### 08 — Server Rebooting After Promotion
![DC Promotion Reboot](08-dc-promotion-reboot.png)

**What this proves:** "You're about to be signed out — The computer is being restarted because Active Directory Domain Services was installed or removed." This confirms successful DC promotion. The server is now the domain controller for `lab.local`.

---

### 09 — Server Manager Post-Promotion
![Post-Promotion Server Manager](09-post-promotion-server-manager.png)

**What this proves:** After reboot, Server Manager shows AD DS and DNS roles both active. Forest `lab.local` created. This server is now the root domain controller, authoritative DNS server, and holds all 5 FSMO roles.

---

## Organisational Unit Structure

### 10 — OUs Created in ADUC GUI
![OUs in ADUC](10-ous-created-aduc.png)

**What this proves:** Active Directory Users and Computers showing all 5 OUs created under `lab.local` — IT, Finance, HR, Sales, Computers. GUI method demonstrated first, then PowerShell.

---

### 11 — PowerShell — OU Creation Script
![OU PowerShell](11-ous-powershell.png)

**What this proves:** `New-ADOrganizationalUnit` commands executed in PowerShell ISE creating all 5 OUs simultaneously. Path parameter `DC=lab,DC=local` places each OU at the root of the domain. Note error shown for duplicate OU (expected when running after GUI creation — confirms OUs already exist).

---

## Security Groups

### 12 — Security Groups Created in PowerShell ISE
![Security Groups](12-security-groups-powershell.png)

**What this proves:** All 4 security groups created — `IT_Admins`, `Finance_Users`, `HR_Users`, `Sales_Users`. GroupScope Global, GroupCategory Security. Each group placed inside its corresponding OU. `-WhatIf` flag tested first to preview the operation before execution.

---

## User Accounts

### 13 — User Creation Script — PowerShell ISE
![User Creation](13-users-created-powershell.png)

**What this proves:** Full user creation block executed as a single unit in PowerShell ISE — not line by line. `$password` variable defined first. All 4 users created: `alice.chen` (IT), `bob.patel` (Finance), `carol.jones` (HR), `david.smith` (Sales). All added to their department security groups in the same script block.

---

### 14 — Users Visible in ADUC
![Users in ADUC](14-users-in-aduc.png)

**What this proves:** Active Directory Users and Computers confirming user accounts exist in their correct OUs. Finance OU showing `bob.patel`. Group memberships confirmed.

---

## Group Policy Configuration

### 15 — GPO Created and Linked to IT OU
![GPO Linked](15-gpo-linked.png)

**What this proves:** Group Policy Management Console showing `slootGPO1` created and linked to the IT OU (`lab.local/IT`). Link enabled. Security filtering shows Authenticated Users. GPO visible in the left-hand tree under the IT OU.

---

### 16 — GPO — Minimum Password Length Set to 12
![Password Length Policy](16-gpo-password-policy.png)

**What this proves:** Group Policy Management Editor → Computer Configuration → Windows Settings → Security Settings → Account Policies → Password Policy. Minimum password length set to 12 characters. Policy setting defined and enabled.

---

### 17 — GPO — Password Complexity Enabled
![Password Complexity](17-gpo-complexity.png)

**What this proves:** "Password must meet complexity requirements" set to Enabled. This enforces upper case, lower case, numbers, and special characters — applied to all users in the IT OU.

---

### 18 — GPO — Machine Inactivity Limit 900 Seconds
![Screen Lock Policy](18-gpo-screen-lock.png)

**What this proves:** Interactive logon: Machine inactivity limit set to 900 seconds (15 minutes). Auto-locks screen after 15 minutes of inactivity. Applied via Computer Configuration → Security Options.

---

### 19 — GPO — Removable Storage Policy
![USB Policy](19-gpo-usb-policy.png)

**What this proves:** All Removable Storage Access policy configured. "Allow direct access in remote sessions" setting visible. Removable storage classes listed (CD/DVD, floppy, custom, tape, WPD). This prevents data exfiltration via USB devices — a standard data loss prevention control in regulated environments.

---

## Help Desk Tasks

### 20 — Password Reset — GUI and PowerShell
![Password Reset](20-password-reset.png)

**What this proves:** Password reset performed two ways — GUI (Reset Password dialog for `bob.patel`, "User must change password at next login" checked) and PowerShell ISE (`Set-ADAccountPassword` + `Set-ADUser -ChangePasswordAtLogon $true`). Both methods confirmed working.

---

### 21 — Account Unlock
![Account Unlock](21-account-unlock.png)

**What this proves:** `Unlock-ADAccount -Identity "carol.jones"` executed successfully in PowerShell ISE. HR_Users security group visible in ADUC confirming OU structure intact.

---

### 22 — Account Disabled — david.smith
![Account Disabled](22-account-disabled.png)

**What this proves:** `Disable-ADAccount -Identity "david.smith"` executed. `Search-ADAccount -AccountDisabled` query returns `Guest`, `krbtgt`, and `david.smith` — confirming the account is disabled. Account preserved (not deleted) to maintain audit trail — correct enterprise offboarding practice.

---

### 23 — Audit Queries and Group Membership
![Audit Output](23-audit-group-membership.png)

**What this proves:** Two audit queries executed:
1. `Get-ADUser -Filter {LastLogonDate -lt $cutoff -and Enabled -eq $true}` — 90-day inactive account report
2. `Get-ADPrincipalGroupMembership -Identity "alice.chen"` — returns `Domain Users` and `IT_Admins` — confirming alice.chen's group membership is correct

This is the same query a security or compliance team would run during an access review.

---

## Summary — What This Lab Proves

| Skill demonstrated | Evidence |
|---|---|
| Azure VM provisioning | Screenshots 01–03 |
| AD DS role installation | Screenshots 04–06 |
| DC promotion — new forest | Screenshots 07–09 |
| OU design and creation | Screenshots 10–11 |
| Security group creation | Screenshot 12 |
| User account creation with group assignment | Screenshots 13–14 |
| GPO creation, linking, and configuration | Screenshots 15–19 |
| Help desk — password reset | Screenshot 20 |
| Help desk — account unlock | Screenshot 21 |
| Help desk — leaver offboarding | Screenshot 22 |
| Audit and compliance reporting | Screenshot 23 |

**Every task in the lab guide was completed, executed live, and captured in sequence.**

---

*Emmanuel Onen · Senior Systems Engineer · Kirk IT, Cayman Islands*
*Lab completed: 27 May 2026 · Platform: Azure Free Tier · Cost: $0*
