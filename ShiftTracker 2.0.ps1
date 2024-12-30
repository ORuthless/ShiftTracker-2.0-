# Define log file paths (in custom path)
$logPath = "C:\Users\cash\Documents\SHIFT TRACKER SAVE LOGS"
$shiftLogFile = Join-Path $logPath "ShiftLogs.csv" # CSV for shift data
$profitLogFile = Join-Path $logPath "ProfitLogs.csv" # CSV for profit data
$accountFile = Join-Path $logPath "Accounts.xml"  # Use XML instead of .txt
$notepadFile = Join-Path $logPath "ShiftTrackerData.txt" # Text file for all data

# Ensure log directory exists
if (!(Test-Path $logPath)) { New-Item -ItemType Directory -Path $logPath | Out-Null }

# --- Shift Class Definition ---
class Shift {
    [datetime]$StartTime
    [datetime]$EndTime
    [timespan]$Duration
    [string]$ShiftDate
    [int]$ShiftNumber
    [array]$AccountsUsed
    [int]$CoalUsed
    [int]$IronOreUsed
    [int]$SteelBarsUsed
    [int]$SteelBarsCreated
    [int]$CannonballsCreated
    [decimal]$Profit
}

# Global variables
$shifts = @()
$totalProfit = 0.00

# --- Account Management Functions ---
function Add-Account {
    Write-Host "=== Add New Account ==="
    $username = Read-Host "Enter Username"
    $password = Read-Host "Enter Password" -AsSecureString # Secure input
    $name = Read-Host "Enter Account Name"

    # Create a new account using PSCustomObject
    $account = [PSCustomObject]@{
        Username = $username
        Password = $password
        Name = $name
    }

    # Save account to file (as XML)
    $accounts = Get-Accounts
    $accounts += $account
    $accounts | Export-Clixml -Path $accountFile
    Write-Host "Account added successfully." -ForegroundColor Green
    Pause
}

function Get-Accounts {
    if (Test-Path $accountFile) {
        try {
            $accounts = Import-Clixml -Path $accountFile
            return $accounts
        } catch {
            Write-Host "Error loading accounts: $_" -ForegroundColor Red
            return @()  # Return empty array if there is an issue
        }
    } else {
        return @()  # Return empty array if the file doesn't exist
    }
}

# --- Shift Management Functions ---
function Start-Shift {
    Write-Host "=== Start New Shift ==="
    $shift = New-Object Shift
    $shift.ShiftDate = Read-Host "Enter Shift Date (YYYY-MM-DD)"
    $shift.ShiftNumber = [int](Read-Host "Enter Shift Number")
    $shift.StartTime = Get-Date

    # Automatically select the first available account, if any
    $accounts = Get-Accounts
    if ($accounts.Count -gt 0) {
        $shift.AccountsUsed = @($accounts[0])  # Automatically use the first account
    } else {
        Write-Host "No accounts available. Proceeding without account." -ForegroundColor Yellow
    }

    $shift.CoalUsed = [int](Read-Host "Enter Coal Used")
    $shift.IronOreUsed = [int](Read-Host "Enter Iron Ore Used")
    $shift.SteelBarsUsed = [int](Read-Host "Enter Steel Bars Used")
    
    return $shift
}

function End-Shift {
    param(
        [Shift]$shift
    )
    $shift.EndTime = Get-Date
    $shift.Duration = New-TimeSpan -Start $shift.StartTime -End $shift.EndTime

    # Now ask for Steel Bars Created, Cannonballs Created, and Profit at the end of the shift
    $shift.SteelBarsCreated = [int](Read-Host "Enter Steel Bars Created")
    $shift.CannonballsCreated = [int](Read-Host "Enter Cannonballs Created")
    $shift.Profit = [decimal](Read-Host "Enter Profit")

    $global:totalProfit += $shift.Profit
    $global:shifts += $shift
    Save-ShiftData
    Log-Shift $shift

    Write-Host "Shift ended and logged successfully." -ForegroundColor Green
    Pause
}

# --- Logging and Data Management ---
function Log-Shift {
    param(
        [Shift]$shift
    )

    $logEntry = [PSCustomObject]@{
        ShiftDate = $shift.ShiftDate
        ShiftNumber = $shift.ShiftNumber
        StartTime = $shift.StartTime
        EndTime = $shift.EndTime
        Duration = $shift.Duration
        CoalUsed = $shift.CoalUsed
        IronOreUsed = $shift.IronOreUsed
        SteelBarsUsed = $shift.SteelBarsUsed
        SteelBarsCreated = $shift.SteelBarsCreated
        CannonballsCreated = $shift.CannonballsCreated
        Profit = $shift.Profit
        AccountsUsed = ($shift.AccountsUsed | ForEach-Object {$_.Name}) -join ";" # Store account names as a string
    }

    $logEntry | Export-Csv $shiftLogFile -Append -NoTypeInformation
}

function Save-ShiftData {
    $global:shifts | Select-Object ShiftDate, ShiftNumber, Profit | Export-Csv $profitLogFile -Append -NoTypeInformation
}

function Show-ShiftHistory {
    Write-Host "=== Shift History ==="
    if (Test-Path $shiftLogFile) {
        $shiftHistory = Import-Csv $shiftLogFile
        if ($shiftHistory.Count -eq 0) {
            Write-Host "No shift logs found." -ForegroundColor Yellow
        } else {
            $shiftHistory | Format-Table -Property ShiftDate, ShiftNumber, StartTime, EndTime, Duration, CoalUsed, IronOreUsed, SteelBarsUsed, SteelBarsCreated, CannonballsCreated, Profit, AccountsUsed -AutoSize
        }
    } else {
        Write-Host "No shift logs found." -ForegroundColor Yellow
    }
    Pause
}

function Show-TotalProfit {
    Write-Host "Total Profit: $($global:totalProfit)" -ForegroundColor Cyan
    Pause
}

# --- Show All Accounts ---
function Show-AllAccounts {
    Write-Host "=== All Accounts ==="
    $accounts = Get-Accounts
    if ($accounts.Count -eq 0) {
        Write-Host "No accounts found." -ForegroundColor Yellow
    } else {
        $accounts | Format-Table -Property Username, Name -AutoSize
    }
    Pause
}

# --- Clear Log Files Functions ---
function Clear-ShiftLogs {
    if (Test-Path $shiftLogFile) {
        Remove-Item $shiftLogFile
        Write-Host "Shift logs have been cleared." -ForegroundColor Green
    } else {
        Write-Host "No shift logs found to clear." -ForegroundColor Yellow
    }
    Pause
}

function Clear-AccountLogs {
    if (Test-Path $accountFile) {
        Remove-Item $accountFile
        Write-Host "Account logs have been cleared." -ForegroundColor Green
    } else {
        Write-Host "No account logs found to clear." -ForegroundColor Yellow
    }
    Pause
}

function Clear-TotalProfit {
    $global:totalProfit = 0.00
    Write-Host "Total profit has been cleared." -ForegroundColor Green
    Pause
}

# --- Save All Data Function (Save to Notepad file) ---
function Save-AllData {
    Write-Host "Saving all data to Notepad file..." -ForegroundColor Cyan
    
    # Create or overwrite the Notepad file
    $notepadContent = ""

    # Add Shift Data to Notepad content
    $notepadContent += "=== Shift History ===`r`n"
    $global:shifts | ForEach-Object {
        $notepadContent += "Shift Date: $($_.ShiftDate), Shift Number: $($_.ShiftNumber), Start Time: $($_.StartTime), End Time: $($_.EndTime), Duration: $($_.Duration), Coal Used: $($_.CoalUsed), Iron Ore Used: $($_.IronOreUsed), Steel Bars Used: $($_.SteelBarsUsed), Steel Bars Created: $($_.SteelBarsCreated), Cannonballs Created: $($_.CannonballsCreated), Profit: $($_.Profit), Accounts Used: $($_.AccountsUsed -join ', ')`r`n"
    }

    # Add Total Profit to Notepad content
    $notepadContent += "`r`n=== Total Profit ===`r`nTotal Profit: $($global:totalProfit)`r`n"

    # Add Account Data to Notepad content
    $notepadContent += "`r`n=== Accounts ===`r`n"
    $accounts = Get-Accounts
    $accounts | ForEach-Object {
        $notepadContent += "Username: $($_.Username), Account Name: $($_.Name)`r`n"
    }

    # Write all the content to the Notepad file
    $notepadContent | Out-File -FilePath $notepadFile -Force

    Write-Host "All data saved successfully to Notepad file." -ForegroundColor Green
    Pause
}

# --- Main Menu ---
function Main-Menu {
    Initialize-Logs # Initialize log files

    while ($true) {
        Clear-Host
        Write-Host "=== Shift Tracker ===" -ForegroundColor Blue
        Write-Host "1. Start Shift"
        Write-Host "2. End Shift"
        Write-Host "3. Add Account"
        Write-Host "4. Show Shift History"
        Write-Host "5. Show Total Profit"
        Write-Host "6. Show All Accounts"
        Write-Host "7. Clear Shift Logs"
        Write-Host "8. Clear Account Logs"
        Write-Host "9. Clear Total Profit"
        Write-Host "10. Save All Data to Notepad"
        Write-Host "11. Exit"

        $choice = Read-Host "Enter your choice"

        switch ($choice) {
            "1" { $currentShift = Start-Shift }
            "2" { if ($currentShift) { End-Shift $currentShift } else { Write-Host "No shift started." -ForegroundColor Red } }
            "3" { Add-Account }
            "4" { Show-ShiftHistory }
            "5" { Show-TotalProfit }
            "6" { Show-AllAccounts }
            "7" { Clear-ShiftLogs }
            "8" { Clear-AccountLogs }
            "9" { Clear-TotalProfit }
            "10" { Save-AllData }
            "11" { break }
            default { Write-Host "Invalid option. Please try again." -ForegroundColor Red }
        }
    }
}

# --- Start the application ---
Main-Menu
