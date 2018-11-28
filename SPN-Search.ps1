$results = Get-ADObject -Property serviceprincipalname -Filter {serviceprincipalname -like '*'}
$spnList =
    ForEach($result in $results) {
        ForEach($SPN in $result.servicePrincipalName) {
            If ($SPN -like '*MyString*') {  #change this filter as needed
                New-Object PSObject -Property @{ Account = $result.Name; SPN = $SPN;}
            }
        }
    }
$spnList | Sort-Object SPN |Format-Table -AutoSize -Property SPN, Account
