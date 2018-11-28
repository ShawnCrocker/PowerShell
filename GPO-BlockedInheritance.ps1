$DNSRoot = (Get-ADDomain).DNSRoot

Get-ADOrganizationalUnit -filter * -Properties canonicalName | 
    Where-Object { (Get-GPInheritance $_.DistinguishedName).GpoInheritanceBlocked -eq "Yes"} | 
        Select-Object @{n='Path';e={$_.canonicalName.Replace($DNSRoot, '')} } | Sort-Object Path
