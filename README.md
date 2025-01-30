# Assign-Foreign-principal-Group
PowerShell Script: Assign Azure Role Foreign Principal Group to Multiple Subscriptions
PowerShell Script: Assign Azure Role to Multiple Subscriptions

Overview

This PowerShell script automates the assignment of the Owner role to multiple Azure AD groups (or other objects) across multiple Azure subscriptions.

Functionality
Authenticates to a specified Azure Tenant.
Iterates through a list of Object IDs (groups or users).
Assigns the specified role (Owner) to each object within the specified subscriptions.
Parameters

$Sub1, $Sub2, $Sub3 – Subscription IDs where the role assignment should be applied.

$role – The role to be assigned (default: "Owner").

$ObjectIDs – The list of objects (e.g., AD groups) receiving the role assignment.

$tenantID – The Tenant ID used for authentication.

Requirements
Azure PowerShell module installed.
Administrator access to the specified subscriptions.
Object IDs of the target users/groups available.

Usage

Replace the placeholders (<Subscription ID>, <Object ID>, <Tenant ID>) with the correct values and execute the script in a PowerShell environment with the necessary permissions.
