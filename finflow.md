# CERS Complete System Architecture & Flow

## System Overview

The CERS (Candidate Election Reporting System) consists of three main components:
1. **Mobile App (CERS)** - .NET MAUI cross-platform application
2. **Web API (CERSWebApi)** - ASP.NET Web API backend
3. **Database Layer** - SQL Server with stored procedures

## Complete System Architecture

```mermaid
graph TB
    subgraph "Mobile Application Layer"
        A[CERS Mobile App]
        A1[LoginPage.xaml]
        A2[DashboardPage.xaml]
        A3[AddExpenditureDetailsPage.xaml]
        A4[EditExpenditureDetailsPage.xaml]
        A5[ViewExpenditureDetailsPage.xaml]
        A6[Observer Pages]
        
        A --> A1
        A --> A2
        A --> A3
        A --> A4
        A --> A5
        A --> A6
    end
    
    subgraph "Service Layer"
        B[HitServices.cs]
        B1[HTTP Client]
        B2[Authentication]
        B3[Data Serialization]
        B4[Local Database]
        
        B --> B1
        B --> B2
        B --> B3
        B --> B4
    end
    
    subgraph "Web API Layer"
        C[CERSWebApi]
        C1[UserLoginController]
        C2[ExpenditureDetailsController]
        C3[ObserverController]
        C4[GetOTPController]
        C5[CheckOtpController]
        C6[GenerateTokenController]
        
        C --> C1
        C --> C2
        C --> C3
        C --> C4
        C --> C5
        C --> C6
    end
    
    subgraph "Data Access Layer"
        D[DBAccess.cs]
        D1[getDBData]
        D2[getDBDataSet]
        D3[Connection Management]
        
        D --> D1
        D --> D2
        D --> D3
    end
    
    subgraph "Database Layer"
        E[SQL Server Database]
        E1[sec.Mobile_CERS_AppLogin]
        E2[sec.Mobile_saveData]
        E3[sec.Mobile_CERS_SaveOtp_New]
        E4[sec.Mobile_CERS_CheckOtp]
        E5[sec.mobile_bearer_token_get]
        E6[25+ Stored Procedures]
        
        E --> E1
        E --> E2
        E --> E3
        E --> E4
        E --> E5
        E --> E6
    end
    
    A1 --> B
    A2 --> B
    A3 --> B
    A4 --> B
    A5 --> B
    A6 --> B
    
    B --> C
    C --> D
    D --> E
    
    style A fill:#e3f2fd
    style B fill:#f3e5f5
    style C fill:#e8f5e8
    style D fill:#fff3e0
    style E fill:#fce4ec
```

## Complete User Journey Flow

```mermaid
flowchart TD
    Start[User Opens CERS App] --> Login[LoginPage.xaml]
    
    Login --> MobileEntry[Enter Mobile Number]
    MobileEntry --> GetOTP[btn_getotp_Clicked]
    
    GetOTP --> HitService1[HitServices.CheckUserType_Get]
    HitService1 --> API1[UserLoginController/CheckUserType]
    API1 --> SP1[sec.Mobile_getusertype]
    
    SP1 --> UserType{User Type Response}
    UserType -->|Valid User| GetOTPAPI[GetOTPController]
    UserType -->|Observer| ObserverLogin[ObserverLoginController]
    
    GetOTPAPI --> SP2[sec.Mobile_CERS_SaveOtp_New]
    SP2 --> OTPSent[OTP Sent to Mobile]
    
    OTPSent --> EnterOTP[User Enters OTP]
    EnterOTP --> VerifyOTP[btn_submitotp_Clicked]
    
    VerifyOTP --> HitService2[HitServices.CheckOtp]
    HitService2 --> API2[CheckOtpController]
    API2 --> SP3[sec.Mobile_CERS_CheckOtp]
    
    SP3 --> OTPValid{OTP Valid?}
    OTPValid -->|Yes| TokenGen[GenerateTokenController]
    OTPValid -->|No| OTPError[Show Error & Retry]
    
    TokenGen --> SP4[sec.mobile_bearer_token_get]
    SP4 --> Dashboard[Navigate to DashboardPage.xaml]
    
    Dashboard --> LoadData[Load Dashboard Data]
    LoadData --> RefData[Load Reference Data]
    
    RefData --> PayModes[HitServices.PaymentModes_Get]
    RefData --> ExpSources[HitServices.ExpenseSources_Get]
    RefData --> LocalRes[HitServices.LocalResources_Get]
    
    PayModes --> SP5[sec.Mobile_getPaymentModes]
    ExpSources --> SP6[sec.getExpenseSource]
    LocalRes --> SP7[sec.Mobile_getLocalResources]
    
    Dashboard --> UserAction{User Action}
    
    UserAction -->|Add Expenditure| AddExp[AddExpenditureDetailsPage.xaml]
    UserAction -->|Edit Expenditure| EditExp[EditExpenditureDetailsPage.xaml]
    UserAction -->|View Expenditure| ViewExp[ViewExpenditureDetailsPage.xaml]
    
    AddExp --> SaveData[btn_savedata_Clicked]
    SaveData --> HitService3[HitServices.SaveExpenditureDetails]
    HitService3 --> API3[ExpenditureDetailsController]
    API3 --> SP8[sec.Mobile_saveData]
    
    SP8 --> UpdateData[Update if needed]
    UpdateData --> SP9[sec.Mobile_updatesaveData]
    
    SP9 --> FinalSave[Final Submission]
    FinalSave --> SP10[sec.Mobile_finalsaveData]
    SP10 --> SP11[sec.Mobile_finalsaveDataNov23]
    
    SP11 --> PDFGen[Generate PDF]
    PDFGen --> SP12[sec.Mobile_getpdf]
    PDFGen --> SP13[sec.Mobile_getpdfdecdata]
    
    style Start fill:#e3f2fd
    style Login fill:#f3e5f5
    style Dashboard fill:#e8f5e8
    style AddExp fill:#fff3e0
    style SaveData fill:#fce4ec
```

## Observer Workflow

```mermaid
flowchart TD
    ObsLogin[Observer Login] --> ObsAuth[ObserverLoginController]
    ObsAuth --> SP_Obs1[sec.Mobile_CERS_ObservorLogin]
    
    SP_Obs1 --> ObsDash[ObserverDashboardPage.xaml]
    ObsDash --> GetWards[Load Observer Wards]
    
    GetWards --> HitObs1[HitServices.ObserverWards_Get]
    HitObs1 --> SP_Obs2[sec.Mobile_getobserver_wards]
    
    SP_Obs2 --> SelectWard[Select Ward]
    SelectWard --> GetCandidates[Load Candidates]
    
    GetCandidates --> HitObs2[HitServices.ObserverCandidates_Get]
    HitObs2 --> SP_Obs3[sec.Mobile_getobserver_candidates]
    
    SP_Obs3 --> SelectCandidate[Select Candidate]
    SelectCandidate --> ViewExpData[ObserverViewExpenditureDetailsPage.xaml]
    
    ViewExpData --> LoadExpData[Load Expenditure Data]
    LoadExpData --> HitObs3[HitServices.ObserverExpenditureDetails_Get]
    HitObs3 --> SP_Obs4[sec.Mobile_getsaveData_observer]
    
    SP_Obs4 --> ViewRemarks[Load Existing Remarks]
    ViewRemarks --> HitObs4[HitServices.ViewAllRemarks_Get]
    HitObs4 --> SP_Obs5[sec.Mobile_getremarks]
    
    SP_Obs5 --> AddRemarks[Add/Update Remarks]
    AddRemarks --> HitObs5[HitServices.UpdateObserverRemarks]
    HitObs5 --> SP_Obs6[sec.Mobile_updateobserverremarks]
    
    style ObsLogin fill:#e3f2fd
    style ObsDash fill:#f3e5f5
    style ViewExpData fill:#e8f5e8
    style AddRemarks fill:#fff3e0
```

## Data Flow Architecture

```mermaid
flowchart LR
    subgraph "Mobile App Data Layer"
        MA[Local SQLite Database]
        MA1[ExpenditureDetailsDatabase]
        MA2[UserDetailsDatabase]
        MA3[PaymentModesDatabase]
        MA4[ExpenseSourcesDatabase]
        MA5[ObserverWardsDatabase]
        
        MA --> MA1
        MA --> MA2
        MA --> MA3
        MA --> MA4
        MA --> MA5
    end
    
    subgraph "API Communication"
        HTTP[HTTP Requests]
        JSON[JSON Serialization]
        AUTH[Bearer Token Auth]
        
        HTTP --> JSON
        HTTP --> AUTH
    end
    
    subgraph "Server Database"
        SQL[SQL Server]
        TABLES[Database Tables]
        SP[Stored Procedures]
        
        SQL --> TABLES
        SQL --> SP
    end
    
    MA <--> HTTP
    HTTP <--> SQL
    
    style MA fill:#e3f2fd
    style HTTP fill:#f3e5f5
    style SQL fill:#e8f5e8
```

## Security & Authentication Flow

```mermaid
sequenceDiagram
    participant App as Mobile App
    participant API as Web API
    participant DB as Database
    participant SMS as SMS Service
    
    App->>API: CheckUserType with MobileNo
    API->>DB: sec.Mobile_getusertype
    DB-->>API: User Type Response
    API-->>App: User Validation Result
    
    App->>API: GetOTP with MobileNo
    API->>DB: sec.Mobile_CERS_SaveOtp_New
    DB-->>API: OTP Generated
    API->>SMS: Send OTP
    SMS-->>App: OTP Received
    
    App->>API: VerifyOTP with MobileNo and OTP
    API->>DB: sec.Mobile_CERS_CheckOtp
    DB-->>API: OTP Validation Result
    
    alt OTP Valid
        API->>DB: sec.mobile_bearer_token_get
        DB-->>API: Bearer Token
        API-->>App: Authentication Success + Token
    else OTP Invalid
        API->>DB: sec.Mobile_CERS_CheckOtpAttempts
        DB-->>API: Attempt Count
        API-->>App: Authentication Failed
    end
    
    App->>API: Subsequent Requests with Bearer Token
    API-->>App: Authorized Response
```

## Key Components Mapping

### Mobile App Components
- **Pages**: LoginPage, DashboardPage, AddExpenditureDetailsPage, EditExpenditureDetailsPage, ViewExpenditureDetailsPage
- **Observer Pages**: ObserverDashboardPage, ExpenditureDateTypewiselistPage, ObserverViewExpenditureDetailsPage
- **Models**: ExpenditureDetails, UserDetails, PaymentModes, ExpenseSources, ObserverWards, etc.
- **Database Classes**: All models have corresponding Database classes for local SQLite operations
- **Services**: HitServices.cs handles all API communications

### Web API Components
- **Controllers**: 21 controllers handling different functionalities
- **Data Access**: DBAccess.cs provides centralized database operations
- **Authentication**: Token-based authentication with OTP verification
- **File Handling**: Support for evidence file uploads and PDF generation

### Database Components
- **25 Stored Procedures** in the `sec` schema
- **Business Logic**: Embedded in stored procedures for data validation and processing
- **Security**: Role-based access control and data encryption
- **Audit Trail**: Comprehensive logging and tracking mechanisms

## Technology Stack

### Mobile App (CERS)
- **.NET MAUI** - Cross-platform framework
- **XAML** - UI markup language
- **SQLite** - Local database storage
- **Newtonsoft.Json** - JSON serialization
- **HttpClient** - API communication

### Web API (CERSWebApi)
- **ASP.NET Web API** - RESTful web services
- **SQL Server** - Primary database
- **Entity Framework** - Data access (implied)
- **JSON** - Data exchange format
- **IIS** - Web server hosting

### Database
- **SQL Server** - Relational database management system
- **Stored Procedures** - Business logic implementation
- **Triggers** - Data integrity and audit trails
- **Views** - Data presentation layer
- **Functions** - Reusable database logic

## Deployment Architecture

```mermaid
graph TB
    subgraph "Client Devices"
        Android[Android App]
        iOS[iOS App]
        Windows[Windows App]
    end
    
    subgraph "Network Layer"
        Internet[Internet/Intranet]
        LoadBalancer[Load Balancer]
    end
    
    subgraph "Application Server"
        IIS[IIS Web Server]
        WebAPI[CERS Web API]
        AppPool[Application Pool]
    end
    
    subgraph "Database Server"
        SQLServer[SQL Server]
        StoredProcs[Stored Procedures]
        DatabaseFiles[Database Files]
    end
    
    subgraph "External Services"
        SMSGateway[SMS Gateway]
        EmailService[Email Service]
    end
    
    Android --> Internet
    iOS --> Internet
    Windows --> Internet
    
    Internet --> LoadBalancer
    LoadBalancer --> IIS
    IIS --> WebAPI
    WebAPI --> AppPool
    
    WebAPI --> SQLServer
    SQLServer --> StoredProcs
    SQLServer --> DatabaseFiles
    
    WebAPI --> SMSGateway
    WebAPI --> EmailService
    
    style Android fill:#a5d6a7
    style iOS fill:#a5d6a7
    style Windows fill:#a5d6a7
    style WebAPI fill:#ffcc80
    style SQLServer fill:#f8bbd9
```

## Performance & Scalability Considerations

### Mobile App Optimizations
- **Local Caching**: SQLite database for offline functionality
- **Lazy Loading**: Data loaded on demand
- **Image Compression**: Evidence files compressed before upload
- **Background Sync**: Data synchronization when network available

### API Optimizations
- **Connection Pooling**: Efficient database connection management
- **Caching**: Frequently accessed data cached in memory
- **Compression**: Response compression for reduced bandwidth
- **Rate Limiting**: OTP request limiting to prevent abuse

### Database Optimizations
- **Indexing**: Proper indexing on frequently queried columns
- **Stored Procedures**: Pre-compiled execution plans
- **Transaction Management**: ACID compliance with proper rollback
- **Partitioning**: Large tables partitioned for better performance

This comprehensive flow diagram represents the complete CERS system architecture, showing how all three components (Mobile App, Web API, and Database) work together to provide a robust candidate election reporting system.
