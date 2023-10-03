$IsAdmin = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Error "This script needs to be executed with Administrator privilege!"
    exit 1
}

if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Error "This script requires PowerShell to be major version 5 or above."
    exit 1
}

# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Create .ssh directory for user account
if (-not (Test-Path -Path "$env:USERPROFILE\.ssh")) {
    New-Item -ItemType "directory" -Path "$nev:USERPORFILE\.ssh"
}
# Create authorized_keys file for user account
if (-not (Test-Path -PathType leaf -Path "$env:USERPROFILE\.ssh\authorized_keys")) {
    New-Item -ItemType "file" -Path "$env:USERPORFILE\.ssh\authorized_keys"
}

# Enable key based authorization on ssh
[string]$GlobalSSH = "$env:ProgramData\ssh\sshd_config"
(Get-Content $GlobalSSH).replace('#PubkeyAuthentication yes', 'PubkeyAuthentication yes') |
    Set-Content $GlobalSSH

# Setup authorized_keys file for Administrators for Windows
[string]$GlobalAuthorizedKeys = "$env:ProgramData\ssh\administrators_authorized_keys"
if (-not (Test-Path -PathType leaf -Path $GlobalAuthorizedKeys)) {
    New-Item -ItemType "file" -Path $GlobalAuthorizedKeys
}
# Grand permission to $GlobalAuthorizedKeys file
icacls.exe $GlobalAuthorizedKeys /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"

# Start the sshd service now
Start-Service sshd
# Start service automatically
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)'
        -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}

# Set the default shell to be PowerShell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell `
    -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" `
    -PropertyType String -Force

# Enable File and Printer Sharing on private network (for SSH connection)
Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled True -Profile Private

Write-Output "SSH Bootstrap done!"
[string]$Link = "https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement#deploying-the-public-key"
Write-Output "For deploying public keys, please look at: $Link"
