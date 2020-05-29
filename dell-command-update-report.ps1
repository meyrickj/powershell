
#-------------------------------
# Author Joe Meyrick

# Written 9/28/18

# Description: This will use the Dell command update utility to see if there are avaliable updates
#-------------------------------- 

#Paramater for email to so you can specift who gets the report email
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)]
  [String]$emailTo
)

$manufacturer = (Get-WmiObject -Class:Win32_ComputerSystem).Manufacturer


If (( $manufacturer -like "*Dell*") -and (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq "Dell Command | Update" } )) {

  $CurrentLocation = "C:\Program Files (x86)\Dell\CommandUpdate"
  $exe = "dcu-cli.exe"
  $Arguments = "/Silent /Report C:\Report.xml"

  #start the dell cmd update cli and wait for it to finish before moving on       
  Start-Process -FilePath "$CurrentLocation\$exe" -ArgumentList $Arguments -Wait -WindowStyle Hidden



  $strFileName="c:\Report.xml"

  If (Test-Path $strFileName){

    # File exists and the driver report xml file will be saved as a text file and emailed to the email entered in the emailTo paramater

    [xml]$XmlDocument = Get-Content -Path C:\Report.xml

    $XmlDocument.updates.update |  Out-File -filepath C:\report.txt

  

    #Will email the results of report.txt to the email specificed in the emailTo parameter
    $Subject = "$env:ComputerName.$env:USERDNSDOMAIN Dell Driver updates avaliable"
    $SMTPServer = "smtp-relay.wharton.upenn.edu"
    $EmailFrom = "MEDC-config-alert@wharton.upenn.edu"
    $readReport = Get-Content -Path C:\report.txt | Out-String 
    $zendesktags = '#tags medc-script-report, dell-command-update'
    $body =  $zendesktags + $readReport
    Send-MailMessage -To $emailTo -From $EmailFrom -Subject "$subject" -Body $body -SmtpServer $SMTPserver

    # do some cleanup to remove report files

    Remove-Item C:\Report.xml
    Remove-Item C:\report.txt

  }Else{

    # File does not exist email that the system is up to date

 

   $Subject = "$env:ComputerName.$env:USERDNSDOMAIN Dell system up to date!"
   $SMTPServer = "smtp-relay.wharton.upenn.edu"
   $EmailFrom = "MEDC-config-alert@wharton.upenn.edu"
   $body = "Your Dell system is up to date!"
   Send-MailMessage -To $emailTo -From $EmailFrom -Subject "$subject" -Body $body -SmtpServer $SMTPserver

  }  
}else{

  Write-Host "Not a Dell computer or Dell command update not installed"
}
