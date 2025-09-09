# Complete User Journey Flow - CERS Mobile Application

## End-to-End User Journey Description

### 1. Application Launch & Login
- **[CERS.MAUI]** User opens CERS mobile application
- **[CERS.MAUI]** Navigates to `LoginPage.xaml`
- **[CERS.MAUI]** Enters mobile number
- **[CERS.MAUI]** Clicks "Get OTP" button (`btn_getotp_Clicked` event)

### 2. User Type Validation Process
- **[CERS.MAUI]** Calls `HitServices.CheckUserType_Get`
- **[CERS.API]** Routes to `UserLoginController/CheckUserType`
- **[CERS.API]** Executes `sec.Mobile_getusertype` stored procedure
- **[CERS.API]** Validation Logic: Checks mobile number across multiple tables:
  - `CandidatePersonalInfo` for candidates
  - `AgentMobile` fields for agents  
  - `ObserverInfo` for observers
- **[CERS.API → CERS.MAUI]** Returns status 200 for valid users (Candidate/Agent/Observer) or 300 for invalid users

### 3. OTP Generation Process
- **[CERS.MAUI]** Valid users trigger call to `GetOTPController`
- **[CERS.API]** Executes `sec.Mobile_CERS_SaveOtp_New` stored procedure
- **[CERS.API]** Rate Limiting: Checks user hasn't exceeded limits:
  - Maximum 1 OTP request per minute
  - Maximum 3 requests per 3-minute window
- **[CERS.API]** OTP Creation: If allowed, generates 6-digit OTP
- **[CERS.API]** Storage: Inserts OTP into `Mobile_CERS_Otp` table with timestamp
- **[CERS.API]** SMS Service: Sends OTP via SMS
- **[CERS.API → CERS.MAUI]** Status Codes: 200 (success), 429 (rate limit), 400 (too many requests)

### 4. OTP Verification Process
- **[CERS.MAUI]** User receives and enters OTP, clicks "Submit OTP" (`btn_submitotp_Clicked`)
- **[CERS.MAUI]** Calls `HitServices.CheckOtp`
- **[CERS.API]** Routes to `CheckOtpController`
- **[CERS.API]** Executes `sec.Mobile_CERS_CheckOtp` stored procedure
- **[CERS.API]** Validation: Matches exact combination of MobileNo + OtpPassword + OtpId
- **[CERS.API → CERS.MAUI]** Response: Status 200 (valid) or 300 (invalid OTP)

### 5. Token Generation Process
- **[CERS.MAUI]** Successful OTP verification triggers call to `GenerateTokenController`
- **[CERS.API]** Calls `sec.mobile_bearer_token_get` stored procedure
- **[CERS.API]** Token Creation: Generates cryptographically secure 32-character alphanumeric token
- **[CERS.API]** Randomness: Uses SQL Server's `NEWID()` function
- **[CERS.API]** Cleanup: Automatically removes expired tokens from `mobile_token_master` table
- **[CERS.API]** Storage: Inserts new token with expiration timestamp
- **[CERS.API → CERS.MAUI]** Response: Status 200 with bearer token (success) or 400 (failure)

### 6. Dashboard Initialization
- **[CERS.MAUI]** Navigation: App moves to `DashboardPage.xaml` with valid bearer token
- **[CERS.MAUI]** Calls user profile loading service
- **[CERS.API]** Executes `sec.Mobile_CERS_AppLogin` to retrieve:
  - `VOTER_NAME`, `EPIC_NO`
  - Panchayat information
  - Election dates
- **[CERS.MAUI]** Reference Data Loading (parallel calls):
  - `HitServices.PaymentModes_Get` → **[CERS.API]** `sec.Mobile_getPaymentModes` (payment options with translations)
  - `HitServices.ExpenseSources_Get` → **[CERS.API]** `sec.getExpenseSource` (formatted expense categories)
  - `HitServices.LocalResources_Get` → **[CERS.API]** `sec.Mobile_getLocalResources` (UI text translations)
- **[CERS.MAUI]** Calls existing expenditure data service
- **[CERS.API]** Loads expenditure records via `sec.Mobile_getsaveData`
- **[CERS.API]** Complex Joins: Across candidateRegister, expenseSourceMaster, paymentmodeMaster, candidateExpenseEvidence, OberverRemarks
- **[CERS.API → CERS.MAUI]** Data Format: Returns formatted dates, amounts, descriptions, evidence indicators, observer comments (ordered by most recent)

### 7. User Actions - Add Expenditure
- **[CERS.MAUI]** Navigate to `AddExpenditureDetailsPage.xaml`
- **[CERS.MAUI]** User fills form and clicks "Save Data" (`btn_savedata_Clicked`)
- **[CERS.MAUI]** Calls `HitServices.SaveExpenditureDetails` with bearer token
- **[CERS.API]** `ExpenditureDetailsController` validates bearer token
- **[CERS.API]** Executes `sec.Mobile_saveData` stored procedure:
  - Begins database transaction
  - Checks for duplicates (AutoID + expDate + expCode)
  - Retrieves candidate's panchayat code
  - Inserts expenditure record with status 'P' (Pending)
  - Optionally inserts evidence files into `candidateExpenseEvidence`
- **[CERS.API → CERS.MAUI]** Commits transaction (status 200) or rolls back (status 400)

### 8. User Actions - Edit Expenditure
- **[CERS.MAUI]** Navigate to `EditExpenditureDetailsPage.xaml`
- **[CERS.MAUI]** User modifies data and saves changes
- **[CERS.API]** Calls `sec.Mobile_updatesaveData`
- **[CERS.API]** Transaction: Updates all expenditure fields and evidence files within transaction

### 9. User Actions - View Expenditure
- **[CERS.MAUI]** Navigate to `ViewExpenditureDetailsPage.xaml`
- **[CERS.MAUI]** User requests evidence file download
- **[CERS.API]** Calls `sec.Mobile_getpdf`
- **[CERS.API → CERS.MAUI]** File Retrieval: Returns evidence file binary data for download

### 10. User Actions - Final Submission
- **[CERS.MAUI]** User initiates final submission process
- **[CERS.API]** Calls `sec.Mobile_finalsaveData`
- **[CERS.API]** Date Validation: Checks current date ≥ poll date
- **[CERS.API]** Status Update: Changes ExpStatus from 'P' (Pending) to 'F' (Final)
- **[CERS.API → CERS.MAUI]** Response: Status 200 (successful finalization) or 400 (too early)

### 11. System-Wide Features
- **Error Handling**: Comprehensive with specific status codes
- **Transaction Management**: Automatic rollbacks on failures
- **Security**: Rate limiting, token-based authentication
- **Localization**: Multi-language support
- **Compliance**: Evidence file management
- **Transparency**: Observer integration
- **Audit**: Complete trails with timestamps for all operations
