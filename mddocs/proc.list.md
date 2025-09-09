

Based on my analysis of the CERS Web API codebase, here are all the stored procedures that are called throughout the application:

## Complete List of Stored Procedures in CERS Web API

### Authentication & User Management
1. **`sec.Mobile_CERS_AppLogin`** - User login authentication
2. **`sec.Mobile_CERS_ObservorLogin`** - Observer login authentication
3. **`sec.Mobile_CERS_SaveOtp`** - Save OTP for verification
4. **`sec.Mobile_CERS_SaveOtp_New`** - Save OTP (new version)
5. **`sec.Mobile_CERS_CheckOtp`** - Verify OTP
6. **`sec.Mobile_CERS_CheckOtpAttempts`** - Check OTP attempt count
7. **`sec.Mobile_CERS_updateOTPresponse`** - Update OTP response
8. **`sec.Mobile_getusertype`** - Get user type information
9. **`sec.mobile_bearer_token_get`** - Generate bearer token

### Expenditure Management
10. **`sec.Mobile_saveData`** - Save expenditure data
11. **`sec.Mobile_updatesaveData`** - Update expenditure data
12. **`sec.Mobile_finalsaveData`** - Final save of expenditure data
13. **`sec.Mobile_finalsaveDataNov23`** - Final save (November 2023 version)
14. **`sec.Mobile_getsaveData`** - Get saved expenditure data
15. **`sec.Mobile_getsaveData_observer`** - Get expenditure data for observer

### Observer Functions
16. **`sec.Mobile_getobserver_wards`** - Get observer wards
17. **`sec.Mobile_getobserver_candidates`** - Get observer candidates
18. **`sec.Mobile_updateobserverremarks`** - Update observer remarks
19. **`sec.Mobile_getremarks`** - Get remarks/comments

### Reference Data
20. **`sec.Mobile_getPaymentModes`** - Get payment modes
21. **`sec.getExpenseSource`** - Get expense sources
22. **`sec.Mobile_getLocalResources`** - Get local resources

### PDF & Document Management
23. **`sec.Mobile_getpdf`** - Get PDF documents
24. **`sec.Mobile_getpdfdecdata`** - Get PDF declaration data

### App Management
25. **`sec.Mobile_getappversion`** - Get application version information

## Schema Information
All stored procedures are in the **`sec`** schema, indicating they are part of the security/application layer of the database.

## Usage Patterns
- Most procedures follow the naming convention `Mobile_[Action][Entity]`
- Procedures are called through the `DBAccess` class methods (`getDBData`, `getDBDataSet`)
- The application uses both single connection (`DBConn`) and alternative connection (`DBConn1`) strings
- Parameters are passed using `SqlParameter` objects with `@` prefix

This comprehensive list includes all stored procedures referenced in the CERS Web API codebase across Controllers, ASPX pages, and the data access layer.

## Stored Procedure Flow Diagram

```mermaid
flowchart TD
    A[Mobile App Start] --> B{User Type?}
    
    B -->|Regular User| C[sec.Mobile_getusertype]
    B -->|Observer| D[sec.Mobile_getusertype]
    
    C --> E[sec.Mobile_CERS_AppLogin]
    D --> F[sec.Mobile_CERS_ObservorLogin]
    
    E --> G[Generate OTP]
    F --> G
    
    G --> H[sec.Mobile_CERS_SaveOtp_New]
    H --> I[sec.Mobile_CERS_CheckOtpAttempts]
    I --> J[sec.Mobile_CERS_CheckOtp]
    
    J -->|Success| K[sec.mobile_bearer_token_get]
    J -->|Failed| L[sec.Mobile_CERS_updateOTPresponse]
    L --> G
    
    K --> M{User Role}
    
    M -->|Regular User| N[User Dashboard]
    M -->|Observer| O[Observer Dashboard]
    
    %% Regular User Flow
    N --> P[sec.Mobile_getPaymentModes]
    N --> Q[sec.getExpenseSource]
    N --> R[sec.Mobile_getLocalResources]
    N --> S[sec.Mobile_getappversion]
    
    P --> T[Create Expenditure]
    Q --> T
    R --> T
    
    T --> U[sec.Mobile_saveData]
    U --> V[sec.Mobile_updatesaveData]
    V --> W[sec.Mobile_finalsaveData]
    W --> X[sec.Mobile_finalsaveDataNov23]
    
    %% Observer Flow
    O --> Y[sec.Mobile_getobserver_wards]
    Y --> Z[sec.Mobile_getobserver_candidates]
    Z --> AA[sec.Mobile_getsaveData_observer]
    AA --> BB[sec.Mobile_getremarks]
    BB --> CC[sec.Mobile_updateobserverremarks]
    
    %% PDF Generation Flow
    W --> DD[Generate PDF]
    X --> DD
    CC --> DD
    
    DD --> EE[sec.Mobile_getpdf]
    DD --> FF[sec.Mobile_getpdfdecdata]
    
    %% Data Retrieval
    N --> GG[View Data]
    O --> GG
    GG --> HH[sec.Mobile_getsaveData]
    
    %% Styling
    classDef authProc fill:#e1f5fe
    classDef expProc fill:#f3e5f5
    classDef obsProc fill:#e8f5e8
    classDef pdfProc fill:#fff3e0
    classDef refProc fill:#fce4ec
    
    class H,I,J,L,K authProc
    class U,V,W,X,HH expProc
    class Y,Z,AA,BB,CC obsProc
    class EE,FF pdfProc
    class P,Q,R,S refProc
```

## Process Flow Description

### 1. Authentication Flow
- User opens app → Check user type → Login (App/Observer) → Generate OTP → Verify OTP → Get Bearer Token

### 2. Regular User Flow
- Dashboard → Load reference data (Payment modes, Expense sources, Local resources) → Create expenditure → Save → Update → Final submit

### 3. Observer Flow  
- Dashboard → Get observer wards → Get candidates → View expenditure data → Add/Update remarks

### 4. PDF Generation Flow
- Triggered after final submission or observer review → Generate PDF documents and declaration data

### 5. Data Management Flow
- Continuous data retrieval and updates throughout the application lifecycle