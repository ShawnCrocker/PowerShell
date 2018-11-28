$DNSRoot = (Get-ADDomain).DNSRoot

#List of OUs. We'll use canonicalName to show path not DistinguishedName
$OUs = Get-ADOrganizationalUnit -filter * -Properties canonicalName

#Check linked GPO that we can't read. Reliable
$OULinksNoRead = $OUs | foreach { (Get-GPInheritance -Target $_.DistinguishedName).GPOlinks }
foreach ($OULinkNoRead in $OULinksNoRead) {
    If (!$OULinkNoRead.Displayname -or $OULinkNoRead.Displayname -eq '') {
       Write-Output $OULinkNoRead.GpoId $OULinkNoRead.Target
    }
}

#Check all GPOs on SYSVOL. Not sure how reliable
$SysVolPath = '\\' + $DNSRoot + '\sysvol\' + $DNSRoot + '\Policies'
$DummyResult = Get-ChildItem -Path $SysVolPath -Recurse -ErrorAction SilentlyContinue -ErrorVariable SysVolEnumnerationError
Write-Output $SysVolEnumnerationError.TargetObject
