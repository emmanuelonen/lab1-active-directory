# ============================================================
# Lab 1 — Active Directory
# Verification Script — Confirm Lab State
# Emmanuel Onen | Kirk IT, Cayman Islands | May 2026
# ============================================================
# Run this after completing all lab steps.
# Every check should return the expected result.
# If any check fails, refer to the troubleshooting section in README.md
# ============================================================

Write-Host "`n=== LAB 1 VERIFICATION ===" -ForegroundColor Cyan
Write-Host "Running all checks against lab.local`n"

# CHECK 1 — Domain Controller is running
Write-Host "CHECK 1: Domain Controller" -ForegroundColor Yellow
Get-ADDomainController | Select-Object Name, IPv4Address, Site, IsGlobalCatalog, OperatingSystem
# Expected: Returns DC01 with forest lab.local

# CHECK 2 — All OUs exist
Write-Host "`nCHECK 2: Organisational Units" -ForegroundColor Yellow
Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName
# Expected: Lists IT, Finance, HR, Sales, Computers OUs

# CHECK 3 — All users exist and are enabled
Write-Host "`nCHECK 3: User accounts (enabled)" -ForegroundColor Yellow
Get-ADUser -Filter {Enabled -eq $true} | Select-Object Name, SamAccountName, Enabled
# Expected: alice.chen, bob.patel, carol.jones (david.smith should be disabled)

# CHECK 4 — Group memberships correct
Write-Host "`nCHECK 4: IT_Admins group membership" -ForegroundColor Yellow
Get-ADGroupMember -Identity "IT_Admins" | Select-Object Name, SamAccountName
# Expected: alice.chen

Write-Host "`nCHECK 4b: Finance_Users group membership" -ForegroundColor Yellow
Get-ADGroupMember -Identity "Finance_Users" | Select-Object Name, SamAccountName
# Expected: bob.patel

# CHECK 5 — GPO is linked to IT OU
Write-Host "`nCHECK 5: GPO inheritance on IT OU" -ForegroundColor Yellow
Get-GPInheritance -Target 'OU=IT,DC=lab,DC=local' | Select-Object -ExpandProperty GpoLinks
# Expected: Shows IT Security Policy as linked

# CHECK 6 — FSMO roles (all on DC01 for single-DC lab)
Write-Host "`nCHECK 6: FSMO role holders" -ForegroundColor Yellow
netdom query fsmo
# Expected: All 5 roles held by DC01.lab.local

Write-Host "`n=== VERIFICATION COMPLETE ===" -ForegroundColor Cyan
Write-Host "If all checks passed — Lab 1 is complete and working.`n" -ForegroundColor Green
