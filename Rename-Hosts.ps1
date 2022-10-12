param (
    [Parameter(Mandatory=$true)][string]$company,
    [Parameter(Mandatory=$true)][string]$user,
    [Parameter(Mandatory=$true)][string]$passwd
)

$PSDefaultParameterValues['*:Encoding'] = 'utf8'

Sync-DnsServerZone
Clear-DnsClientCache

$var = $true
$i = 1
$num = 0
$initials = "$company*"

$secstr = New-Object -TypeName System.Security.SecureString
$passwd.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user, $secstr


Get-ADComputer -filter {Name -notlike $initials -and Name -notlike '*PROBE' -and OperatingSystem -notlike '*Server*'} -property * | Select-Object name > C:\tmp1.csv
(Get-Content C:\tmp1.csv).replace('----', '') | Set-Content C:\tmp1.csv
(Get-Content C:\tmp1.csv).Trim() | Where-Object {$_.Length -gt 0} | Set-Content C:\tmp1.csv

$computers = import-csv -Path "C:\tmp1.csv"

while ($var) {

  foreach ($name in $computers) {

    $com = $computers[$num].'name'

    if ($i -le 99) {
        $newarray = $i.ToString("000") 
    }
    else { $newarray = $i }

    $hostname = "$company-$newarray"
    if ($i -le 999)
    {
        if (Get-ADComputer -Filter {name -eq $hostname}) {
            $i = $i + 1
            continue
        }
        else {
            if ($com -ne $hostname) {
             Write-Host "$com to $hostname" 
             $ErrorOccured=$false
             try { 
                $ErrorActionPreference = 'Stop'
                Rename-Computer -ComputerName $com -NewName $hostname  -DomainCredential $cred -Restart -Force
                Write-Host "Succes"
            }
             catch { 
                "Error"
                $ErrorOccured=$true
             }
             if (!$ErrorOccured) {$i = $i + 1}
             $num = $num + 1
            }
            $var = $false
        } 
    }
    else {
        Write-Host "Too many hosts! Contact Administrator"
        $var = $false
    }

   }

}

Remove-Item C:\tmp1.csv