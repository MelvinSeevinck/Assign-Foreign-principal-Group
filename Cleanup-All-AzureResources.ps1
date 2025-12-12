<#
.SYNOPSIS
Removes every Azure resource in all (or specified) subscriptions from Azure Cloud Shell.

.DESCRIPTION
This script is intended for use in Azure Cloud Shell. It removes all locks and then deletes every resource group (and any
remaining stand-alone resources). Use it with extreme caution: nothing remains active in the selected subscriptions once it
finishes. By default the script asks for confirmation; use -Force to skip the confirmation and -WhatIf to only display what
would happen.

.PARAMETER TenantId
Optional tenant ID for establishing the context.

.PARAMETER SubscriptionId
One or more specific subscription IDs to clean up. Without this parameter, all available subscriptions are cleaned up.

.PARAMETER Force
Skips the confirmation prompt. Use only in automated scenarios.

.PARAMETER WhatIf
Shows which resources would be removed without making changes.

.EXAMPLE
./Cleanup-All-AzureResources.ps1 -TenantId <tenantId>
Removes all resources in every subscription of the specified tenant after manual confirmation.

.EXAMPLE
./Cleanup-All-AzureResources.ps1 -SubscriptionId <subId1>,<subId2> -Force
Removes every resource in the specified subscriptions without an extra prompt.
#>
param(
    [string]$TenantId,
    [string[]]$SubscriptionId,
    [switch]$Force,
    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"

# Sign in to the correct tenant (Cloud Shell is typically already signed in)
if ($TenantId) {
    Connect-AzAccount -Tenant $TenantId | Out-Null
} else {
    Connect-AzAccount | Out-Null
}

$subscriptions = if ($SubscriptionId) {
    Get-AzSubscription -SubscriptionId $SubscriptionId
} else {
    Get-AzSubscription
}

if (-not $subscriptions) {
    Write-Host "No subscriptions found for the current identity." -ForegroundColor Yellow
    exit 0
}

if (-not $Force) {
    $subList = ($subscriptions | ForEach-Object { "`n - $($_.Name) ($($_.Id))" }) -join ''
    $confirmation = Read-Host "Type EXACTLY 'DELETE ALL' to delete EVERY resource in the following subscriptions:$subList"
    if ($confirmation -ne 'DELETE ALL') {
        Write-Host "Operation aborted: incorrect confirmation received." -ForegroundColor Yellow
        exit 1
    }
}

foreach ($subscription in $subscriptions) {
    Write-Host "\n==> Processing subscription: $($subscription.Name) ($($subscription.Id))" -ForegroundColor Cyan
    Set-AzContext -SubscriptionId $subscription.Id | Out-Null

    # Remove all locks that could block cleanup
    $locks = Get-AzResourceLock -ErrorAction SilentlyContinue
    foreach ($lock in $locks) {
        if ($WhatIf) {
            Write-Host "[WhatIf] Lock would be removed: $($lock.Name) on scope $($lock.Scope)"
        } else {
            Write-Host "Removing lock: $($lock.Name) on scope $($lock.Scope)"
            Remove-AzResourceLock -LockId $lock.LockId -Force
        }
    }

    # Remove all resource groups (which implicitly deletes their resources)
    $resourceGroups = Get-AzResourceGroup -ErrorAction SilentlyContinue
    $jobs = @()
    foreach ($rg in $resourceGroups) {
        if ($WhatIf) {
            Write-Host "[WhatIf] Resource group would be removed: $($rg.ResourceGroupName)"
        } else {
            Write-Host "Deleting resource group: $($rg.ResourceGroupName)" -ForegroundColor Yellow
            $jobs += Remove-AzResourceGroup -Name $rg.ResourceGroupName -Force -AsJob
        }
    }

    if (-not $WhatIf -and $jobs.Count -gt 0) {
        Write-Host "Waiting for all resource group deletions to complete..."
        $jobs | Wait-Job | Out-Null
        $jobs | Receive-Job | Out-Null
    }

    # Clean up any remaining stand-alone resources
    $remainingResources = Get-AzResource -ErrorAction SilentlyContinue
    foreach ($resource in $remainingResources) {
        if ($WhatIf) {
            Write-Host "[WhatIf] Stand-alone resource would be removed: $($resource.Name) ($($resource.ResourceType))"
        } else {
            Write-Host "Removing stand-alone resource: $($resource.Name) ($($resource.ResourceType))"
            Remove-AzResource -ResourceId $resource.ResourceId -Force
        }
    }

    # Final check
    if (-not $WhatIf) {
        $postCheck = Get-AzResource -ErrorAction SilentlyContinue
        if ($postCheck.Count -eq 0) {
            Write-Host "No active resources found in $($subscription.Name)." -ForegroundColor Green
        } else {
            Write-Host "There are still $($postCheck.Count) resources in $($subscription.Name); check if additional permissions are required." -ForegroundColor Yellow
        }
    }
}

Write-Host "\nDone. All selected subscriptions have been processed." -ForegroundColor Green
