param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Output "===Stuttgart-Things Vault CA installer for windows 10 --- version: 0.3==="
Write-Output ""
$promt = Read-Host -Prompt 'Please make sure before execution, that powershell scripts are allowed on your system - you can allow ps1 with the powershell command "Set-ExecutionPolicy RemoteSigned" and then press "A" - press <enter> to continue ...'
$Server = Read-Host -Prompt 'Please enter the vault-server URL like: "https://vault.example.com:8200" ->'
$Ca_name = Read-Host -Prompt 'Please enter the vault ca name default "pki" if you dont know the ca-name please write "pki" ->'
Write-Output ""
Write-Output "Ok, downloading certificate from:" ($Server + '/v1/' + $Ca_name + '/ca')
Invoke-WebRequest -Uri ($Server + '/v1/' + $Ca_name + '/ca') -OutFile 'ca.cer'
Write-Output ""
Write-Output "Download success"
Import-Certificate -FilePath "ca.cer" -CertStoreLocation 'Cert:\LocalMachine\Root' -Verbose
Remove-Item 'ca.cer'
Write-Output ""
Write-Output "ca file removed from fs, CA certificate installed!"
Start-Sleep -s 3