# CERS Stored Procedure Export Commands

## Authentication & User Management
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_CERS_AppLogin'" -o "C:\Exports\Mobile_CERS_AppLogin.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_CERS_ObservorLogin'" -o "C:\Exports\Mobile_CERS_ObservorLogin.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_CERS_SaveOtp'" -o "C:\Exports\Mobile_CERS_SaveOtp.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_CERS_SaveOtp_New'" -o "C:\Exports\Mobile_CERS_SaveOtp_New.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_CERS_CheckOtp'" -o "C:\Exports\Mobile_CERS_CheckOtp.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_CERS_CheckOtpAttempts'" -o "C:\Exports\Mobile_CERS_CheckOtpAttempts.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_CERS_updateOTPresponse'" -o "C:\Exports\Mobile_CERS_updateOTPresponse.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_getusertype'" -o "C:\Exports\Mobile_getusertype.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.mobile_bearer_token_get'" -o "C:\Exports\mobile_bearer_token_get.sql"

## Expenditure Management
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_saveData'" -o "C:\Exports\Mobile_saveData.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_updatesaveData'" -o "C:\Exports\Mobile_updatesaveData.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_finalsaveData'" -o "C:\Exports\Mobile_finalsaveData.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_finalsaveDataNov23'" -o "C:\Exports\Mobile_finalsaveDataNov23.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_getsaveData'" -o "C:\Exports\Mobile_getsaveData.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_getsaveData_observer'" -o "C:\Exports\Mobile_getsaveData_observer.sql"

## Observer Functions
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_getobserver_wards'" -o "C:\Exports\Mobile_getobserver_wards.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_getobserver_candidates'" -o "C:\Exports\Mobile_getobserver_candidates.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_updateobserverremarks'" -o "C:\Exports\Mobile_updateobserverremarks.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_getremarks'" -o "C:\Exports\Mobile_getremarks.sql"

## Reference Data
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_getPaymentModes'" -o "C:\Exports\Mobile_getPaymentModes.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.getExpenseSource'" -o "C:\Exports\getExpenseSource.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_getLocalResources'" -o "C:\Exports\Mobile_getLocalResources.sql"

## PDF & Document Management
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_getpdf'" -o "C:\Exports\Mobile_getpdf.sql"
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_getpdfdecdata'" -o "C:\Exports\Mobile_getpdfdecdata.sql"

## App Management
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "EXEC sp_helptext 'sec.Mobile_getappversion'" -o "C:\Exports\Mobile_getappversion.sql"

## Batch Export Script
REM Create exports directory if it doesn't exist
mkdir "C:\Exports" 2>nul

REM Run all export commands
FOR /F "tokens=*" %%i IN ('TYPE "%~dp0exports.md" ^| FINDSTR /B "sqlcmd"') DO %%i

ECHO All stored procedures exported to C:\Exports\
