# ============================================================
# Lab 1 — Active Directory
# Script 02: Promote Server to Domain Controller
# Emmanuel Onen | Kirk IT, Cayman Islands | May 2026
# ============================================================
# This creates the forest, the domain, and makes this server
# the authoritative DNS and identity server for lab.local.
# The server will reboot automatically when complete.
# ============================================================

Import-Module ADDSDeployment

Install-ADDSForest `
    -DomainName 'lab.local' `
    -DomainNetBiosName 'LAB' `
    -ForestMode 'WinThreshold' `
    -DomainMode 'WinThreshold' `
    -InstallDns:$true `
    -DatabasePath 'C:\Windows\NTDS' `
    -SysvolPath 'C:\Windows\SYSVOL' `
    -LogPath 'C:\Windows\NTDS' `
    -SafeModeAdministratorPassword (ConvertTo-SecureString 'YourDSRMPassword!' -AsPlainText -Force) `
    -Force:$true

# NOTE: Server reboots automatically after this command completes.
# After reboot, log in as LAB\Administrator (not just Administrator)
# The DSRM password is a SEPARATE credential from the domain Administrator password.
# Store it securely — it is required for directory recovery only.
