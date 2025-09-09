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




CREATE TABLE sec.CandidatePersonalInfo (
    CandidateID INT NOT NULL PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE NULL,
    Email NVARCHAR(100) NULL
);


BULK INSERT sec.CandidatePersonalInfo
FROM 'C:\Exports\Tables\sec_CandidatePersonalInfo.csv'
WITH
(
    FIRSTROW = 2,          -- Skip CSV header
    FIELDTERMINATOR = ',', -- CSV comma separated
    ROWTERMINATOR = '\n',
    TABLOCK
);
