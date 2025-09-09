# CERS Database Tables Import Commands for Local SQL Server

## Local SQL Server Connection
**Instance**: `ROYAL-NIC-6F\SQLEXPRESS`
**Authentication**: SQL Server Authentication (sa account)
**Connection String**: `sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere`

---

## Database Setup

### Create Database and Schema
```sql
-- Create main database
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -Q "CREATE DATABASE secExpense;"

-- Create sec schema in secExpense database
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -Q "CREATE SCHEMA sec;"
```

---

## Import Table Creation Scripts

### Core Security Schema (sec.sec) Tables
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_sec_CandidatePersonalInfo.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_sec_CandidatePersonalInfo_arc.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_sec_candidateRegister.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_sec_candidateExpenseEvidence.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_sec_Panchayats.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_sec_Blocks.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_sec_Districts.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_sec_ElectionMaster.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_sec_ElectionPolls.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_sec_commonmaster.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_sec_Mobile_CERS_Otp.sql"

### Expense Management Schema Tables
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_secExpense_ObserverInfo.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_secExpense_OberverRemarks.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_secExpense_expenseLimitMaster.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Tables\CREATE_secExpense_expenseSourceMaster.sql"

---

## Batch Import Script for Tables

```batch
REM ===== CERS Tables Import =====
ECHO Setting up CERS database tables on local SQL Server...

REM Create database and schema
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -Q "IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'secExpense') CREATE DATABASE secExpense;"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -Q "IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'sec') EXEC('CREATE SCHEMA sec');"

ECHO Database and schema created successfully.

REM Import all tables
ECHO Importing tables...
FOR /F "tokens=*" %%i IN ('TYPE "%~dp0mssql-import-tables.md" ^| FINDSTR /B "sqlcmd.*CREATE_.*\.sql"') DO (
    ECHO Importing: %%i
    %%i
)

ECHO CERS database tables setup completed successfully!
```

---

## Verification Commands

### Check Database and Schema
```sql
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -Q "SELECT name FROM sys.databases WHERE name = 'secExpense';"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -Q "SELECT name FROM sys.schemas WHERE name = 'sec';"
```

### List Imported Tables
```sql
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -Q "SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' ORDER BY TABLE_SCHEMA, TABLE_NAME;"
```

### Count Tables by Schema
```sql
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -Q "SELECT TABLE_SCHEMA, COUNT(*) as TableCount FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' GROUP BY TABLE_SCHEMA;"
```

---

## Prerequisites

1. **SQL Server Express** installed and running
2. **sa account** enabled with strong password
3. **Exported table creation scripts** available in `C:\Exports\Tables\` directory
4. **Replace password** in all commands: `YourStrongPasswordHere`

---

## Table Summary

| Schema | Tables | Purpose |
|--------|--------|---------|
| `sec.sec` | 11 tables | Core application, authentication, elections |
| `secExpense.sec` | 4 tables | Expense tracking, observer management |
| **Total** | **15 tables** | Complete CERS table structure |

---

## Connection String for Applications

**Entity Framework**: `Server=ROYAL-NIC-6F\\SQLEXPRESS;Database=secExpense;User Id=sa;Password=YourStrongPasswordHere;TrustServerCertificate=true;`

**ADO.NET**: `Data Source=ROYAL-NIC-6F\\SQLEXPRESS;Initial Catalog=secExpense;User ID=sa;Password=YourStrongPasswordHere;TrustServerCertificate=true;`
