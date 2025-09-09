# Mobile_CERS_AppLogin Stored Procedure

## Purpose
Validates user login credentials by checking mobile number against candidate database and returns user details if valid.

## Parameters
- `@MobileNo` (char(10)) - Mobile number to validate

## Logic Flow

```mermaid
flowchart TD
    Start([START: Mobile_CERS_AppLogin]) --> Input(Input: @MobileNo)
    
    Input --> MainBegin(BEGIN Main Block)
    
    subgraph "Main Procedure Block"
        MainBegin --> Check1{Check if NOMINATION_FOR not in Z or W}
        
        Check1 -->|True| Block1(BEGIN Block 1)
        subgraph "Invalid Contestant Block"
            Block1 --> Return1(Return: 300 - Invalid Contestant)
            Return1 --> End1(END Block 1)
        end
        
        Check1 -->|False| Check2{Check if NOMINATION_STATUS not equal to l}
        
        Check2 -->|True| Block2(BEGIN Block 2)
        subgraph "Pending Nomination Block"
            Block2 --> Return2(Return: 300 - Nomination pending for listing)
            Return2 --> End2(END Block 2)
        end
        
        Check2 -->|False| Check3{Check if Mobile exists in CandidatePersonalInfo}
        
        Check3 -->|True| Block3(BEGIN Block 3)
        subgraph "Valid User Block"
            Block3 --> Return3(Return: 200 - Successfully Logged In)
            Return3 --> SelectData(SELECT User Details)
            SelectData --> UserInfo(AUTO_ID, EPIC_NO, VOTER_NAME, etc.)
            UserInfo --> LocationInfo(Panchayat Name with Complex CASE logic)
            LocationInfo --> LoginType(LoggedInAs: Self/Agent/Not Known)
            LoginType --> Dates(Poll Date, Nomination Date, Result Date)
            Dates --> End3(END Block 3)
        end
        
        Check3 -->|False| NoMatch(No matching record found)
    end
    
    MainBegin --> MainEnd(END Main Block)
    End1 --> MainEnd
    End2 --> MainEnd
    End3 --> MainEnd
    NoMatch --> MainEnd
    MainEnd --> Finish([END PROCEDURE])

    %% Styling
    classDef startEnd fill:#e8f5e8,stroke:#4caf50,stroke-width:3px
    classDef process fill:#e3f2fd,stroke:#2196f3
    classDef decision fill:#fff3e0,stroke:#ff9800
    classDef error fill:#ffebee,stroke:#f44336
    classDef success fill:#e8f5e8,stroke:#4caf50
    classDef block fill:#f3e5f5,stroke:#9c27b0
    
    class Start,Finish startEnd
    class Input,SelectData,UserInfo,LocationInfo,LoginType,Dates process
    class Check1,Check2,Check3 decision
    class Return1,Return2 error
    class Return3 success
    class Block1,Block2,Block3,MainBegin,End1,End2,End3,MainEnd block
```

## Business Logic

### Validation Checks (in order):
1. **Invalid Contestant Check**: If `NOMINATION_FOR` is 'Z' or 'W', return error 300
2. **Nomination Status Check**: If `NOMINATION_STATUS` is not 'l' (legally valid), return error 300  
3. **User Existence Check**: If mobile number exists in database, proceed with login

### Success Response (Status 200):
Returns comprehensive user information including:
- Personal details (AUTO_ID, EPIC_NO, VOTER_NAME, etc.)
- Contact information (EMAIL_ID, MOBILE_NUMBER)
- Agent details (AgentName, AgentMobile)
- Location information with complex formatting logic
- Login type identification (Self/Agent/Not Known)
- Important dates (Poll Date, Nomination Date, Result Date)
- Post code and limit amount information

### Location Name Logic:
Complex CASE statement to format Panchayat names based on panchayat_code:
- If last 3 digits = 999: District level (Nagar Panchayat)
- If last 3 digits 990-998: MC Ward with number
- Otherwise: Standard Panchayat format

### Date Calculations:
- Poll Date from election master
- Result Date based on nomination type (Z/S uses ZpPsResultDate, others use ResultDate)
- Result Date + 30 days calculation for submission deadline

## Error Codes
- **300**: Invalid Contestant or Pending Nomination
- **200**: Successful Login

## Tables Accessed
- `sec.CandidatePersonalInfo` - Main candidate data
- `sec.Panchayat` - Location information  
- `sec.Block` - Block/Ward information
- `sec.District` - District information
- `sec.electionmaster` - Election and poll dates
- `sec.LimitMaster` - Expenditure limits
- `sec.Code` - Nomination type descriptions
