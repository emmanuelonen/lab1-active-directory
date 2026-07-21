# ============================================================
# Lab 1 — Active Directory
# Script 03: Create OUs, Security Groups, and Users
# Emmanuel Onen | Kirk IT, Cayman Islands | May 2026
# ============================================================

# --- ORGANISATIONAL UNITS ---
# OUs are containers for applying Group Policy and delegating admin control.
# ProtectedFromAccidentalDeletion prevents a misplaced Remove command
# from wiping the OU and everything inside it.

New-ADOrganizationalUnit -Name "IT"        -Path "DC=lab,DC=local" -ProtectedFromAccidentalDeletion $true
New-ADOrganizationalUnit -Name "Finance"   -Path "DC=lab,DC=local" -ProtectedFromAccidentalDeletion $true
New-ADOrganizationalUnit -Name "HR"        -Path "DC=lab,DC=local" -ProtectedFromAccidentalDeletion $true
New-ADOrganizationalUnit -Name "Sales"     -Path "DC=lab,DC=local" -ProtectedFromAccidentalDeletion $true
New-ADOrganizationalUnit -Name "Computers" -Path "DC=lab,DC=local" -ProtectedFromAccidentalDeletion $true

Write-Host "OUs created." -ForegroundColor Green


# --- SECURITY GROUPS ---
# Global scope — contains users from this domain.
# Security category — used for access control, not email distribution.
# AGDLP principle: Accounts → Global groups → Domain Local groups → Permissions

New-ADGroup -Name "IT_Admins"     -GroupScope Global -GroupCategory Security -Path "OU=IT,DC=lab,DC=local"
New-ADGroup -Name "Finance_Users" -GroupScope Global -GroupCategory Security -Path "OU=Finance,DC=lab,DC=local"
New-ADGroup -Name "HR_Users"      -GroupScope Global -GroupCategory Security -Path "OU=HR,DC=lab,DC=local"
New-ADGroup -Name "Sales_Users"   -GroupScope Global -GroupCategory Security -Path "OU=Sales,DC=lab,DC=local"

Write-Host "Security groups created." -ForegroundColor Green


# --- USER ACCOUNTS ---
# IMPORTANT: Run this entire block together — not line by line.
# The $password variable must be defined before New-ADUser commands run.
# Using PowerShell ISE: select all, press F8 to run the full block.

# Step 1 — define password variable first
$password = ConvertTo-SecureString "Welcome@2026!" -AsPlainText -Force

# Step 2 — create users in their correct OUs
New-ADUser -Name "alice.chen"  -GivenName "Alice" -Surname "Chen"  `
    -SamAccountName "alice.chen"  -UserPrincipalName "alice.chen@lab.local"  `
    -Path "OU=IT,DC=lab,DC=local"      -AccountPassword $password -Enabled $true

New-ADUser -Name "bob.patel"   -GivenName "Bob"   -Surname "Patel" `
    -SamAccountName "bob.patel"   -UserPrincipalName "bob.patel@lab.local"   `
    -Path "OU=Finance,DC=lab,DC=local" -AccountPassword $password -Enabled $true

New-ADUser -Name "carol.jones" -GivenName "Carol" -Surname "Jones" `
    -SamAccountName "carol.jones" -UserPrincipalName "carol.jones@lab.local" `
    -Path "OU=HR,DC=lab,DC=local"      -AccountPassword $password -Enabled $true

New-ADUser -Name "david.smith" -GivenName "David" -Surname "Smith" `
    -SamAccountName "david.smith" -UserPrincipalName "david.smith@lab.local" `
    -Path "OU=Sales,DC=lab,DC=local"   -AccountPassword $password -Enabled $true

Write-Host "User accounts created." -ForegroundColor Green

# Step 3 — assign users to their department security groups
Add-ADGroupMember -Identity "IT_Admins"     -Members "alice.chen"
Add-ADGroupMember -Identity "Finance_Users" -Members "bob.patel"
Add-ADGroupMember -Identity "HR_Users"      -Members "carol.jones"
Add-ADGroupMember -Identity "Sales_Users"   -Members "david.smith"

Write-Host "Users assigned to groups." -ForegroundColor Green
Write-Host "OU, group, and user creation complete." -ForegroundColor Cyan
