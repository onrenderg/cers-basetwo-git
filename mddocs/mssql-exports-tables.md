# CERS Database Table Export Commands

## Core Security Schema (sec.sec) Tables

### Candidate & User Management Tables
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'CandidatePersonalInfo' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_CandidatePersonalInfo_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'CandidatePersonalInfo_arc' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_CandidatePersonalInfo_arc_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'candidateRegister' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_candidateRegister_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'candidateExpenseEvidence' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_candidateExpenseEvidence_structure.txt"

### Geographic & Administrative Tables
    sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'Panchayats' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_Panchayats_structure.txt"
    sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'Blocks' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_Blocks_structure.txt"
    sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'Districts' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_Districts_structure.txt"

### Election Management Tables
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'ElectionMaster' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_ElectionMaster_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'ElectionPolls' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_ElectionPolls_structure.txt"

### Reference Data Tables
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'commonmaster' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_commonmaster_structure.txt"

### Authentication & OTP Tables
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'Mobile_CERS_Otp' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\sec_Mobile_CERS_Otp_structure.txt"

## Expense Management Schema (secExpense.sec) Tables

### Observer Management Tables
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'ObserverInfo' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\secExpense_ObserverInfo_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'OberverRemarks' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\secExpense_OberverRemarks_structure.txt"

### Expense Configuration Tables
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'expenseLimitMaster' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\secExpense_expenseLimitMaster_structure.txt"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'expenseSourceMaster' ORDER BY ORDINAL_POSITION" -o "C:\Exports\Tables\secExpense_expenseSourceMaster_structure.txt"

## Table Creation Scripts Export

### Core Security Schema (sec.sec) Tables
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'CandidatePersonalInfo' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_sec_CandidatePersonalInfo.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'CandidatePersonalInfo_arc' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_sec_CandidatePersonalInfo_arc.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'candidateRegister' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_sec_candidateRegister.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'candidateExpenseEvidence' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_sec_candidateExpenseEvidence.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'Panchayats' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_sec_Panchayats.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'Blocks' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_sec_Blocks.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'Districts' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_sec_Districts.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'ElectionMaster' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_sec_ElectionMaster.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'ElectionPolls' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_sec_ElectionPolls.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'commonmaster' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_sec_commonmaster.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'Mobile_CERS_Otp' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_sec_Mobile_CERS_Otp.sql"

### Expense Management Schema (secExpense.sec) Tables
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [secExpense].[sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'ObserverInfo' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_secExpense_ObserverInfo.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [secExpense].[sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'OberverRemarks' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_secExpense_OberverRemarks.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [secExpense].[sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'expenseLimitMaster' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_secExpense_expenseLimitMaster.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SELECT 'CREATE TABLE [secExpense].[sec].[' + TABLE_NAME + '] (' + STRING_AGG('[' + COLUMN_NAME + '] ' + DATA_TYPE + CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')' ELSE '' END + CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END, ', ') + ');' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sec' AND TABLE_NAME = 'expenseSourceMaster' GROUP BY TABLE_NAME" -o "C:\Exports\Tables\CREATE_secExpense_expenseSourceMaster.sql"

## Batch Export Script for Tables

REM Create tables export directory if it doesn't exist
mkdir "C:\Exports\Tables" 2>nul

REM Export table structures
FOR /F "tokens=*" %%i IN ('TYPE "%~dp0mssql-exports-tables.md" ^| FINDSTR /B "sqlcmd.*structure"') DO %%i

REM Export table creation scripts
FOR /F "tokens=*" %%i IN ('TYPE "%~dp0mssql-exports-tables.md" ^| FINDSTR /B "sqlcmd.*CREATE"') DO %%i

ECHO All table structures and creation scripts exported to C:\Exports\Tables\

## Quick Reference

### Table Structure Files
- Structure files: `*_structure.txt` - Column details, data types, constraints
- Creation scripts: `CREATE_*.sql` - Ready-to-run table creation scripts

### Export Locations
- Table structures: `C:\Exports\Tables\*_structure.txt`
- Creation scripts: `C:\Exports\Tables\CREATE_*.sql`

### Usage
1. Run individual sqlcmd commands for specific tables
2. Use batch script to export all tables at once
3. Review structure files for column analysis
4. Use creation scripts for database recreation
