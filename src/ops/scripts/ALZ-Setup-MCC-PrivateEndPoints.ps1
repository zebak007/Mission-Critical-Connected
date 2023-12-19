#
#
#
# connect-AzAccount -Tenant lde.bezencon.net -Subscription LDE-DEV-LZ04

$SourceSub = "LDE-DEV-LZ04"
$SourceRG = @("ldee2efad5-stamp-uksouth-rg", "ldee2efad5-stamp-northeurope-rg") 
$TargetSub = "LDE-DEV-Connectivity"
$TagetRG = "rg-pe"
$ALZLocation = "northeurope"

Set-AzContext -Subscription $SourceSub

$PEs = @()
foreach ($rg in $SourceRg)
{
  $PEs += Get-AzPrivateEndpoint -ResourceGroupName $rg
}

<#
foreach ($PE in $PEs) {
  Write-Host("$($PE.Name) - $($PE.PrivateLinkServiceConnections.Name)")
}

$PLS = New-AzPrivateLinkServiceConnection `
    -Name ($PEs[0].PrivateLinkServiceConnections.Name) `
    -PrivateLinkServiceId $PEs[0].PrivateLinkServiceConnections.PrivateLinkServiceId `
    -GroupId ($PEs[0].PrivateLinkServiceConnections.GroupIds) `
#>

Set-AzContext -Subscription $TargetSub
$vnet = Get-AzVirtualNetwork -Name "dev-hub-northeurope" -ResourceGroupName "dev-connectivity-northeurope"
$subnet = $vnet | Select-Object -ExpandProperty Subnets | Where-Object {$_.Name -eq "SNetPrivateEndpoint"}

foreach ($PE in $PEs) {
  $pec = @{
    Name = $PE.Name
    PrivateLinkServiceId = $PE.PrivateLinkServiceConnections.PrivateLinkServiceId
    GroupID = $PE.PrivateLinkServiceConnections.GroupIds
  }

  Write-host "Creating PE Connection using :" @pec

  $PEConnection = New-AzPrivateLinkServiceConnection @pec

  $pe = @{
    Name = $PE.Name
    ResourceGroupName = $TagetRG
    Location = $ALZLocation
    PrivateLinkServiceConnection = $PEConnection
    Subnet = $subnet
  }

  Write-host "Creating PE using :" @pe
  New-AzPrivateEndpoint @pe
  
}

