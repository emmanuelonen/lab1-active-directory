# Lab 1 — Active Directory
### Windows Server 2025 · Azure Free Tier · Identity & Access Management

| Field | Value |
|---|---|
| **Completed** | 27 May 2026 |
| **Platform** | Azure VM — Windows Server 2025 Datacenter Gen2 |
| **Cost** | $0 — Azure free tier + 180-day evaluation licence |
| **Time taken** | 3–5 hours across multiple sessions |
| **Cert alignment** | CompTIA Network+ · Security+ · AZ-104 Azure Administrator |

---

## The Business Problem This Lab Solves

Every organisation running Windows infrastructure relies on Active Directory to answer one fundamental question: **who is allowed to do what?**

Active Directory is the identity backbone. It controls which users can log into which computers, which groups can access which file shares, and which policies apply to which departments. When a new employee joins, IT creates their account and adds them to the right groups — access to email, shared drives, and applications is granted automatically. When they leave, IT disables one account and every door closes simultaneously.

This is not legacy technology. Hybrid environments sync on-premises Active Directory to Microsoft Entra ID (formerly Azure AD) in the cloud. The concepts built here — users, groups, OUs, GPOs — map directly to Entra ID, Conditional Access, and Azure RBAC. This lab is the foundation of every cloud identity conversation.

**Scenario used in this lab:** Greenfield Active Directory deployment for a 4-department organisation (IT, Finance, HR, Sales) — the same structure an engineer would build for a 200-user SMB or as the on-premises component of a hybrid cloud environment.

---

## What Was Built

- ✅ Azure VM provisioned (Standard_B2s, Windows Server 2025 Datacenter Gen2, East US)
- ✅ Connected via RDP file download — clipboard enabled for command paste
- ✅ AD DS role installed via PowerShell
- ✅ GPMC installed alongside AD DS
- ✅ Server promoted to Domain Controller — forest `lab.local` created
- ✅ DSRM password set and recorded securely
- ✅ 5 Organisational Units created (IT, Finance, HR, Sales, Computers)
- ✅ 4 Security Groups created with correct scope and category
- ✅ 4 User accounts created and assigned to department groups
- ✅ Group Policy Object configured — password policy, screen lock, USB restriction
- ✅ Help desk tasks executed — password reset, account unlock, account disable, audit queries

---

## Architecture

```
Forest: lab.local
│
└── Domain: lab.local (DC01 — PDC Emulator, RID Master, Schema Master)
    │
    ├── OU: IT
    │   ├── Security Group: IT_Admins
    │   ├── User: alice.chen
    │   └── GPO: IT Security Policy (linked)
    │
    ├── OU: Finance
    │   ├── Security Group: Finance_Users
    │   └── User: bob.patel
    │
    ├── OU: HR
    │   ├── Security Group: HR_Users
    │   └── User: carol.jones
    │
    ├── OU: Sales
    │   ├── Security Group: Sales_Users
    │   └── User: david.smith
    │
    └── OU: Computers
        └── (Domain-joined workstations land here)
```

---

## GPO — IT Security Policy Settings

| Policy Path | Setting | Value | Reason |
|---|---|---|---|
| Computer Config → Security → Password Policy | Minimum password length | 12 characters | Enforces strong passwords across all IT accounts |
| Computer Config → Security → Password Policy | Complexity requirements | Enabled | Requires upper, lower, number, symbol |
| Computer Config → Security Options | Machine inactivity limit | 900 seconds (15 min) | Auto-locks screen — compliance requirement |
| Computer Config → Removable Storage Access | All removable storage classes | Deny all access | Prevents data exfiltration via USB |

---

## Key Decisions Made

**Why PowerShell ISE over a regular PowerShell window?**
PowerShell ISE allows you to see, read, and review the full script before executing it. For multi-line blocks like the user creation script — where the `$password` variable must be defined before the `New-ADUser` commands — ISE makes it easier to select and run the entire block together without accidental line-by-line execution that causes failures.

**Why run the user creation script as a single block?**
The `$password` variable must be defined in the same execution context as the `New-ADUser` commands. Running line-by-line causes PowerShell to prompt interactively for the `-Name` parameter because the variable is out of scope. This is a real-world scripting discipline — understanding execution context, not just copying commands.

**Why disable accounts instead of deleting leavers?**
Disabling preserves the account object, group memberships, and audit history. In regulated environments (financial services, healthcare, government) this is a compliance requirement — you need to be able to demonstrate who had access to what system and when. Deletion is permanent and destroys the audit trail. The correct offboarding process is: disable the account, move it to a Disabled-Users OU, strip group memberships, retain for 30–90 days before deletion.

**Why set DNS to 127.0.0.1 before promotion?**
During DC promotion, the AD DS installer creates the DNS zone for `lab.local` locally on this server. Pointing DNS at loopback (127.0.0.1) ensures the server resolves its own domain correctly immediately after promotion without depending on an external DNS server that knows nothing about `lab.local`.

---

## Files in This Repository

| File | Contents |
|---|---|
| `scripts/01-install-adds.ps1` | Install AD DS role and GPMC |
| `scripts/02-promote-dc.ps1` | Promote server to Domain Controller |
| `scripts/03-create-ous.ps1` | Create all 5 Organisational Units |
| `scripts/04-create-groups.ps1` | Create all 4 Security Groups |
| `scripts/05-create-users.ps1` | Create users and assign to groups |
| `scripts/06-helpdesk-tasks.ps1` | Password reset, unlock, disable, audit |
| `verification/verify-lab.ps1` | Verification commands to confirm lab state |
| `docs/DECISIONS.md` | Architecture decisions and reasoning |

---

## Certification Mapping

| Lab skill | Exam objective |
|---|---|
| DC promotion, forest creation | AZ-104: Deploy and manage Azure compute — maps to Entra ID tenant creation |
| OU design and GPO deployment | CompTIA Security+: Identity and access management |
| Security groups and RBAC | AZ-104: Manage Azure identities and governance |
| Help desk tasks — disable/audit | CompTIA Network+: Network operations |
| PowerShell automation | AZ-104: Automate deployment and configuration of resources |

---

## Cloud Relevance — On-Prem to Azure Mapping

| This lab | Azure / Entra ID equivalent |
|---|---|
| Active Directory Domain | Entra ID Tenant |
| Organisational Unit (OU) | Administrative Unit |
| Security Group | Entra ID Security Group / Azure AD Group |
| Group Policy Object (GPO) | Microsoft Intune Policy / Conditional Access Policy |
| Domain join | Entra ID Join / Hybrid Azure AD Join |
| DSRM password | Break-glass emergency access account |
| `gpupdate /force` | Intune policy sync trigger |

---

*Part of a structured cloud engineering learning path — AZ-900 → AZ-104 → AI-102 → AZ-400*
*Emmanuel Onen · Senior Systems Engineer · Kirk IT, Cayman Islands*
