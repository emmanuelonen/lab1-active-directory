# ============================================================
# Lab 1 — Active Directory
# Script 01: Install AD DS Role and GPMC
# Emmanuel Onen | Kirk IT, Cayman Islands | May 2026
# ============================================================

# Install Active Directory Domain Services role with management tools
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Install Group Policy Management Console immediately after
# Required for Step 5 — do not skip this step
Install-WindowsFeature -Name GPMC

# Verify both features installed correctly
Get-WindowsFeature AD-Domain-Services, GPMC | Select-Object DisplayName, Installed, InstallState

Write-Host "AD DS and GPMC installed. Do NOT restart yet — promotion step comes next." -ForegroundColor Yellow
