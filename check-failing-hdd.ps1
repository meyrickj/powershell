
 #-------------------------------
# Author Joe Meyrick

# Written 6/17/2020

# Description: Get Hardrive Status that isn't marked as ok, if OK isn't in the status it will send an email report to the designated email
# Potential values: $values = 'Degraded','Error','Lost Comm','No Contact','NonRecover','OK','Pred Fail','Service','Starting','Stopping','Stressed','Unknown'
#-------------------------------- 




#Paramater for email to so you can specift who gets the report email
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)] [String]$emailTo

)

if ( Get-CimInstance -ClassName Win32_DiskDrive | Select-Object -Property Caption, Status | where-object {$_.Status -ne "OK"}  ) {

    #Will email the results of report.txt to the email specificed in the emailTo parameter
    $Subject = "Poteltial Harddrive Failure $env:ComputerName.$env:USERDNSDOMAIN "
    $SMTPServer = "smtp-relay.wharton.upenn.edu"
    $EmailFrom = "$env:ComputerName@wharton.upenn.edu"
    $resuts =  Get-CimInstance -ClassName Win32_DiskDrive | Select-Object -Property Caption, Status | where-object {$_.Status -ne "OK"} |  Out-File -filepath C:\hdd-status.txt
    $body =  Get-Content -Path C:\hdd-status.txt | Out-String 
    Send-MailMessage -To $emailTo -From $EmailFrom -Subject "$subject" -Body $body -SmtpServer $SMTPserver

    #clean up old results
    Remove-Item C:\hdd-status.txt

} else {
    Write-Host 'nothing found'
} 
