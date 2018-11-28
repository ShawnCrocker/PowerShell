$DNSRoot = (Get-ADDomain).DNSRoot

$OUs = Get-ADOrganizationalUnit -Filter * -Properties canonicalName, GPLink

$DisabledLinks = Foreach ($OU in $OUs) {
    If ($OU.GPLink)  {
        $GPLinks = $OU.GPLink.Split('[')
        Foreach ($GPLink in $GPLinks) {
            $GPLink = $GPLink.split(";")
            If ($GPLink[1]) {
                $GPGuid = $GPLink[0].Replace('},cn=policies,cn=system,'+$DomainDN, '').Replace('LDAP://cn={', '')
                $GPDisabled = $GPLink[1].Replace(']', '')
                If ($GPDisabled -eq '1') {
                    New-Object PSObject -Property @{
                        Path = $OU.canonicalName.Replace($DNSRoot, '');
                        GPOName = (Get-GPO -Guid $GPGuid).DisplayName;
                    }
                }
            }
        }
    }
}
$DisabledLinks | Sort-Object Path, GPOName
