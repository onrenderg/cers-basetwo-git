# CERS Stored Procedure Flow Diagrams

## Complete Application Flow with Business Logic

```mermaid
flowchart TD
    A[Mobile App Start] --> B[User Login Request]
    
    B --> C[sec.Mobile_CERS_AppLogin]
    C --> D{Check Candidate Status}
    
    D -->|Invalid Contestant| E[Return 300: Invalid Contestant]
    D -->|Nomination Status != 'l'| F[Return 301: Invalid Nomination Status]
    D -->|Valid User| G[Return User Details]
    
    G --> H[Generate OTP Request]
    H --> I[sec.Mobile_CERS_SaveOtp_New]
    
    I --> J{Check OTP Rate Limit}
    J -->|>3 requests in 3 min| K[Return Rate Limit Error]
    J -->|Within Limit| L[Generate & Save OTP]
    
    L --> M[Send OTP to User]
    M --> N[User Enters OTP]
    N --> O[sec.Mobile_CERS_CheckOtp]
    
    O --> P{Validate OTP}
    P -->|Invalid/Expired| Q[sec.Mobile_CERS_CheckOtpAttempts]
    P -->|Valid| R[sec.mobile_bearer_token_get]
    
    Q --> S{Max Attempts Exceeded?}
    S -->|Yes| T[Block User]
    S -->|No| U[Allow Retry]
    
    R --> V[Generate Bearer Token]
    V --> W[User Dashboard]
    
    W --> X{User Type}
    X -->|Regular User| Y[Expenditure Flow]
    X -->|Observer| Z[Observer Flow]
    
    %% Styling
    classDef errorNode fill:#ffebee,stroke:#f44336
    classDef successNode fill:#e8f5e8,stroke:#4caf50
    classDef processNode fill:#e3f2fd,stroke:#2196f3
    classDef decisionNode fill:#fff3e0,stroke:#ff9800
    
    class E,F,K,T errorNode
    class G,L,V successNode
    class C,I,O,R processNode
    class D,J,P,S,X decisionNode
```

## Expenditure Management Flow

```mermaid
flowchart TD
    A[User Dashboard] --> B[Load Reference Data]
    
    B --> C[sec.Mobile_getPaymentModes]
    B --> D[sec.getExpenseSource]
    B --> E[sec.Mobile_getLocalResources]
    B --> F[sec.Mobile_getappversion]
    
    C --> G[Create New Expenditure]
    D --> G
    E --> G
    F --> G
    
    G --> H[Fill Expenditure Form]
    H --> I[sec.Mobile_saveData]
    
    I --> J{Validation Check}
    J -->|Invalid Data| K[Return Error Message]
    J -->|Valid Data| L[Save to Database]
    
    L --> M[sec.Mobile_updatesaveData]
    M --> N{Update Required?}
    N -->|Yes| O[Update Expenditure Details]
    N -->|No| P[Proceed to Final Save]
    
    O --> P
    P --> Q[sec.Mobile_finalsaveData]
    
    Q --> R{Check Poll Date}
    R -->|Before Poll Date| S[Return Error: Cannot submit before poll date]
    R -->|After Poll Date| T[Final Submission]
    
    T --> U[sec.Mobile_finalsaveDataNov23]
    U --> V[Mark as Submitted]
    V --> W[Generate PDF Documents]
    
    W --> X[sec.Mobile_getpdf]
    W --> Y[sec.Mobile_getpdfdecdata]
    
    %% Styling
    classDef refData fill:#f3e5f5,stroke:#9c27b0
    classDef saveProcess fill:#e8f5e8,stroke:#4caf50
    classDef validation fill:#fff3e0,stroke:#ff9800
    classDef pdfGen fill:#e1f5fe,stroke:#03a9f4
    
    class C,D,E,F refData
    class I,M,Q,U saveProcess
    class J,N,R validation
    class X,Y pdfGen
```

## Observer Workflow

```mermaid
flowchart TD
    A[Observer Login] --> B[sec.Mobile_CERS_ObservorLogin]
    
    B --> C{Observer Validation}
    C -->|Invalid Observer| D[Return Error]
    C -->|Valid Observer| E[Observer Dashboard]
    
    E --> F[sec.Mobile_getobserver_wards]
    F --> G[Display Ward List]
    
    G --> H[Select Ward]
    H --> I[sec.Mobile_getobserver_candidates]
    I --> J[Display Candidates]
    
    J --> K[Select Candidate]
    K --> L[sec.Mobile_getsaveData_observer]
    L --> M[Display Expenditure Data]
    
    M --> N[sec.Mobile_getremarks]
    N --> O[Display Existing Remarks]
    
    O --> P[Add/Update Remarks]
    P --> Q[sec.Mobile_updateobserverremarks]
    
    Q --> R{Validation}
    R -->|Invalid| S[Return Error]
    R -->|Valid| T[Save Remarks]
    
    T --> U[Update Status]
    U --> V[Generate Observer Report]
    
    %% Styling
    classDef observerProcess fill:#e8f5e8,stroke:#4caf50
    classDef dataRetrieval fill:#e3f2fd,stroke:#2196f3
    classDef validation fill:#fff3e0,stroke:#ff9800
    
    class B,F,I,L,N,Q observerProcess
    class G,J,M,O dataRetrieval
    class C,R validation
```

## OTP Management Flow

```mermaid
flowchart TD
    A[OTP Request] --> B[sec.Mobile_CERS_SaveOtp_New]
    
    B --> C{Rate Limit Check}
    C -->|Count Requests in Last 3 Min| D{> 3 Requests?}
    
    D -->|Yes| E[Return Rate Limit Error]
    D -->|No| F[Generate Random OTP]
    
    F --> G[Save OTP with Timestamp]
    G --> H[Send SMS/Email]
    H --> I[sec.Mobile_CERS_updateOTPresponse]
    
    I --> J[Log SMS Response]
    J --> K[User Enters OTP]
    K --> L[sec.Mobile_CERS_CheckOtp]
    
    L --> M{Validate OTP}
    M -->|Check Expiry| N{Within 5 Minutes?}
    M -->|Check Value| O{Correct OTP?}
    
    N -->|Expired| P[Return Expired Error]
    O -->|Incorrect| Q[sec.Mobile_CERS_CheckOtpAttempts]
    
    Q --> R{Count Failed Attempts}
    R -->|> Max Attempts| S[Block User Temporarily]
    R -->|Within Limit| T[Allow Retry]
    
    N -->|Valid Time| U{Correct OTP?}
    U -->|Yes| V[Mark OTP as Used]
    U -->|No| Q
    
    V --> W[Generate Session Token]
    W --> X[Login Success]
    
    %% Styling
    classDef otpProcess fill:#e8f5e8,stroke:#4caf50
    classDef validation fill:#fff3e0,stroke:#ff9800
    classDef error fill:#ffebee,stroke:#f44336
    classDef success fill:#e8f5e8,stroke:#4caf50
    
    class B,F,G,I,L otpProcess
    class C,D,M,N,O,R,U validation
    class E,P,S error
    class V,W,X success
```

## Data Validation & Business Rules

```mermaid
flowchart TD
    A[Data Input] --> B{Input Validation}
    
    B --> C[Check Required Fields]
    B --> D[Validate Data Types]
    B --> E[Check Business Rules]
    
    C --> F{All Required Fields Present?}
    D --> G{Valid Data Formats?}
    E --> H{Business Rules Met?}
    
    F -->|No| I[Return Missing Field Error]
    G -->|No| J[Return Format Error]
    H -->|No| K[Return Business Rule Error]
    
    F -->|Yes| L[Field Validation Passed]
    G -->|Yes| M[Format Validation Passed]
    H -->|Yes| N[Business Rule Validation Passed]
    
    L --> O[Proceed to Database Operations]
    M --> O
    N --> O
    
    O --> P{Database Transaction}
    P -->|Success| Q[Commit Transaction]
    P -->|Error| R[Rollback Transaction]
    
    Q --> S[Return Success Response]
    R --> T[Return Database Error]
    
    %% Business Rules Examples
    U[Business Rules Examples:] --> V[Poll Date Validation]
    U --> W[Amount Range Checks]
    U --> X[User Status Verification]
    U --> Y[Nomination Status Checks]
    
    %% Styling
    classDef validation fill:#fff3e0,stroke:#ff9800
    classDef error fill:#ffebee,stroke:#f44336
    classDef success fill:#e8f5e8,stroke:#4caf50
    classDef info fill:#e3f2fd,stroke:#2196f3
    
    class B,C,D,E,F,G,H validation
    class I,J,K,R,T error
    class L,M,N,Q,S success
    class U,V,W,X,Y info
```

## Key Business Logic Insights

### Authentication Flow
- **Rate Limiting**: Maximum 3 OTP requests per 3 minutes per mobile number
- **OTP Expiry**: OTPs expire after 5 minutes
- **Attempt Limiting**: Failed OTP attempts are tracked and users can be temporarily blocked
- **Candidate Validation**: Users must have valid nomination status ('l') to login

### Expenditure Management
- **Poll Date Restriction**: Final submissions only allowed after poll date
- **Data Validation**: Multiple validation layers for expenditure data
- **File Attachments**: Support for evidence file uploads (Base64 encoded)
- **Audit Trail**: All changes are tracked with timestamps and user information

### Observer Workflow
- **Hierarchical Access**: Observers can only view wards assigned to them
- **Candidate Filtering**: Ward-based candidate filtering for focused review
- **Remark System**: Comprehensive remark and approval system
- **Status Tracking**: Real-time status updates for expenditure reviews

### Data Integrity
- **Transaction Management**: All critical operations use database transactions
- **Error Handling**: Comprehensive error handling with specific error codes
- **Logging**: Detailed logging for audit and debugging purposes
- **Rollback Capability**: Failed operations are properly rolled back to maintain data consistency
