# CERS Database Table Export Commands

## Core Security Schema (sec.sec) Tables

### Candidate & User Management Tables
# CERS Database Table Export Commands

## Core Security Schema (sec.sec) Tables

### Candidate & User Management Tables
```bash
sqlcmd -S 10.146.2.114 -d secExpense -U sec -P sec12345 -Q "SET NOCOUNT ON; SELECT * FROM sec.CandidatePersonalInfo" -s"," -W -o "C:\Exports\Tables\sec_CandidatePersonalInfo.csv"



```