#--------------------
#
# Copyright 2014 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the “License”). You may not use this file except in compliance with the License. A copy of the License is located at
#
# http://aws.amazon.com/asl/
#
# This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
#
#--------------------

<#
.SYNOPSIS
	Version 1.0
	
  Script will indicate if the instance has been impacted by the Plug and Play Cleanup scheduled task.

  Script will attempt to disable the Plug and Play Cleanup scheduled task.

  Script will insert registry changes so the instance can load drivers on reboot.
	
	Results will be logged to the current directory with the same name as the script with .log appended'

.DESCRIPTION
	*Log results will be overwritten each time the script is executed
	
	To determine SUCCESS or FAILURE of execution:
		1) View the log file (output to execution directory with same name as 'script.log'			
			  Can Parse the completed log -- if "ERROR" is found at any point, SCRIPT failed.
		
.EXAMPLE

	For running instances, execute the following line as administrator:
	    
	powershell -noprofile -executionpolicy unrestricted -file C:\RemediateDriverIssue.ps1

.PARAMETER disableAutoRepair
  Boolean to disable automatically attempting to repair the instance.  Defaults to false.

.PARAMETER force
  Boolean to force importing registry keys.  Defaults to false.

.PARAMETER loggingEnabled
  Boolean to specify if logging is enabled.  Defaults to true.

.PARAMETER logPath
	Specify a path for the logfile.  For instance: c:\RemediateDriverIssue.log

  This will default to the same directory as the script execution location.

#>

Param(
  [parameter(mandatory=$false)]
  [System.Boolean]
  $disableAutoRepair = $false,
  
  [parameter(mandatory=$false)]
  [System.Boolean]
  $force = $false,
  
  [parameter(mandatory=$false)]
  [System.Boolean]
  $loggingEnabled = $true,
  
  [parameter(mandatory=$false)]
  [System.String]
  $logPath
)

#region Variables

$scheduledTaskName = 'Plug and Play Cleanup'
$rootKey = 'HKLM:\SYSTEM\CurrentControlSet\Enum\PCI\VEN_5853&DEV_0001&SUBSYS_00015853&REV_01'
$Global:CommandDefinition = $MyInvocation.MyCommand.Definition
$Global:Command = $MyInvocation.MyCommand

#endregion

#region Log Messages

$impactedMessage = 'WARNING : This machine is found to be impacted.'
$unimpactedMessage = 'INFO : This machine was found to be in a non-impacted state.'
$repairMessage = 'INFO : Executing the repair executable.  System will reboot multiple times.'
$runAsAdminMessage = 'ERROR : This script must be run as administrator.  Please run this script with elevated privileges.'
$windowsVersionMessage = 'ERROR : This script is only valid for Windows Server 2012 R2.  Other Windows versions are not impacted.'
$taskDisabledMessage = "INFO : We have disabled the $scheduledTaskName scheduled task, please do not re-enable this scheduled task."
$taskDisableFailedMessage = "ERROR : Failed to disable the $scheduledTaskName scheduled task."
$taskAlreadyDisabledMessage = "INFO : Scheduled task $scheduledTaskName is already disabled."
$failedRepairMessage = 'ERROR : The attempted repair operation has failed.  This instance remains fully impacted.  Please DO NOT reboot this instance.'
$successfulRepairMessage='INFO : The attempted repair operation has succeeded, however the instance is still partially impacted.  It should now be safe to perform a system reboot of your instance as needed but please DO NOT use AWS functions to stop and then start, or resize this instance as it may become inaccessible. For further information and ongoing updates visit http://aws.amazon.com/windows/2012r2-network-drivers/'

#endregion

#region Functions

function Get-RegistryKeyChildren
{
  param
  (
    [parameter(mandatory=$true)]
    [System.String]
    $path
  )
  
  return (Get-ChildItem $path)
}

function Set-RegistryProperty
{
  param
  (
    [parameter(mandatory=$true)]
    [System.String]
    $path,
    
    [parameter(mandatory=$true)]
    [System.String]
    $name,
    
    [parameter(mandatory=$true)]
    [System.String]
    $value
  )
  
  Set-ItemProperty -path $path -name $name -value $value
}

function Confirm-IsWindows2012R2
{   
  $osVersion = [Environment]::OSVersion.Version
  $isWindowsServer2012R2 =  (($osVersion.Major -eq 6) -and ($osVersion.Minor -eq 3))
  
  if(-not $isWindowsServer2012R2)
  {
    Write-Log -foregroundColor 'Red' $windowsVersionMessage
  }
  
  return $isWindowsServer2012R2
}

function Write-Log
{	
  param
  (
    [parameter(mandatory=$false)]
    [System.String]
    $message,
    
    [parameter(mandatory=$false)]
    [System.String]
    $foregroundColor
  )
  
  $date = get-date -format 'yyyyMMdd_hhmm:sszz'  
  
  if($foregroundColor)
  {
    Write-Host -ForegroundColor $foregroundColor "$date $message"
  }
  else
  {
    Write-Host "$date $message"
  }
  if($loggingEnabled)
  {
    Out-File -InputObject "$date $message" -FilePath $Global:LoggingFile -Append
  }
}

function Get-Instanceimpacted
{
  $childCount = Get-RegistryKeyChildren $rootKey
  
  $amazonDevices = Get-WmiObject Win32_PNPSignedDriver -filter "DeviceClass = 'SCSIAdapter'" | Where-Object {$_.Manufacturer -like '*AMAZON*'}
  
  if(($childCount.Count -le 1 -or $amazonDevices.Count -eq 0))
  {
    Write-Log $impactedMessage 'Red'
    return $true
  }
  else
  {
    Write-Log $unimpactedMessage 'Green'
    return $false
  }
}

function Disable-CleanupTask
{
  if((Get-ScheduledTask $scheduledTaskName).State -notlike 'Disabled')
  {
    Write-Log  "INFO : Disabling scheduled task $scheduledTaskName."
    
    Get-ScheduledTask $scheduledTaskName | Disable-ScheduledTask | Out-Null
    
    if((Get-ScheduledTask $scheduledTaskName).State -notlike 'Disabled')
    {
      Write-Log -foregroundColor 'Red' $taskDisableFailedMessage
      
      return $false
    }
    else
    {
      Write-Log $taskDisabledMessage
    }
  }
  else
  {
    Write-Log $taskAlreadyDisabledMessage
  }
  
  return $true
}

function Set-LogPath
{
  param
  (
    [parameter(mandatory=$false)]
    [System.String]
    $path
  )
  
  if($loggingEnabled)
  {
    if(($path).Length -gt 0)
    {
      $Global:LoggingFile = $path
    }
    else
    {
      $Global:LoggingFile = "$(Split-Path -parent $Global:CommandDefinition)\$(([string]$Global:Command).TrimEnd('.ps1')).log"
    }
  }
}

function Repair-AWSInstance
{
  try
  {
    Set-RegistryProperty 'hklm:\\System\CurrentControlSet\Services\Xenbus' 'Count' 1
    Set-RegistryProperty 'hklm:\\System\CurrentControlSet\Services\XENBUS\Parameters' 'ActiveDevice' 'PCI\VEN_5853&DEV_0001&SUBSYS_00015853&REV_01'
    Set-RegistryProperty 'hklm:\\System\CurrentControlSet\Control\Class\{4d36e97d-e325-11ce-bfc1-08002be10318}' 'UpperFilters' 'XENFILT'
    Set-RegistryProperty 'hklm:\\System\CurrentControlSet\Control\Class\{4d36e96a-e325-11ce-bfc1-08002be10318}' 'UpperFilters'  'XENFILT'
  }
  catch
  {
    Write-Log -foregroundColor 'Red' $failedRepairMessage
    return
  }
  
  Write-Log -foregroundColor 'Yellow' $successfulRepairMessage
}

function Confirm-DriveFreeSpace
{
  $enoughSpace = ((Get-WMIObject Win32_LogicalDisk | Where-Object {$_.DeviceId -like 'C:'}  | Select-Object freespace).freespace / 1mb) -gt $mbFreeSpaceRequirement
  
  if(-not $enoughSpace)
  {
    Write-Log -foregroundColor 'Red' $notEnoughSpaceMessage
  }
  
  return $enoughSpace
}

function Confirm-RunningAsAdmin
{
  $runningAsAdmin = (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))
  
  if(-not $runningAsAdmin)
  {
    Write-Log -foregroundColor 'Red' $runAsAdminMessage
  }
  
  return $runningAsAdmin
}

#endregion

#region Main Script

if(Confirm-IsWindows2012R2 -and Confirm-RunningAsAdmin)
{
  Set-LogPath $logPath
  $disabledTask = Disable-CleanupTask
  $instanceimpacted = Get-Instanceimpacted
  $enoughFreeSpace = Confirm-DriveFreeSpace
  
  if(($disabledTask -and $instanceimpacted -and (-not $disableAutoRepair)) -or ($force))
  {
    Repair-AWSInstance
  }
}

#endregion