
#-------------------------------- 
# Author Joe Meyrick

# Written 9/28/18

# Desctiption: Run the Dell command update utility to update all drivers and BIOS firmware 

# Start the dell command update CLI with the silent switch and log all results 
#-------------------------------- 

#---------------------------
#Return Codes:         
# 0 = OK/Success       
# 1 = Reboot required  
# 2 = Fatal Error      
# 3 = Error          
# 4 = Invalid System   
# 5 = Reboot &Scan required
#----------------------------


$manufacturer = (Get-WmiObject -Class:Win32_ComputerSystem).Manufacturer


If (( $manufacturer -like "*Dell*") -and (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq "Dell Command | Update" } )) {

  $CurrentLocation = "C:\Program Files (x86)\Dell\CommandUpdate"
  $exe = "dcu-cli.exe"
  $Arguments = "/Silent /log C:/dell_cmdUpadateLogs"

  #start the dell cmd update cli and wait for it to finish before moving on    
  Start-Process -FilePath "$CurrentLocation\$exe" -ArgumentList $Arguments -Wait -WindowStyle Hidden
  
  [xml]$XmlDocument = Get-Content -Path C:\dell_cmdUpadateLogs\ActivityLog.xml

  $XmlDocument.LogEntries.LogEntry 
 

}else{

  Write-Host "Not Dell computer or Dell command update not installed"

}
