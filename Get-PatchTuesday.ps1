<#
.SYNOPSIS
  Finds the date of the second Tuesday of the current month.
.DESCRIPTION
  Patching is important, but automating updates can be difficult due to patching releases on the second Tuesday of the month.  
  The code below is an example of how to identify the date of the second Tuesday for a given month.
  It's purpose is to use in scripts to schedule maintenance windows for patching.
  The script will output the second Tuesday of the month by default.
  Optionally, you can pass in a week day and an instance count to find what date that day falls on.
.OUTPUTS
  The date of patch Tuesday.
  If given optioaly parameters, it will find the “X” instance of a day of the week.
.EXAMPLE
  Get Patch Tuesday for the month
  Get-PatchTuesday

  Is today Patch Tuesday?
  (get-date).Day -eq (Get-PatchTuesday).day

  Get 5 days after path Tuesday
  (Get-PatchTuesday).AddDays(5)

# Get the 3rd wednesday of the month
Get-PatchTuesday -weekDay Wednesday -findNthDay 3
.NOTES
  Version:        1.0
  Author:         Travis Roberts
  Creation Date:  9/8/2020
  Website         www.ciraltos.com
  Purpose/Change: Function to find the second Tuesday of the month, or the "X" instance of a weekDay in the current month.
  
  ***This script is offered as-is with no warranty, expressed or implied.  Test it before you trust it.***
#>

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Function Get-PatchTuesday {
  [CmdletBinding()]
  Param
  (
    [Parameter(position = 0)]
    [ValidateSet("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Satureday")]
    [String]$weekDay = 'Tuesday',
    [ValidateRange(0, 5)]
    [Parameter(position = 1)]
    [int]$findNthDay = 2
  )
  # Get the date and find the first day of the month
  # Find the first instance of the given weekday
  [datetime]$today = [datetime]::NOW
  $todayM = $today.Month.ToString()
  $todayY = $today.Year.ToString()
  [datetime]$strtMonth = $todayM + '/1/' + $todayY
  while ($strtMonth.DayofWeek -ine $weekDay ) { $strtMonth = $StrtMonth.AddDays(1) }
  $firstWeekDay = $strtMonth

  # Identify and calculate the day offset
  if ($findNthDay -eq 1) {
    $dayOffset = 0
  }
  else {
    $dayOffset = ($findNthDay - 1) * 7
  }
  
  # Return date of the day/instance specified
  $patchTuesday = $firstWeekDay.AddDays($dayOffset) 
  return $patchTuesday
}



