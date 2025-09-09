# Mobile_getusertype Stored Procedure

## Purpose
Determines user type (Candidate, Agent, Observer, or Invalid) based on mobile number lookup across multiple tables.

## Parameters
- `@MobileNo` (char(10)) - Mobile number to check user type

## Logic Flow

```mermaid
flowchart TD
    Start([START: Mobile_getusertype]) --> Input(Input: @MobileNo)
    
    Input --> MainBegin(BEGIN Main Block)
    
    subgraph "Main Procedure Block"
        MainBegin --> Check1{Check if mobile exists in<br/>CandidatePersonalInfo or<br/>CandidatePersonalInfo_arc<br/>as MOBILE_NUMBER}
        
        Check1 -->|True| CandidateBlock(Candidate Found)
        subgraph "Candidate Block"
            CandidateBlock --> ReturnCandidate(SELECT 200 statuscode<br/>'Candidate' UserType)
        end
        
        Check1 -->|False| Check2{Check if mobile exists in<br/>CandidatePersonalInfo or<br/>CandidatePersonalInfo_ARC<br/>as AgentMobile}
        
        Check2 -->|True| AgentBlock(Agent Found)
        subgraph "Agent Block"
            AgentBlock --> ReturnAgent(SELECT 200 statuscode<br/>'Agent' UserType)
        end
        
        Check2 -->|False| Check3{Check if mobile exists in<br/>ObserverInfo<br/>as ObserverContact}
        
        Check3 -->|True| ObserverBlock(Observer Found)
        subgraph "Observer Block"
            ObserverBlock --> ReturnObserver(SELECT 200 statuscode<br/>'Observor' UserType)
        end
        
        Check3 -->|False| InvalidBlock(No Match Found)
        subgraph "Invalid User Block"
            InvalidBlock --> ReturnInvalid(SELECT 300 statuscode<br/>'Invalid User' UserType)
        end
    end
    
    ReturnCandidate --> MainEnd(END Main Block)
    ReturnAgent --> MainEnd
    ReturnObserver --> MainEnd
    ReturnInvalid --> MainEnd
    MainEnd --> Finish([END PROCEDURE])

    %% Styling
    classDef startEnd fill:#e8f5e8,stroke:#4caf50,stroke-width:3px
    classDef process fill:#e3f2fd,stroke:#2196f3
    classDef decision fill:#fff3e0,stroke:#ff9800
    classDef success fill:#e8f5e8,stroke:#4caf50
    classDef error fill:#ffebee,stroke:#f44336
    classDef block fill:#f3e5f5,stroke:#9c27b0
    
    class Start,Finish startEnd
    class Input,MainBegin,MainEnd process
    class Check1,Check2,Check3 decision
    class CandidateBlock,AgentBlock,ObserverBlock,ReturnCandidate,ReturnAgent,ReturnObserver success
    class InvalidBlock,ReturnInvalid error
```

## Business Logic

### User Type Hierarchy (Priority Order):
1. **Candidate**: Primary mobile number in candidate tables
2. **Agent**: Agent mobile number in candidate tables  
3. **Observer**: Mobile number in observer info table
4. **Invalid User**: No match found in any table

### Validation Rules:
- **Candidate Check**: Searches both active and archived candidate tables
- **Agent Check**: Searches both active and archived candidate tables for agent mobile
- **Observer Check**: Searches observer info table
- **Cascading Logic**: Stops at first match found

### Response Format:
- **statuscode**: 200 (valid user) or 300 (invalid user)
- **UserType**: 'Candidate', 'Agent', 'Observor', or 'Invalid User'

## Tables Accessed
- `sec.CandidatePersonalInfo` - Active candidate data
- `sec.CandidatePersonalInfo_arc` - Archived candidate data  
- `sec.CandidatePersonalInfo_ARC` - Additional archived candidate data
- `secExpense.sec.ObserverInfo` - Observer information

## Usage Context
This procedure is typically the first step in authentication:
1. User enters mobile number
2. System calls this procedure to determine user type
3. Based on user type, different authentication flows are triggered
4. Candidates/Agents proceed to OTP flow
5. Observers proceed to observer login flow

## Security Features
- **Multiple Table Search**: Comprehensive user lookup
- **Archive Support**: Includes historical data
- **Clear Classification**: Unambiguous user type identification
- **Invalid User Handling**: Explicit rejection of unknown numbers
