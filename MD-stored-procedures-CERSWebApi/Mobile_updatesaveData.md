# Mobile_updatesaveData Stored Procedure

## Purpose
Updates existing expenditure records with new data including optional evidence file updates, using transaction management for data integrity.

## Parameters
- `@ExpenseID` (bigint) - Unique expense record identifier
- `@expDate` (varchar(10)) - Updated expenditure date
- `@expCode` (char(3)) - Updated expenditure type code
- `@amtType` (char(1)) - Updated amount type indicator
- `@amount` (numeric(9,2)) - Updated expenditure amount
- `@amountoutstanding` (numeric(9,2)) - Updated outstanding amount
- `@paymentDate` (varchar(10)) - Updated payment date
- `@voucherBillNumber` (varchar(100)) - Updated voucher/bill number
- `@payMode` (varchar(20)) - Updated payment mode
- `@payeeName` (varchar(30)) - Updated payee name
- `@payeeAddress` (varchar(250)) - Updated payee address
- `@sourceMoney` (varchar(200)) - Updated source of money
- `@remarks` (nvarchar(250)) - Updated remarks (optional)
- `@evidenceFile` (varbinary(max)) - Updated evidence file (optional)

## Logic Flow

```mermaid
flowchart TD
    Start([START: Mobile_updatesaveData]) --> Input(Input Parameters)
    
    Input --> MainBegin(BEGIN Main Block)
    
    subgraph "Main Procedure Block"
        MainBegin --> TryBegin(BEGIN TRY Block)
        
        subgraph "Transaction Block"
            TryBegin --> BeginTrans(BEGIN TRANSACTION)
            BeginTrans --> UpdateMain(UPDATE candidateRegister<br/>SET all expenditure fields<br/>WHERE ExpenseID=@ExpenseID)
            UpdateMain --> CheckEvidence{@evidenceFile IS NOT NULL?}
            
            CheckEvidence -->|True| EvidenceBlock(Evidence Update Block)
            subgraph "Evidence Update Block"
                EvidenceBlock --> UpdateEvidence(UPDATE candidateExpenseEvidence<br/>SET evidenceFile=@evidenceFile<br/>DtTm=GETDATE<br/>WHERE ExpenseID=@ExpenseID)
            end
            
            CheckEvidence -->|False| SkipEvidence(Skip Evidence Update)
            UpdateEvidence --> ReturnSuccess(SELECT 200 statuscode<br/>'Successfully Updated' Msg)
            SkipEvidence --> ReturnSuccess
            ReturnSuccess --> Commit(COMMIT TRANSACTION)
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
    class Input,MainBegin,UpdateMain,MainEnd process
    class CheckEvidence decision
    class ReturnSuccess success
    class CatchBegin,Rollback,ReturnError error
    class TryBegin,EvidenceBlock,UpdateEvidence,SkipEvidence,CatchEnd block
    class BeginTrans,Commit,Rollback transaction
```

## Business Logic

### Update Process:
1. **Main Record Update**: Updates all expenditure fields in candidateRegister
2. **Conditional Evidence Update**: Updates evidence file only if provided
3. **Timestamp Management**: Updates DtTm with current timestamp
4. **Transaction Safety**: Ensures atomic operations

### Date Conversion:
- **expDate**: Converted using format 111 (YYYY/MM/DD)
- **paymentDate**: Converted using format 101 (MM/DD/YYYY)

### Evidence File Handling:
- **Optional Update**: Only updates if @evidenceFile is not null
- **Separate Table**: Evidence stored in candidateExpenseEvidence
- **Timestamp Sync**: Updates evidence timestamp when modified

### Response Codes:
- **200**: Successfully Updated - Update completed
- **400**: System error with detailed error message

## Tables Modified
- `sec.candidateRegister` - Main expenditure record
- `sec.candidateExpenseEvidence` - Evidence file (conditional)

## Transaction Management
- **BEGIN TRANSACTION**: Ensures data consistency
- **COMMIT**: On successful completion
- **ROLLBACK**: On any error or exception
- **TRY-CATCH**: Comprehensive error handling

## Usage Context
This procedure is called when:
1. User edits existing expenditure entry
2. User updates evidence file for existing record
3. Corrections needed in expenditure data
4. Additional information becomes available

## Data Integrity Features
- **Atomic Updates**: Both tables updated in single transaction
- **Error Recovery**: Automatic rollback on failure
- **Timestamp Tracking**: Audit trail with modification time
- **Optional Fields**: Handles null values appropriately

## Security Considerations
- **ExpenseID Validation**: Updates only specified record
- **Transaction Isolation**: Prevents partial updates
- **Error Logging**: Detailed error information for debugging
- **Data Consistency**: Maintains referential integrity
