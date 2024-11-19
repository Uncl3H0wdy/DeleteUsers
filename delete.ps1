# Ensure you have the required modules
if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    Install-Module -Name ImportExcel -Force -Scope CurrentUser
    Import-Module ImportExcel
}

if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Install-Module -Name Microsoft.Graph.Users -Force -Scope CurrentUser
    Import-Module Microsoft.Graph.Users
}

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Path to your Excel file
$excelFilePath = Read-Host "Enter the full filepath to the xlsx file e.g C:\temp\UsersToDelete.xlsx"

# Import the Excel spreadsheet
$guestAccounts = Import-Excel -Path $excelFilePath

# Loop through each guest account and delete it
foreach ($account in $guestAccounts) {
    $userId = $account.UserPrincipalName  # Adjust this if your column name is different

    try {
        # Attempt to delete the user
        Remove-MgUser -UserId $userId
        Write-Host "Successfully deleted account: $userId"
    } catch {
        Write-Host "Failed to delete account: $userId. Error: $_"
    }
}

# Disconnect from Microsoft Graph
Disconnect-MgGraph
