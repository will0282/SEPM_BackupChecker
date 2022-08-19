<#
.SYNOPSIS
  Checks the Symantec Endpoint Protection Manager (SEPM) Backup.  
.DESCRIPTION
  The script check if a Backup file has been created in the proper location and sends an email with details of the file and location.
  This is to validates if it backup or not, and if so then investigate on the server why the backup failed to be created.
.PREQUIREMENTS
  WinRM must be enabled and accessible only if remote. 
.PARAMETER 
  None
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         William Aycardi
  Creation Date:  12-30-2021
  Purpose/Change: Checks local backup of the DB of SEPM.
  
.EXAMPLE
  None
#>

#-----------------------------------------------------------[Initiation]------------------------------------------------------------
# Variables declaration
$Date = (Get-Date -UFormat "%m/%d/%Y %r %A")
$Results = ((Get-ChildItem -Path "D:\Program Files (x86)\data\backup") | Select-Object -Last 1)
$Results_000 = (Get-ChildItem -Path "D:\Program Files (x86)\data\backup")
$ParentFolder = ((Get-Item -Path "D:\Program Files (x86)\data\backup").LastWriteTime)
$FileCount = ($Results_000.Count)
$FileLastWriteTime = ($Results.LastWriteTime)
$FileName = ($Results.Name)

#Creates a new Mail Message Object. This is the object needed for the addressing email, subject, body, etc
$MailSubject= "SEPM [XXxxXXxxXX] - Schedule Database Checker"

$MailBody = @"
Script ran at: 
$Date

============================
Symantec Endpoint Protection Manager - Schedule Database Checker

============================
Server: XXxxXXxxXX || Backup Frequency: Weekly || Day of the week: Monday || Start Time: 0300 || Time Zone: EST

============================
Parent Folder Location:
D:\Program Files (x86)\data\backup

Parent Folder LastWriteTime:
$ParentFolder

Total File Count within Parent Folder (Should always be 3):
$FileCount

============================
File LastWriteTime Date: 
$FileLastWriteTime

File Name: 
$FileName

============================
"@

$SmtpClient = New-Object system.net.mail.smtpClient($SMTPServer, 25)
$SmtpClient.host = "xx.XX.XX.xx" 
$MailMessage = New-Object system.net.mail.mailmessage 
$MailMessage.from = "XXXXX_@xxxxx.com"
$MailMessage.To.add("YxYxYxYxYxYx@YxYxYxYx.com") 

$MailMessage.Subject = $MailSubject 

$MailMessage.Body = $MailBody

#-----------------------------------------------------------[Execution]------------------------------------------------------------
# Sends the E-mail Message
$SmtpClient.Send($MailMessage) 
#========================================================================
##############
#END OF SCRIPT
