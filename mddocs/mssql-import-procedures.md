# CERS Stored Procedures Import Commands for Local SQL Server

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

## Import Stored Procedures

### Authentication & User Management
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_CERS_AppLogin.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_CERS_ObservorLogin.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_CERS_SaveOtp.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_CERS_SaveOtp_New.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_CERS_CheckOtp.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_CERS_CheckOtpAttempts.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_CERS_updateOTPresponse.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_getusertype.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\mobile_bearer_token_get.sql"

### Expenditure Management
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_saveData.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_updatesaveData.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_finalsaveData.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_finalsaveDataNov23.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_getsaveData.sql"

### Observer Functions
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_getobserver_candidates.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_updateobserverremarks.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_getremarks.sql"

### Reference Data
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_getPaymentModes.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\getExpenseSource.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_getLocalResources.sql"

### PDF & Document Management
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_getpdf.sql"
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_getpdfdecdata.sql"

### App Management
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -i "C:\Exports\Mobile_getappversion.sql"

---

## Batch Import Script for Procedures

```batch
REM ===== CERS Stored Procedures Import =====
ECHO Importing CERS stored procedures to local SQL Server...

REM Import all stored procedures
ECHO Importing stored procedures...
FOR /F "tokens=*" %%i IN ('TYPE "%~dp0mssql-import-procedures.md" ^| FINDSTR /B "sqlcmd.*Mobile_\|sqlcmd.*getExpenseSource"') DO (
    ECHO Importing: %%i
    %%i
)

ECHO CERS stored procedures import completed successfully!
```

---

## Verification Commands

### List Imported Procedures
```sql
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -Q "SELECT ROUTINE_SCHEMA, ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' ORDER BY ROUTINE_SCHEMA, ROUTINE_NAME;"
```

### Count Procedures by Category
```sql
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -Q "SELECT ROUTINE_SCHEMA, COUNT(*) as ProcedureCount FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' GROUP BY ROUTINE_SCHEMA;"
```

### Test Sample Procedures
```sql
-- Test app version procedure
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -Q "EXEC sec.Mobile_getappversion;"

-- Test expense source procedure  
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -Q "EXEC sec.getExpenseSource;"

-- Test user type procedure (requires mobile number)
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere -d secExpense -Q "EXEC sec.Mobile_getusertype '9999999999';"
```

---

## Prerequisites

1. **Database and tables** must be created first (use `mssql-import-tables.md`)
2. **Exported procedure files** available in `C:\Exports\` directory
3. **Replace password** in all commands: `YourStrongPasswordHere`

---

## Procedure Summary

| Category | Procedures | Purpose |
|----------|------------|---------|
| **Authentication & User Management** | 9 procedures | Login, OTP, user validation |
| **Expenditure Management** | 5 procedures | Expense CRUD operations |
| **Observer Functions** | 3 procedures | Observer management |
| **Reference Data** | 3 procedures | Master data lookup |
| **PDF & Document Management** | 2 procedures | Document generation |
| **App Management** | 1 procedure | Version control |
| **Total** | **23 procedures** | Complete CERS functionality |

---

## Import Order

1. **First**: Import tables using `mssql-import-tables.md`
2. **Second**: Import procedures using this file
3. **Third**: Verify using verification commands

---

## Usage Instructions

1. Ensure database and tables are created
2. Update password in all commands above
3. Run batch import script or individual commands
4. Verify successful import using verification commands
5. Test key procedures to ensure functionality
