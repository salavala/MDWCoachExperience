param(
    [string]$SubscriptonName,
    [string]$ResourceGroupName,
    [string]$ServerName
)

# Connect-AzAccount 

Select-AzSubscription -Subscription $SubscriptonName -ErrorAction Stop

$server = Set-AzSqlServer `
    -ResourceGroupName $ResourceGroupName `
    -ServerName $ServerName `
    -AssignIdentity

$server.Identity