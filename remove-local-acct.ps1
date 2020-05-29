
﻿
#-------------------------------
# Author Joe Meyrick

# Written 3/20/19

# Description: This looks to see if a local admin account exists then removes it and removes the user profile
#-------------------------------- 

#Paramater to specify local admin account/profile you want to remove
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)]
  [String]$localacct
)

if (Get-LocalUser | Where-Object {$_.Name -eq "$localacct"}){

    Remove-LocalUser -Name "$localacct"
    write-host "removed local account from $env:COMPUTERNAME" -ForegroundColor Green

    $localProfilePath = "C:\\Users\\$localacct"
    $WMIQuery = "SELECT * FROM Win32_UserProfile WHERE localpath = '$localProfilePath'"
    $profile = Get-WmiObject -Query $WMIQuery 
    Remove-WmiObject -InputObject $profile  
    Write-host "removed $localacct user profile from $env:COMPUTERNAME" -ForegroundColor Green 

}
else {


write-host "$localacct account does not exist" -ForegroundColor Green

}
