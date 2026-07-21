# ============================================================
# Lab 1 — Active Directory
# Script 06: Common Help Desk Tasks
# Emmanuel Onen | Kirk IT, Cayman Islands | May 2026
# ============================================================
# These are the top ticket types in any enterprise IT environment.
# Every command here maps to a real-world support scenario.
# ============================================================

# --- RESET A PASSWORD ---
# Most common help desk ticket.
# Always force change at next logon — user sets their own password immediately.
# Never give users a password that IT knows permanently.

Set-ADAccountPassword -Identity "bob.patel" `
    -Reset `
    -NewPassword (ConvertTo-SecureString "NewPass@2026!" -AsPlainText -Force)

Set-ADUser -Identity "bob.patel" -ChangePasswordAtLogon $true

Write-Host "Password reset for bob.patel — change required at next logon" -ForegroundColor Green


# --- UNLOCK A LOCKED ACCOUNT ---
# Accounts lock after too many failed login attempts (defined in Default Domain Policy).
# This is one of the most frequent help desk calls in any organisation.

Unlock-ADAccount -Identity "carol.jones"

Write-Host "Account unlocked: carol.jones" -ForegroundColor Green


# --- DISABLE A LEAVER ACCOUNT ---
# When someone leaves, DISABLE — never delete immediately.
# Disabling preserves the audit trail and group membership history.
# Required for compliance in regulated environments (finance, healthcare, government).

Disable-ADAccount -Identity "david.smith"

Write-Host "Account disabled: david.smith" -ForegroundColor Yellow

# Find all currently disabled accounts
Search-ADAccount -AccountDisabled | Select-Object Name, SamAccountName


# --- AUDIT: ACCOUNTS NOT LOGGED IN FOR 90 DAYS ---
# Compliance and security teams require regular reviews of inactive accounts.
# Inactive accounts are a security risk — potential for undetected misuse.

$cutoff = (Get-Date).AddDays(-90)

Get-ADUser -Filter {LastLogonDate -lt $cutoff -and Enabled -eq $true} `
    -Properties LastLogonDate |
    Select-Object Name, SamAccountName, LastLogonDate |
    Sort-Object LastLogonDate


# --- AUDIT: CHECK GROUP MEMBERSHIP FOR A USER ---
# Verify what access a user currently has — essential before offboarding
# or when investigating a security incident.

Get-ADPrincipalGroupMembership -Identity "alice.chen" |
    Select-Object Name, GroupScope, GroupCategory |
    Sort-Object Name

Write-Host "`nHelp desk task script complete." -ForegroundColor Cyan
