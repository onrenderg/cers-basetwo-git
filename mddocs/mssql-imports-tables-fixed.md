# CERS Database Tables Import Commands - FIXED VERSION

## Local SQL Server Connection
**Instance**: `ROYAL-NIC-6F\SQLEXPRESS`
**Authentication**: SQL Server Authentication (sa account)
**Real Password**: Use your actual sa password

---

## Database Setup

### Create Database and Schema
```sql
-- Create main database
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -Q "CREATE DATABASE secExpense;"

-- Create sec schema in secExpense database
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -Q "CREATE SCHEMA sec;"
```

---

## IMPORTANT: Generate CREATE Scripts First

**⚠️ WARNING**: The original export commands using `STRING_AGG` will NOT work on SQL Server 2019. You MUST use one of these methods first:

### Method 1: PowerShell Script (Recommended)
```powershell
# Run from mddocs directory
.\generate-table-scripts.ps1
```

### Method 2: SSMS Generate Scripts
1. Connect to `10.146.2.114` using SSMS
2. Right-click `secExpense` database → Tasks → Generate Scripts
3. Select all required tables
4. Save scripts to `C:\Exports\Tables\`

### Method 3: Manual Export (Alternative)
Use the commands from `mssql-exports-tables-fixed.md` instead of the original file.

---

## Import Table Creation Scripts

### Core Security Schema (sec.sec) Tables
```batch
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_sec_CandidatePersonalInfo.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_sec_CandidatePersonalInfo_arc.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_sec_candidateRegister.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_sec_candidateExpenseEvidence.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_sec_Panchayats.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_sec_Blocks.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_sec_Districts.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_sec_ElectionMaster.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_sec_ElectionPolls.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_sec_commonmaster.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_sec_Mobile_CERS_Otp.sql"
```

### Expense Management Schema Tables
```batch
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_secExpense_ObserverInfo.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_secExpense_OberverRemarks.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_secExpense_expenseLimitMaster.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -i "C:\Exports\Tables\CREATE_secExpense_expenseSourceMaster.sql"
```

---

## Complete Batch Import Script

```batch
@echo off
REM ===== CERS Tables Import - FIXED VERSION =====
ECHO Setting up CERS database tables on local SQL Server...

REM Set your actual sa password here
SET SA_PASSWORD=YourActualSaPassword

REM Create database and schema
ECHO Creating database and schema...
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -Q "IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'secExpense') CREATE DATABASE secExpense;"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -Q "IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'sec') EXEC('CREATE SCHEMA sec');"

ECHO Database and schema created successfully.

REM Check if CREATE scripts exist
IF NOT EXIST "C:\Exports\Tables\CREATE_sec_CandidatePersonalInfo.sql" (
    ECHO ERROR: CREATE scripts not found in C:\Exports\Tables\
    ECHO Please generate CREATE scripts first using:
    ECHO 1. PowerShell script: .\generate-table-scripts.ps1
    ECHO 2. SSMS Generate Scripts wizard
    ECHO 3. Fixed export commands from mssql-exports-tables-fixed.md
    PAUSE
    EXIT /B 1
)

REM Import Core Security Tables
ECHO Importing Core Security Tables...
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_sec_CandidatePersonalInfo.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_sec_CandidatePersonalInfo_arc.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_sec_candidateRegister.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_sec_candidateExpenseEvidence.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_sec_Panchayats.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_sec_Blocks.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_sec_Districts.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_sec_ElectionMaster.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_sec_ElectionPolls.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_sec_commonmaster.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_sec_Mobile_CERS_Otp.sql"

REM Import Expense Management Tables
ECHO Importing Expense Management Tables...
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_secExpense_ObserverInfo.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_secExpense_OberverRemarks.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_secExpense_expenseLimitMaster.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "%SA_PASSWORD%" -d secExpense -i "C:\Exports\Tables\CREATE_secExpense_expenseSourceMaster.sql"

ECHO CERS database tables setup completed successfully!
PAUSE
```

---

## Verification Commands

### Check Database and Schema
```sql
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -Q "SELECT name FROM sys.databases WHERE name = 'secExpense';"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -Q "SELECT name FROM sys.schemas WHERE name = 'sec';"
```

### List Imported Tables
```sql
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -Q "SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' ORDER BY TABLE_SCHEMA, TABLE_NAME;"
```

### Count Tables by Schema
```sql
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P "YourActualSaPassword" -d secExpense -Q "SELECT TABLE_SCHEMA, COUNT(*) as TableCount FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' GROUP BY TABLE_SCHEMA;"
```

---

## Step-by-Step Usage Instructions

### Step 1: Generate CREATE Scripts
**Choose ONE method:**
- **PowerShell**: Run `.\generate-table-scripts.ps1`
- **SSMS**: Use Generate Scripts wizard
- **Manual**: Use fixed export commands

### Step 2: Update Password
Replace `YourActualSaPassword` with your real sa password in all commands.

### Step 3: Run Import
Execute the batch script or individual commands.

### Step 4: Verify
Run verification commands to confirm successful import.

---

## Connection Strings for Applications

**Entity Framework**: 
```
Server=ROYAL-NIC-6F\\SQLEXPRESS;Database=secExpense;User Id=sa;Password=YourActualSaPassword;TrustServerCertificate=true;
```

**ADO.NET**: 
```
Data Source=ROYAL-NIC-6F\\SQLEXPRESS;Initial Catalog=secExpense;User ID=sa;Password=YourActualSaPassword;TrustServerCertificate=true;
```

---

## Troubleshooting

### Common Issues:
1. **"Incorrect syntax near '0'"** - Use fixed export methods, not original STRING_AGG commands
2. **"Cannot open database"** - Ensure database and schema are created first
3. **"Login failed"** - Verify sa account is enabled and password is correct
4. **"File not found"** - Generate CREATE scripts before running import

### Solutions:
- Always generate proper CREATE scripts first
- Use the PowerShell script for best compatibility
- Verify file paths exist before running imports
- Check SQL Server Express is running
