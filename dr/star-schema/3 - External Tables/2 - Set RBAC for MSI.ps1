param(
    [string]$SubscriptionName,
    [string]$PrincipalId,
    [string]$ResourceGroupName,
    [string]$StorageAccountName,
    [string]$RoleName="Storage Blob Data Contributor"
)

$role = Get-AzRoleDefinition -Name $RoleName

if ($null -eq $role) {
    Write-Error "Role $RoleName is not found."
    exit 1
}

New-AzRoleAssignment `
    -ObjectId $PrincipalId `
    -ResourceGroupName $ResourceGroupName `
    -ResourceType "Microsoft.Storage/storageAccounts" `
    -ResourceName $StorageAccountName `
    -RoleDefinitionName $RoleName