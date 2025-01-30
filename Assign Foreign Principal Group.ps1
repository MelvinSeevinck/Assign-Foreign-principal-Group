# List of subscriptions
$subscriptions = @(
    "Subscription 1",
    "Subscription 2",
    "Subscription 3",
    "Subscription 4",
    "Subscription 5",
    "Subscription 6",
    "Subscription 7",
    "Subscription 8",
    "Subscription 9",
    "Subscription 10",
    "Subscription 11",
    "Subscription 12",
    "Subscription 13",
    "Subscription 14",
    "Subscription 15",
    "Subscription 16",
    "Subscription 17",
    "Subscription 18",
    "Subscription 19",
    "Subscription 20",
    "Subscription 21",
    "Subscription 22",
    "Subscription 23",
    "Subscription 24",
    "Subscription 25",
    "Subscription 26",
    "Subscription 27",
    "Subscription 28",
    "Subscription 29",
    "Subscription 30"
)

# Ensure you are logged into Azure
Connect-AzAccount

foreach ($subscription in $subscriptions) {
    Write-Host "Processing subscription: $subscription" -ForegroundColor Cyan

    # Switch to the current subscription
    Set-AzContext -SubscriptionName $subscription

    # Remove resources in all resource groups
    $resourceGroups = Get-AzResourceGroup
    foreach ($rg in $resourceGroups) {
        Write-Host "Deleting resource group: $($rg.ResourceGroupName)" -ForegroundColor Yellow
        Remove-AzResourceGroup -Name $rg.ResourceGroupName -Force -AsJob
    }

    # Remove management groups (if applicable)
    $managementGroups = Get-AzManagementGroup
    foreach ($mg in $managementGroups) {
        Write-Host "Deleting management group: $($mg.Name)" -ForegroundColor Yellow
        Remove-AzManagementGroup -GroupId $mg.Name -Force
    }
}

Write-Host "Deletion process completed for all specified subscriptions." -ForegroundColor Green
