ShiftTracker 2.0
Version 2.0
Creator: ORuthless

Welcome to the ShiftTracker 2.0 - This tool is designed to help you manage your shifts, track your osrs accounts, and log the important details of your work. 

tracking coal, iron ore, steel bars, or calculating profits, 
this program simplifies your record-keeping. Keep your data organized, and easily access your work history.

Features:
Track and log shift details including materials used, products created, and profit.
Manage accounts and easily switch between them during shifts.
Store shift data in CSV files for easy access and analysis.
Clear log files, and save all your data to a Notepad file for backup.
View total profit and shift history at any time.
Step-by-Step Instructions
1. Initial Setup:
Make sure your system has PowerShell installed.
Create a folder on your system where you want to store logs. For example, "C:\Users\cash\Documents\SHIFT TRACKER SAVE LOGS".
The program will automatically create log files (ShiftLogs.csv, ProfitLogs.csv, Accounts.xml, ShiftTrackerData.txt) within this folder.

3. Running the Program:
To run the program, follow these steps:
Open PowerShell.
Copy and paste the script into your PowerShell window or save the script as a .ps1 file (e.g., ShiftTracker.ps1) and run it by typing:
bash
Copy code
.\ShiftTracker.ps1

3. Main Menu:
When the program runs, you will be presented with a menu containing the following options:

1. Start Shift: Begin a new shift and log materials used.
2. End Shift: End the current shift, log the details, and calculate profit.
3. Add Account: Add a new account by entering the username, password, and account name.
4. Show Shift History: View a table of all previous shifts including materials used, products created, and profits.
5. Show Total Profit: Display the total profit accumulated from all shifts.
6. Show All Accounts: View a list of all added accounts.
7. Clear Shift Logs: Delete all shift logs.
8. Clear Account Logs: Delete all account records.
9. Clear Total Profit: Reset the total profit to zero.
10. Save All Data to Notepad: Save all the data (shift history, total profit, accounts) to a text file.
11. Exit: Exit the program.
  
4. Key Functions:
Start Shift (Option 1):
The program will prompt you to enter the shift date, shift number, and the quantity of materials used (Coal, Iron Ore, Steel Bars).
The first available account will be automatically selected for the shift.
End Shift (Option 2):
The program will ask for the number of Steel Bars created, Cannonballs created, and the profit made during the shift.
After entering the data, the shift will be saved, and the profit will be added to the total profit.
Add Account (Option 3):
Enter a new username, password (entered securely), and account name. This will add a new account to your records.
Show Shift History (Option 4):
View a detailed list of all logged shifts, including the shift date, duration, materials used, products created, and profit.
Show Total Profit (Option 5):
See the total accumulated profit from all shifts.
Show All Accounts (Option 6):
List all accounts that have been added to the program.
Clear Shift Logs (Option 7):
Remove all shift logs from the system.
Clear Account Logs (Option 8):
Delete all account records.
Clear Total Profit (Option 9):
Reset the total profit to zero.
Save All Data to Notepad (Option 10):
Save all shift history, account information, and total profit to a .txt file.
Logging System:
The program automatically logs data in these files:
ShiftLogs.csv: Logs shift details like date, materials used, products created, etc.
ProfitLogs.csv: Logs the shift date, shift number, and profit.
Accounts.xml: Stores account information like usernames, passwords (securely), and account names.
ShiftTrackerData.txt: Saves all data in a readable format for easy backup.
Troubleshooting:
Error loading accounts: If there's an issue with loading accounts from the XML file, the program will notify you. Ensure that the file exists and is formatted correctly.
No accounts available: If no accounts have been added, the program will continue without an account.
Creator's Note:
This program is designed by ORuthless, For OSRS BF/CB Shifts
