# Mobile_saveData Stored Procedure

## Purpose
Saves expenditure data for candidates with validation, transaction management, and evidence file handling.

## Parameters
- `@AutoID` (bigint) - Candidate identifier
- `@expDate` (varchar(10)) - Expenditure date
- `@expCode` (char(3)) - Expenditure type code
- `@amtType` (char(1)) - Amount type indicator
- `@amount` (numeric(9,2)) - Expenditure amount
- `@amountoutstanding` (numeric(9,2)) - Outstanding amount
- `@paymentDate` (varchar(10)) - Payment date
- `@voucherBillNumber` (varchar(100)) - Voucher/bill number
- `@payMode` (varchar(20)) - Payment mode
- `@payeeName` (varchar(30)) - Payee name
- `@payeeAddress` (varchar(250)) - Payee address
- `@sourceMoney` (varchar(200)) - Source of money
- `@remarks` (nvarchar(250)) - Optional remarks
- `@evidenceFile` (varbinary(max)) - Optional evidence file

## Logic Flow

```mermaid
flowchart TD
    Start([START: Mobile_saveData]) --> Input(Input Parameters)
    
    Input --> MainBegin(BEGIN Main Block)
    
    subgraph "Main Procedure Block"
        MainBegin --> TryBegin(BEGIN TRY Block)
        
        subgraph "Transaction Block"
            TryBegin --> Transaction(BEGIN TRANSACTION)
            Transaction --> Check(Check if record exists<br/>WHERE AutoID=@AutoID<br/>AND expDate=@expDate<br/>AND expCode=@expCode)
            
            Check --> Exists{Record Exists?}
            
            Exists -->|False| Block1(BEGIN Insert Block)
            subgraph "Data Insert Block"
                Block1 --> DeclareVar(DECLARE @candidatepanchayat)
                DeclareVar --> GetPanchayat(SET @candidatepanchayat =<br/>SELECT PANCHAYAT_CODE<br/>FROM CandidatePersonalInfo<br/>WHERE AUTO_ID=@AutoID)
                GetPanchayat --> InsertMain(INSERT INTO candidateRegister<br/>All expenditure details<br/>ExpStatus=P Pending)
                InsertMain --> DeclareExp(DECLARE @expenseid bigint)
                DeclareExp --> GetExpID(SET @expenseid =<br/>SELECT TOP 1 ExpenseID<br/>ORDER BY DtTm DESC)
                GetExpID --> CheckEvidence{@evidenceFile IS NOT NULL?}
                
                CheckEvidence -->|True| EvidenceBlock(BEGIN Evidence Block)
                subgraph "Evidence File Block"
                    EvidenceBlock --> InsertEvidence(INSERT INTO candidateExpenseEvidence<br/>ExpenseID evidenceFile DtTm)
                    InsertEvidence --> EvidenceEnd(END Evidence Block)
                end
                
                CheckEvidence -->|False| NoEvidence(Skip Evidence Insert)
                EvidenceEnd --> End1(END Insert Block)
                NoEvidence --> End1
            end
            
            Exists -->|True| DuplicateError(Record Already Exists)
            
            End1 --> Commit(COMMIT TRANSACTION)
            DuplicateError --> Rollback(ROLLBACK TRANSACTION)
            Commit --> Success(Return Success)
            Rollback --> Error(Return Error)
        end
        
        TryBegin --> CatchBegin(BEGIN CATCH Block)
        subgraph "Error Handling Block"
            CatchBegin --> RollbackCatch(ROLLBACK TRANSACTION)
            RollbackCatch --> ErrorMsg(Return Error Message)
            ErrorMsg --> CatchEnd(END CATCH Block)
        end
    end
    
    Success --> MainEnd(END Main Block)
    Error --> MainEnd
    CatchEnd --> MainEnd
    MainEnd --> Finish([END PROCEDURE])

    %% Styling
    classDef startEnd fill:#e8f5e8,stroke:#4caf50,stroke-width:3px
    classDef process fill:#e3f2fd,stroke:#2196f3
    classDef decision fill:#fff3e0,stroke:#ff9800
    classDef error fill:#ffebee,stroke:#f44336
    classDef success fill:#e8f5e8,stroke:#4caf50
    classDef block fill:#f3e5f5,stroke:#9c27b0
    classDef transaction fill:#e1f5fe,stroke:#03a9f4
    
    class Start,Finish startEnd
    class Input,GetPanchayat,InsertMain,GetExpID,InsertEvidence process
    class Exists,CheckEvidence decision
    class DuplicateError,Rollback,Error,RollbackCatch,ErrorMsg error
    class Commit,Success success
    class MainBegin,TryBegin,Block1,EvidenceBlock,End1,CatchBegin,CatchEnd,MainEnd block
    class Transaction,Commit,Rollback,RollbackCatch transaction
```

## Business Logic

### Validation Rules:
1. **Duplicate Check**: Prevents duplicate entries for same AutoID, expDate, and expCode combination
2. **Panchayat Code Lookup**: Automatically retrieves candidate's panchayat code
3. **Date Conversion**: Converts string dates to datetime format (111 for expDate, 101 for paymentDate)

### Data Processing:
1. **Main Record Insert**: Creates primary expenditure record in `candidateRegister`
2. **Evidence Handling**: Optional evidence file stored in separate table `candidateExpenseEvidence`
3. **Status Setting**: All new records marked as 'P' (Pending)
4. **Timestamp**: Automatic timestamp (DtTm) added using GETDATE()

### Transaction Management:
- **BEGIN TRANSACTION**: Ensures data consistency
- **COMMIT**: On successful completion
- **ROLLBACK**: On any error or duplicate detection
- **TRY-CATCH**: Comprehensive error handling

### Tables Modified:
1. **`sec.candidateRegister`**: Main expenditure data
2. **`sec.candidateExpenseEvidence`**: Evidence files (if provided)

### Tables Queried:
1. **`sec.candidateRegister`**: Duplicate check
2. **`sec.CandidatePersonalInfo`**: Panchayat code lookup

## Data Flow
1. Validate input parameters
2. Check for existing record (prevent duplicates)
3. Get candidate's panchayat code
4. Insert main expenditure record
5. Get generated ExpenseID
6. Insert evidence file (if provided)
7. Commit transaction or rollback on error

## Error Handling
- **Duplicate Prevention**: Returns error if record already exists
- **Transaction Rollback**: Automatic rollback on any failure
- **Exception Handling**: TRY-CATCH block for unexpected errors
- **Data Integrity**: Foreign key relationships maintained

## Security Features
- **Parameter Validation**: All inputs validated before processing
- **Transaction Isolation**: Prevents partial data commits
- **Audit Trail**: Timestamps on all records
- **File Security**: Evidence files stored as varbinary for security
