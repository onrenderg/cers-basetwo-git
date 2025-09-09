# CERS Database Table Export Commands (Fixed for SQL Server 2019)

## Local SQL Server Connection
**Instance**: `ROYAL-NIC-6F\SQLEXPRESS`
**Authentication**: SQL Server Authentication (sa account)
**Connection String**: `sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere`

---

## Method 1: PowerShell Script (Recommended)

### Run PowerShell Script to Generate CREATE Scripts
```powershell
# Run this PowerShell script to generate all CREATE TABLE scripts
.\generate-table-scripts.ps1
```

The PowerShell script will:
1. Connect to production server `10.146.2.114`
2. Query table structures using INFORMATION_SCHEMA
3. Generate proper CREATE TABLE statements
4. Save to `C:\Exports\Tables\`

---

## Method 2: Manual sqlcmd Export (Table Structures Only)

### Core Security Schema (sec.sec) Tables
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'CandidatePersonalInfo' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_CandidatePersonalInfo_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'CandidatePersonalInfo_arc' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_CandidatePersonalInfo_arc_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'candidateRegister' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_candidateRegister_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'candidateExpenseEvidence' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_candidateExpenseEvidence_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'Panchayats' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_Panchayats_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'Blocks' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_Blocks_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'Districts' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_Districts_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'ElectionMaster' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_ElectionMaster_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'ElectionPolls' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_ElectionPolls_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'commonmaster' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_commonmaster_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'Mobile_CERS_Otp' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_Mobile_CERS_Otp_structure.txt"

### Expense Management Schema Tables
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'ObserverInfo' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\secExpense_ObserverInfo_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'OberverRemarks' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\secExpense_OberverRemarks_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'expenseLimitMaster' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\secExpense_expenseLimitMaster_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'expenseSourceMaster' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\secExpense_expenseSourceMaster_structure.txt"

---

## Method 3: SQL Server Management Studio (SSMS)

### Generate CREATE Scripts using SSMS
1. Connect to production server `10.146.2.114` using SSMS
2. Right-click `secExpense` database → Tasks → Generate Scripts
3. Select "Script specific database objects" → Choose Tables
4. Select all tables in `sec` schema
5. Advanced Options → Script for Server Version: SQL Server 2019
6. Save scripts to `C:\Exports\Tables\`

---

## Batch Export Script

```batch
REM Create export directory
mkdir "C:\Exports\Tables" 2>nul

REM Run PowerShell script (Method 1 - Recommended)
powershell -ExecutionPolicy Bypass -File "generate-table-scripts.ps1"

REM Alternative: Export table structures only (Method 2)
REM FOR /F "tokens=*" %%i IN ('TYPE "mssql-exports-tables-fixed.md" ^| FINDSTR /B "sqlcmd.*structure"') DO %%i

ECHO Table export completed!
```

---

## Usage Instructions

### Option 1: PowerShell Script (Recommended)
1. Install SQL Server PowerShell module: `Install-Module -Name SqlServer`
2. Run: `.\generate-table-scripts.ps1`
3. Import using: `mssql-import-tables.md`

### Option 2: SSMS (Easiest)
1. Use SSMS Generate Scripts wizard
2. Export to `C:\Exports\Tables\`
3. Import using: `mssql-import-tables.md`

### Option 3: Manual Structure Export
1. Export table structures using sqlcmd commands above
2. Manually create CREATE TABLE statements from structure files
3. Save as CREATE_*.sql files in `C:\Exports\Tables\`

---

## Troubleshooting

**Issue**: `STRING_AGG` function errors
**Solution**: Use PowerShell script or SSMS instead of sqlcmd STRING_AGG

**Issue**: Syntax errors in CREATE scripts
**Solution**: PowerShell script generates proper syntax for SQL Server 2019

**Issue**: Connection timeouts
**Solution**: Check network connectivity to production server `10.146.2.114`
