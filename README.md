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


Hoe de Admin Agent en Helpdesk Agent Groepen invloed hebben op het rapporteren van Azure-verbruik
Microsoft maakt bij de rapportage van Azure-verbruik onderscheid tussen Managed Resources en Unmanaged Resources. Dit onderscheid is direct gekoppeld aan de aanwezigheid van de Admin Agent Group en/of Helpdesk Agent Group in de Role Assignments van een Azure Subscription.

1. Managed Resources (Correcte rapportage met marge)
Wanneer de Admin Agent Group en/of de Helpdesk Agent Group correct zijn toegevoegd aan de Role Assignments binnen de Azure Subscription, wordt het gebruik correct toegewezen aan de indirect provider (ALSO). Dit betekent:
✅ Het verbruik wordt gerapporteerd als Managed Resources.
✅ De indirect provider ontvangt een correcte rapportage van het gebruik, inclusief de juiste marge tussen inkoop en Microsoft listprijs.
✅ Partners behouden controle en inzicht in het Azure-verbruik van hun klanten, wat helpt bij het optimaliseren van kosten en diensten.

2. Unmanaged Resources (Minimale of geen marge)
Als de Admin Agent Group en/of de Helpdesk Agent Group niet zijn toegevoegd aan de Role Assignments in de Azure Subscription:
❌ Microsoft rapporteert het verbruik als Unmanaged Resources.
❌ De indirect provider ontvangt slechts een minimale of geen marge tussen de inkoopprijs en de Microsoft listprijs.
❌ Er is minder inzicht en controle over het daadwerkelijke verbruik, wat kan leiden tot inefficiënties en hogere kosten voor partners en eindklanten.

Waarom is dit belangrijk voor CSP-partners?
Voor CSP-partners is het essentieel om te zorgen dat de Admin Agent en/of Helpdesk Agent Group correct zijn toegewezen aan de Role Assignments van een Azure Subscription, zodat:

Het verbruik correct wordt geregistreerd als Managed Resources.
De partner een gezonde marge behoudt en niet onnodig omzet verliest.
Er volledig inzicht is in het verbruik van de klant, wat helpt bij het optimaliseren van licenties en diensten.
