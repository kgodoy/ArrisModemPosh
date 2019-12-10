<#
 .Synopsis
  Retrieve logs from Arris Cable Modem (tested on SB6183).

 .Description
  This module was created to retrieve logs from the Arris modem and returns a custom object.

 .Parameter Ip
  The IP address of the modem.

 .Example
   # Retrieve log for modem with IP 192.168.100.1 (default).
   Get-ArrisEventLog -Ip 192.168.100.1
#>

function Get-ArrisEventLog {
    Param(
        [string]$Ip = "192.168.100.1"
    )
    $Url = "http://$Ip/RgEventLog.asp"
    $Response = Invoke-WebRequest -Uri $Url
    $items = ($Response.Content.ToString() -split "[`r`n]") | Select-String "<td " | % { ($_ -replace "(<).*?(>)","") }
    $col = New-Object System.Collections.ArrayList
    for($i = 0; $i -le $items.Count; $i=$i+3)
    {
        if($items[$i] -ne " "){
            $obj = "" | select "time","priority","description"
            $obj.time = $items[$i]
            $obj.priority = $items[$($i+1)]
            $obj.description = $items[$($i+2)]
            $col.add($obj) | Out-Null
        }
    }
    $col
}

Export-ModuleMember -Function Get-ArrisEventLog