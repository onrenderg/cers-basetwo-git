# CERS (Candidate Expenditure Reporting System) - Complete System Flow Documentation

## System Overview
CERS is a comprehensive mobile application system for tracking and monitoring election expenditure by candidates, agents, and observers. The system consists of:
- **Mobile App (MAUI)**: Cross-platform mobile application for candidates/agents and observers
- **Web API**: ASP.NET Web API backend for data processing and storage
- **Database**: SQL Server with stored procedures for data management

---

# 1. CANDIDATE/AGENT LOGIN FLOW

## 1.1 Initial Login Process
### @MobileUI: LoginPage.xaml - Mobile Number Entry
1. User enters mobile number on `LoginPage.xaml`
2. Input validation: 10-digit number starting with 6,7,8,9

### @MobileLogic: btn_getotp_Clicked() Event Handler in LoginPage.xaml.cs
#### API Call 1: Check User Type
- **Endpoint**: `baseurl + "api/CheckUserType?MobileNo={encrypted_mobile}"`
- **@WebApi**: `CheckUserTypeController.cs`
  1. **Controller**: `CheckUserTypeController.cs` calls stored procedure `sec.Mobile_getusertype @MobileNo='number'`
  2. **Decryption**: Mobile number decrypted using `AESCryptography.DecryptAES()`
  3. **Return Value**: UserType = "Candidate", "Agent", or "Observor"
  4. **Response**: HTTP Status Code (200=success, 404=not found)

#### API Call 2: User Login
- **Endpoint**: `"api/UserLogin?MobileNo={encrypted_mobile}"`
- **@WebApi**: `UserLoginController.cs`
  1. **Controller**: `UserLoginController.cs` calls stored procedure `sec.Mobile_CERS_AppLogin @MobileNo='mobile_number'`
  2. **Return Value**: 2 DataTables
     - **Table 1**: statuscode: 200, Msg: "Successfully Logged In"
     - **Table 2**: Complete candidate profile including AUTO_ID, CONSTITUENCY_CODE, EPIC_NO, VOTER_NAME, etc.
  3. **@mobile_app Local Storage**: `UserDetailsDatabase.AddUserDetails()` - stores user profile locally

#### API Call 3: Generate OTP
- **Endpoint**: `baseurl + "api/GetOtp?MobileNo={encrypted_mobile}"`
- **@WebApi**: `GetOTPController.cs`
  1. **Controller**: `GetOTPController.cs` calls stored procedure `[sec].[Mobile_CERS_SaveOtp_New]`
  2. **Authentication**: Bearer Token (in production)
  3. **OTP Generation**: Random 6-digit OTP (currently fixed as "123456" for testing)
  4. **SMS Service**: Sends OTP via SMS using `SendOtpSms.sendSingleSMS()`
  5. **Return**: OTP sent via SMS, OTPID returned encrypted

#### API Call 4: Verify OTP
- **Endpoint**: `baseurl + "api/CheckOtp?MobileNo={encrypted_mobile}&UserOtp={otp}&otpId={otpId}"`
- **@WebApi**: `CheckOtpController.cs`
  1. **Controller**: `CheckOtpController.cs` calls stored procedure `sec.Mobile_CERS_CheckOtp`
  2. **Parameters**: Decrypted mobile number, OTP, and OTP ID
  3. **Return**: HTTP Status Code (200=valid, 300=invalid)
  4. **Navigation**: 
     - If valid → User verification popup → `DashboardPage.xaml`
     - If invalid → Remains on `LoginPage.xaml`

---

# 2. CANDIDATE/AGENT DASHBOARD INITIALIZATION FLOW

## 2.1 Dashboard Loading Process
### @MobileUI: DashboardPage.xaml
- Main dashboard interface with expenditure summary and navigation tabs

### @MobileLogic: DashboardPage.xaml.cs OnAppearing Event
1. **User Details Loading**: Retrieves user profile from local database
2. **Expenditure Summary Calculation**: 
   - Query: `"Select sum(amount)Totalamount from ExpenditureDetails"`
   - Displays total expenditure amount
3. **Expenditure Type-wise Data Loading**:
   - Groups expenditures by expense type (`expCode`)
   - Shows localized expense type names based on language preference
4. **Form Submission Status Check**:
   - Checks for finalized expenditures (`ExpStatus='F'`)
   - Controls visibility of final submission button
5. **Date Validation**: Verifies if within 30 days of result date for submissions

## 2.2 Additional Data Loading APIs
### API Call: Expense Sources
- **Endpoint**: `"api/ExpenseSource"`
- **Purpose**: Loads available expense categories for dropdown selection

### API Call: Payment Modes
- **Endpoint**: `"api/PaymentMode"`  
- **Purpose**: Loads payment method options (Cash, Cheque, Online, etc.)

### API Call: Expenditure Details
- **Endpoint**: `"api/ExpenditureDetails"`
- **Purpose**: Retrieves all existing expenditure entries for the user

---

# 3. EXPENDITURE MANAGEMENT FLOW

## 3.1 Add New Expenditure
### @MobileUI: AddExpenditureDetailsPage.xaml
- Form interface for entering expenditure details with validation

### @MobileLogic: AddExpenditureDetailsPage.xaml.cs
#### Form Fields and Validation:
1. **Expenditure Date**: Date picker with validation
2. **Expenditure Type**: Searchable dropdown from expense sources
3. **Amount**: Numeric input with currency validation
4. **Outstanding Amount**: Default 0, numeric validation
5. **Payment Date**: Date picker validation
6. **Voucher/Bill Number**: Text input, required
7. **Payment Mode**: Dropdown selection
8. **Payee Name**: Text input, required
9. **Payee Address**: Text input, required
10. **Source of Money**: Text input, required
11. **Remarks**: Optional text input
12. **Evidence File**: PDF/Image upload capability

#### API Call: Save Expenditure
- **Endpoint**: `"api/AddExpenditure"` (POST)
- **@WebApi**: `AddExpenditureController.cs`
  1. **Controller**: `AddExpenditureController.cs` calls stored procedure `sec.Mobile_saveData`
  2. **Data Processing**: All form fields encrypted/decrypted using AES
  3. **File Upload**: Handles evidence file upload if provided
  4. **Return**: ExpenseID and status message
  5. **Local Storage**: Updates local expenditure database

## 3.2 Edit Expenditure
### @MobileUI: EditExpenditureDetailsPage.xaml
- Pre-populated form for editing existing expenditures

### @MobileLogic: Similar to Add flow with update API call
- **Endpoint**: `"api/UpdateExpenditure"` (POST)
- **Restriction**: Only non-finalized expenditures can be edited

## 3.3 View Expenditures
### @MobileUI: ViewExpenditureDetailsPage.xaml
- List view of all expenditures with filtering options
- Shows expenditure status, observer remarks, and edit options

---

# 4. OBSERVER LOGIN FLOW

## 4.1 Observer Authentication
### @MobileLogic: LoginPage.xaml.cs - Observer Path
#### When UserType = "Observor":

#### API Call 1: Observer Login
- **Endpoint**: `"api/ObservorLogin?MobileNo={encrypted_mobile}"`
- **@WebApi**: `ObservorLoginController.cs`
  1. **Controller**: Calls stored procedure for observer authentication
  2. **Return**: Observer profile with designation and assigned wards

#### API Call 2: OTP Generation (Same as Candidate)
- Uses same OTP generation process

#### API Call 3: OTP Verification
- **Navigation**: If valid → `ObserverDashboardPage.xaml`
- **Additional API**: `ObserverWards_Get()` - Retrieves assigned ward list

---

# 5. OBSERVER DASHBOARD FLOW

## 5.1 Observer Dashboard Initialization
### @MobileUI: ObserverDashboardPage.xaml
- Ward selection interface and candidate expenditure monitoring

### @MobileLogic: ObserverDashboardPage.xaml.cs
1. **Observer Profile Display**: Shows name, designation, and contact
2. **Ward Selection**: Dropdown of assigned wards/panchayats
3. **Candidate List Loading**: Shows candidates in selected ward

#### API Call: Observer Wards
- **Endpoint**: `"api/ObserverWards?MobileNo={encrypted_mobile}"`
- **@WebApi**: `ObserverWardsController.cs`
- **Purpose**: Retrieves list of wards assigned to observer

#### API Call: Observer Candidates
- **Endpoint**: `"api/ObserverCandidates?PanchayatCode={code}"`
- **@WebApi**: `ObserverCandidatesController.cs`
- **Purpose**: Gets candidate list for selected ward with expenditure summaries

## 5.2 Expenditure Monitoring
### @MobileUI: ExpenditureDateTypewiselistPage.xaml
- Detailed view of candidate expenditures with date and type filtering

#### API Call: Expenditure Details for Observer
- **Endpoint**: `"api/ExpenditureDetailsObserver"`
- **@WebApi**: `ExpenditureDetailsObserverController.cs`
- **Purpose**: Retrieves detailed expenditure data for monitoring

## 5.3 Observer Remarks Management
#### API Call: Add Observer Remarks
- **Endpoint**: `"api/AddObserverRemarks"` (POST)
- **@WebApi**: `AddObserverRemarksController.cs`
- **Purpose**: Allows observers to add remarks on expenditures

#### API Call: View Remarks
- **Endpoint**: `"api/ViewRemarks"`
- **@WebApi**: `ViewRemarksController.cs`
- **Purpose**: Retrieves existing remarks and candidate responses

---

# 6. SYSTEM ADMINISTRATION FLOWS

## 6.1 Authentication & Security
### Bearer Token Authentication
- All API endpoints (except debug mode) require Bearer token
- **Endpoint**: `"api/GenerateToken"`
- **@WebApi**: `GenerateTokenController.cs`

### AES Encryption
- All sensitive data encrypted using `AESCryptography` class
- Mobile numbers, personal details, and amounts encrypted in transit

## 6.2 Localization Support
### Multi-language Support
- **Endpoint**: `"api/LocalResources"`
- **@WebApi**: `LocalResourcesController.cs`
- **Purpose**: Provides localized text for UI elements
- **Languages**: English (default) and local language support

## 6.3 Version Control
### App Version Management
- **Endpoint**: `"api/AppVersion"`
- **@WebApi**: `AppVersionController.cs`
- **Purpose**: Checks for app updates and compatibility

---

# 7. DATA SYNCHRONIZATION FLOW

## 7.1 Local Database Management
### SQLite Local Storage:
1. **UserDetailsDatabase**: Stores user profile and authentication status
2. **ExpenditureDetailsDatabase**: Local cache of expenditure data
3. **ExpenseSourcesDatabase**: Expense categories cache
4. **PaymentModesDatabase**: Payment methods cache
5. **ObserverWardsDatabase**: Observer ward assignments
6. **ObserverCandidatesDatabase**: Candidate data for observers

## 7.2 Sync Operations
### Data Refresh Flow:
1. **Pull Latest Data**: Refresh button triggers API calls to update local cache
2. **Offline Capability**: App functions with local data when offline
3. **Sync on Connection**: Automatic sync when network becomes available

---

# 8. FINAL SUBMISSION FLOW

## 8.1 Declaration Generation
### @MobileUI: Form 46 Declaration
- **Navigation**: Dashboard → Declaration Button
- **Endpoint**: Web view loads declaration form from server
- **URL**: `baseurl + "FinalSubmitExpenditure.aspx"`

## 8.2 PDF Generation
### Server-side PDF Creation:
- **Endpoint**: `"GetDeclarationPdf.aspx"`
- **Process**: Generates PDF declaration with all expenditure details
- **Tools**: Uses wkhtmltopdf for PDF conversion

---

# 9. ERROR HANDLING & VALIDATION

## 9.1 Client-side Validation
### Input Validation:
1. **Mobile Number**: 10 digits, starts with 6/7/8/9
2. **OTP**: 6 digits, numeric only
3. **Amount**: Numeric, positive values
4. **Dates**: Valid date format, logical date ranges
5. **Required Fields**: All mandatory fields validated

## 9.2 Server-side Error Handling
### API Response Structure:
```json
{
  "status_code": 200,
  "Message": "Success message",
  "developer_message": "Technical details",
  "data": "Response data"
}
```

### Common Status Codes:
- **200**: Success
- **300**: Invalid data/OTP
- **404**: Record not found
- **500**: Server error

---

# 10. SECURITY MEASURES

## 10.1 Data Protection
1. **AES Encryption**: All sensitive data encrypted
2. **Bearer Token**: API authentication
3. **SQL Injection Prevention**: Parameterized queries
4. **Input Sanitization**: Server-side validation

## 10.2 Access Control
1. **Role-based Access**: Candidate/Agent/Observer specific features
2. **Session Management**: OTP-based authentication
3. **Data Isolation**: Users can only access their own data

---

# 11. TECHNICAL ARCHITECTURE

## 11.1 Mobile App Stack
- **Framework**: .NET MAUI (Multi-platform App UI)
- **Language**: C#
- **Local Storage**: SQLite
- **UI**: XAML-based responsive design

## 11.2 Backend Stack
- **Framework**: ASP.NET Web API
- **Database**: Microsoft SQL Server
- **Authentication**: Bearer Token
- **File Storage**: Server file system
- **SMS Service**: Third-party SMS gateway integration

## 11.3 Database Design
### Key Stored Procedures:
1. `sec.Mobile_getusertype` - User type identification
2. `sec.Mobile_CERS_AppLogin` - User authentication
3. `sec.Mobile_CERS_SaveOtp_New` - OTP generation
4. `sec.Mobile_CERS_CheckOtp` - OTP verification
5. `sec.Mobile_saveData` - Expenditure data saving

---

This comprehensive documentation covers the complete system flow for all user types and functionalities in the CERS application, following the same structure and style as the original flow documentation.
