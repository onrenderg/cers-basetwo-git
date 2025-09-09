# Mobile_finalsaveData Stored Procedure

## Purpose
Finalizes candidate expenditure data by updating status from pending to final, with poll date validation and transaction management.

## Parameters
- `@AutoID` (bigint) - Candidate identifier for finalization

## Logic Flow

```mermaid
flowchart TD
    Start([START: Mobile_finalsaveData]) --> Input(Input: @AutoID)
    
    Input --> MainBegin(BEGIN Main Block)
    
    subgraph "Main Procedure Block"
        MainBegin --> TryBegin(BEGIN TRY Block)
        
        subgraph "Transaction Block"
            TryBegin --> BeginTrans(BEGIN TRANSACTION)
            BeginTrans --> DeclarePollDate(DECLARE @pollDate date)
            DeclarePollDate --> GetPollDate(SELECT @pollDate = PollDate<br/>FROM electionmaster<br/>WHERE ElectionID = max electionid<br/>for @AutoID)
            GetPollDate --> PrintDate(PRINT @pollDate)
            PrintDate --> CheckDate{Current Date >= @pollDate?}
            
            CheckDate -->|True| AllowedBlock(Finalization Allowed)
            subgraph "Success Block"
                AllowedBlock --> UpdateStatus(UPDATE candidateRegister<br/>SET ExpStatus='F', DtTm=GETDATE<br/>WHERE AutoID=@AutoID)
                UpdateStatus --> ReturnSuccess(SELECT 200 statuscode<br/>'Successfully Submitted' Msg)
            end
            
            CheckDate -->|False| NotAllowedBlock(Finalization Not Allowed)
            subgraph "Date Restriction Block"
                NotAllowedBlock --> ReturnDateError(SELECT 400 statuscode<br/>'Final Submit is allowed after Poll Date' Msg)
            end
            
            ReturnSuccess --> Commit(COMMIT TRANSACTION)
            ReturnDateError --> Commit
        end
        
        TryBegin --> CatchBegin(BEGIN CATCH Block)
        subgraph "Error Handling Block"
            CatchBegin --> Rollback(ROLLBACK TRANSACTION)
            Rollback --> ReturnError(SELECT 400 statuscode<br/>ERROR_MESSAGE Msg)
            ReturnError --> CatchEnd(END CATCH Block)
        end
    end
    
    Commit --> MainEnd(END Main Block)
    CatchEnd --> MainEnd
    MainEnd --> Finish([END PROCEDURE])

    %% Styling
    classDef startEnd fill:#e8f5e8,stroke:#4caf50,stroke-width:3px
    classDef process fill:#e3f2fd,stroke:#2196f3
    classDef decision fill:#fff3e0,stroke:#ff9800
    classDef success fill:#e8f5e8,stroke:#4caf50
    classDef error fill:#ffebee,stroke:#f44336
    classDef block fill:#f3e5f5,stroke:#9c27b0
    classDef transaction fill:#e1f5fe,stroke:#03a9f4
    
    class Start,Finish startEnd
    class Input,MainBegin,DeclarePollDate,GetPollDate,PrintDate,UpdateStatus,MainEnd process
    class CheckDate decision
    class AllowedBlock,ReturnSuccess success
    class NotAllowedBlock,ReturnDateError,CatchBegin,Rollback,ReturnError error
    class TryBegin,BeginTrans,Commit,CatchEnd block
    class BeginTrans,Commit,Rollback transaction
```

## Business Logic

### Finalization Rules:
1. **Poll Date Validation**: Final submission only allowed after poll date
2. **Status Update**: Changes ExpStatus from 'P' (Pending) to 'F' (Final)
3. **Timestamp Update**: Records finalization time with GETDATE()
4. **Transaction Safety**: All operations wrapped in transaction

### Date Validation Process:
1. **Poll Date Lookup**: Retrieves poll date from election master
2. **Election ID Resolution**: Uses maximum election ID for the candidate
3. **Date Comparison**: Current date must be >= poll date
4. **Enforcement**: Blocks early finalization attempts

### Response Codes:
- **200**: Successfully Submitted - Finalization completed
- **400**: Date restriction error or system error

## Tables Accessed
- `sec.sec.electionmaster` - Election and poll date information
- `sec.sec.CandidatePersonalInfo` - Candidate election mapping
- `sec.candidateRegister` - Expenditure records to finalize

## Transaction Management
- **BEGIN TRANSACTION**: Ensures data consistency
- **COMMIT**: On successful completion
- **ROLLBACK**: On any error or exception
- **TRY-CATCH**: Comprehensive error handling

## Usage Context
This procedure is called when:
1. Candidate has completed all expenditure entries
2. Poll date has passed
3. Candidate wants to finalize submission
4. System needs to lock expenditure data from further changes

## Security Features
- **Date Enforcement**: Prevents premature finalization
- **Transaction Integrity**: Atomic operations
- **Error Logging**: Detailed error messages
- **Status Tracking**: Clear audit trail with timestamps

## Business Impact
After finalization:
- Expenditure data becomes read-only
- Data is available for observer review
- Reports can include finalized amounts
- Compliance requirements are met
