#Instalace potřebných modulů
#Install-Module -Name AzureAD
#Install-Module MSOnline

Import-Module MSOnline
$365Logon = get-credential
$365PSSession = New-PSSession –ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $365Logon -Authentication Basic -AllowRedirection
Import-PSSession $365PSSession -AllowClobber
Set-ExecutionPolicy RemoteSigned
Connect-MsolService –Credential $365Logon

#Vypíše typy a počty licencí, které máme
Get-MsolAccountSku

# Najde uživatele s E3
Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -match "ENTERPRISEPACK"}

#Najde uživatele s Exchange online plán 1
Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -match "EXCHANGESTANDARD"}

#Najde uživatele s Office 365 proplus
Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -match "OFFICESUBSCRIPTION"}

#Najde uživatele s Office 365 proplus a Exchange online plán 1
Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -match "OFFICESUBSCRIPTION"} | Where-Object {($_.licenses).AccountSkuId -match "EXCHANGESTANDARD"}


#Odebere licence x a přidá licence Y
Set-MsolUserLicense -UserPrincipalName “lucie.procingerova@artin.cz” –AddLicenses “artin:O365_BUSINESS_PREMIUM“ –RemoveLicenses “artin:EXCHANGESTANDARD“, "artin:OFFICESUBSCRIPTION"


#Vyfiltruje podle userprincipalname
Get-MsolUser -EnabledFilter EnabledOnly -UserPrincipalName "ondrej.foldyna@artin.cz"

#Vyfiltruje podle kteréhokoli strinug
Get-MsolUser -EnabledFilter EnabledOnly -SearchString "ondrej.foldyna"

#Prohledá pouze konkrétní doménu
Get-MsolUser -DomainName "artin.cz" | Where-Object {($_.licenses).AccountSkuId -match "OFFICESUBSCRIPTION"} | Where-Object {($_.licenses).AccountSkuId -match "EXCHANGESTANDARD"}



#Vypíše do proměnné users všechny uživatele v doméně artin.cz, které mají přiřazené ty licence uvedené v podmínce where-object. Těm pak přidá licence x a odebere licence y
$users = Get-MsolUser -DomainName "artin.cz" | Where-Object {($_.licenses).AccountSkuId -match "OFFICESUBSCRIPTION"} | Where-Object {($_.licenses).AccountSkuId -match "EXCHANGESTANDARD"}
foreach ($user in $users){
    $upn = $user.UserPrincipalName
    Set-MsolUserLicense -UserPrincipalName $upn –AddLicenses “artin:O365_BUSINESS_PREMIUM“ –RemoveLicenses “artin:EXCHANGESTANDARD“, "artin:OFFICESUBSCRIPTION"}