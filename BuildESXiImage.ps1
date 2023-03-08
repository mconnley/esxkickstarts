Connect-VIServer -Server vc8.mattconnley.com -user administrator@vsphere.local
$datacenterName = "HomeLab"
$clusterName = "ImageBuildOnly"
$esxiImageName = "8.0b - 21203435"
$esxiComponentName = "VMware USB NIC Fling Driver"
$esxiComponentVersion = "1.11-1vmw"


$esxiBaseImage = Get-LcmImage -Type BaseImage -Version $esxiImageName
$esxiComponent = Get-LcmImage -Type Component | where {$_.Name -eq $esxiComponentName -and $_.Version -eq $esxiComponentVersion}

New-Cluster -Name $clusterName -BaseImage $esxiBaseImage -Location (Get-Datacenter -Name $datacenterName)
Get-Cluster -Name $clusterName | Set-Cluster -Component @($esxiComponent) -BaseImage $esxiBaseImage -Confirm:$false
Export-LcmClusterDesiredState -Cluster (Get-Cluster -Name $clusterName) -ExportIsoImage
Get-Cluster -Name $clusterName | Remove-Cluster -Confirm:$false