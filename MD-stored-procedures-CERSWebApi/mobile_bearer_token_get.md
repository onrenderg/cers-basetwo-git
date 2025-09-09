# mobile_bearer_token_get Stored Procedure

## Purpose
Generates secure bearer tokens for API authentication with automatic cleanup of expired tokens.

## Parameters
- `@status_code` (int) - OUTPUT parameter for operation status
- `@status_message` (varchar(200)) - OUTPUT parameter for status message

## Logic Flow

```mermaid
flowchart TD
    Start([START: mobile_bearer_token_get]) --> MainBegin(BEGIN Main Block)
    
    subgraph "Main Procedure Block"
        MainBegin --> DeclareVars(DECLARE Variables<br/>@token VARCHAR 32<br/>@char_set VARCHAR 75<br/>@Length INT 32<br/>@token_id VARCHAR 32<br/>@i INT 1)
        
        DeclareVars --> TokenGenLoop(Token Generation Loop)
        subgraph "Token Generation Block"
            TokenGenLoop --> LoopCheck{@i <= @Length?}
            LoopCheck -->|True| GenerateChar(Generate Random Character<br/>from @char_set using NEWID)
            GenerateChar --> AppendChar(Append to @token_id)
            AppendChar --> Increment(SET @i = @i + 1)
            Increment --> LoopCheck
            LoopCheck -->|False| LoopEnd(Token Generation Complete)
        end
        
        LoopEnd --> SetToken(SET @token_id = @token_id)
        SetToken --> CleanupExpired(DELETE expired tokens<br/>WHERE expire_datetime < GETDATE)
        CleanupExpired --> InsertToken(INSERT INTO mobile_token_master<br/>token_id = @token_id)
        
        InsertToken --> CheckRowCount{@@ROWCOUNT > 0?}
        
        CheckRowCount -->|True| SuccessBlock(Token Insert Success)
        subgraph "Success Block"
            SuccessBlock --> SetSuccessCode(SET @status_code = 200)
            SetSuccessCode --> SetSuccessMsg(SET @status_message = 'Created')
        end
        
        CheckRowCount -->|False| FailureBlock(Token Insert Failed)
        subgraph "Failure Block"
            FailureBlock --> SelectEmpty(SELECT '' token_id)
            SelectEmpty --> SetFailCode(SET @status_code = 400)
            SetFailCode --> SetFailMsg(SET @status_message = 'Token Generation Failed')
        end
        
        SetSuccessMsg --> FinalSelect(SELECT @token_id token_id<br/>@status_code status_code<br/>@status_message status_message)
        SetFailMsg --> FinalSelect
    end
    
    FinalSelect --> MainEnd(END Main Block)
    MainEnd --> Finish([END PROCEDURE])

    %% Styling
    classDef startEnd fill:#e8f5e8,stroke:#4caf50,stroke-width:3px
    classDef process fill:#e3f2fd,stroke:#2196f3
    classDef decision fill:#fff3e0,stroke:#ff9800
    classDef success fill:#e8f5e8,stroke:#4caf50
    classDef error fill:#ffebee,stroke:#f44336
    classDef block fill:#f3e5f5,stroke:#9c27b0
    classDef loop fill:#e1f5fe,stroke:#03a9f4
    
    class Start,Finish startEnd
    class MainBegin,DeclareVars,SetToken,CleanupExpired,InsertToken,FinalSelect,MainEnd process
    class LoopCheck,CheckRowCount decision
    class SuccessBlock,SetSuccessCode,SetSuccessMsg success
    class FailureBlock,SelectEmpty,SetFailCode,SetFailMsg error
    class TokenGenLoop,GenerateChar,AppendChar,Increment,LoopEnd loop
```

## Business Logic

### Token Generation Process:
1. **Random Character Generation**: Uses NEWID() for cryptographic randomness
2. **Character Set**: Alphanumeric (a-z, A-Z, 0-9) - 62 possible characters
3. **Token Length**: Fixed 32 characters for security
4. **Loop Generation**: Builds token character by character

### Security Features:
- **Cryptographic Randomness**: Uses SQL Server's NEWID() function
- **Automatic Cleanup**: Removes expired tokens before generating new ones
- **Collision Prevention**: 32-character length with 62^32 possible combinations
- **Expiration Management**: Built-in token lifecycle management

### Database Operations:
1. **Cleanup Phase**: DELETE expired tokens
2. **Insert Phase**: INSERT new token
3. **Validation Phase**: Check if insert was successful

### Response Codes:
- **200**: Token successfully created
- **400**: Token generation failed

## Tables Accessed
- `secExpense.[sec].[mobile_token_master]` - Token storage and management

## Algorithm Details
- **Character Set**: 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
- **Random Selection**: ABS(CHECKSUM(NEWID())) % LEN(@char_set) + 1
- **Token Format**: 32-character alphanumeric string
- **Expiration**: Automatic cleanup based on expire_datetime field

## Usage Context
This procedure is called after successful OTP verification:
1. User completes OTP verification
2. System calls this procedure to generate bearer token
3. Token is returned to client for subsequent API calls
4. Token expires automatically after configured time period

## Error Handling
- **Insert Validation**: Checks @@ROWCOUNT to ensure successful insert
- **Graceful Failure**: Returns empty token_id and error status on failure
- **Consistent Response**: Always returns status_code and status_message
