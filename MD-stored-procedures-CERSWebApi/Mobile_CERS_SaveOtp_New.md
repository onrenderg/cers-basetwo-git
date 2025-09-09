# Mobile_CERS_SaveOtp_New Stored Procedure

## Purpose
Generates and saves OTP for user authentication with rate limiting and validation checks.

## Parameters
- `@MobileNo` (char(10)) - Mobile number for OTP generation
- `@Otppassword` (int) - Generated OTP value
- `@otpId` (int) - OTP identifier
- `@status_code` (int) - OUTPUT parameter for status code
- `@status_message` (varchar(200)) - OUTPUT parameter for status message

## Logic Flow

```mermaid
flowchart TD
    Start([START: Mobile_CERS_SaveOtp_New]) --> Input(Input Parameters)
    
    Input --> MainBegin(BEGIN Main Block)
    
    subgraph "Main Procedure Block"
        MainBegin --> InnerBegin(BEGIN Inner Block)
        
        subgraph "Rate Limiting Block"
            InnerBegin --> Declare1(DECLARE @requestCount INT)
            Declare1 --> Declare2(DECLARE @message Table)
            Declare2 --> CountQuery(SELECT COUNT from Mobile_CERS_Otp<br/>WHERE MobileNo = @MobileNo<br/>AND OTPDateTime >= DATEADD MINUTE -3 GETDATE<br/>AND CAST OTPDateTime AS DATE = CAST GETDATE AS DATE)
            
            CountQuery --> Declare3(DECLARE @requestTime DATETIME)
            Declare3 --> SetTime(SET @requestTime = GETDATE)
            SetTime --> Declare4(DECLARE @lastRequestTime DATETIME)
            Declare4 --> LastTimeQuery(SELECT MAX OTPDateTime<br/>FROM Mobile_CERS_Otp<br/>WHERE MobileNo = @MobileNo)
        end
        
        subgraph "Validation Block"
            LastTimeQuery --> Check1{Check if new request<br/>within 1 minute of last request}
            
            Check1 -->|True| Block1(BEGIN Rate Limit Block)
            subgraph "Rate Limit Error Block"
                Block1 --> SetError1(SET @status_code = 429)
                SetError1 --> SetMsg1(SET @status_message = Rate limit exceeded)
                SetMsg1 --> End1(END Rate Limit Block)
            end
            
            Check1 -->|False| Check2{Check if @requestCount > 3}
            
            Check2 -->|True| Block2(BEGIN Count Limit Block)
            subgraph "Count Limit Error Block"
                Block2 --> SetError2(SET @status_code = 400)
                SetError2 --> SetMsg2(SET @status_message = Too many requests)
                SetMsg2 --> End2(END Count Limit Block)
            end
            
            Check2 -->|False| Block3(BEGIN Success Block)
            subgraph "OTP Generation Block"
                Block3 --> InsertOTP(INSERT INTO Mobile_CERS_Otp<br/>MobileNo OtpPassword otpId OTPDateTime)
                InsertOTP --> SetSuccess(SET @status_code = 200)
                SetSuccess --> SetSuccessMsg(SET @status_message = OTP generated successfully)
                SetSuccessMsg --> End3(END Success Block)
            end
        end
        
        InnerBegin --> InnerEnd(END Inner Block)
    end
    
    End1 --> InnerEnd
    End2 --> InnerEnd
    End3 --> InnerEnd
    InnerEnd --> MainEnd(END Main Block)
    MainEnd --> Finish([END PROCEDURE])

    %% Styling
    classDef startEnd fill:#e8f5e8,stroke:#4caf50,stroke-width:3px
    classDef process fill:#e3f2fd,stroke:#2196f3
    classDef decision fill:#fff3e0,stroke:#ff9800
    classDef error fill:#ffebee,stroke:#f44336
    classDef success fill:#e8f5e8,stroke:#4caf50
    classDef block fill:#f3e5f5,stroke:#9c27b0
    classDef declare fill:#f8bbd9,stroke:#e91e63
    
    class Start,Finish startEnd
    class Input,CountQuery,SetTime,LastTimeQuery,InsertOTP process
    class Check1,Check2 decision
    class SetError1,SetMsg1,SetError2,SetMsg2 error
    class SetSuccess,SetSuccessMsg success
    class MainBegin,InnerBegin,Block1,Block2,Block3,End1,End2,End3,InnerEnd,MainEnd block
    class Declare1,Declare2,Declare3,Declare4 declare
```

## Business Logic

### Rate Limiting Rules:
1. **Time-based Limit**: No more than 1 OTP request per minute
2. **Count-based Limit**: Maximum 3 OTP requests per 3-minute window per day
3. **Date-based Reset**: Counters reset daily

### Validation Process:
1. **Check Last Request Time**: Prevents spam requests within 1 minute
2. **Check Request Count**: Counts requests in last 3 minutes for current date
3. **Generate OTP**: If all validations pass, insert new OTP record

### Output Parameters:
- **@status_code**: 
  - 200: Success
  - 400: Too many requests (>3 in 3 minutes)
  - 429: Rate limit exceeded (within 1 minute)
- **@status_message**: Descriptive message for the status

## Tables Accessed
- `[sec].[Mobile_CERS_Otp]` - OTP storage and tracking table

## Security Features
- **Rate Limiting**: Prevents brute force attacks
- **Time Windows**: Multiple time-based restrictions
- **Daily Reset**: Counters reset each day
- **Audit Trail**: All OTP requests logged with timestamps

## Error Handling
- Comprehensive validation before OTP generation
- Clear error messages for different failure scenarios
- Output parameters for API response handling
