# getExpenseSource Stored Procedure

## Purpose
Retrieves expense source master data with formatted descriptions including sequence numbers for dropdown lists and reference data.

## Parameters
None - Returns all expense sources

## Logic Flow

```mermaid
flowchart TD
    Start([START: getExpenseSource]) --> MainBegin(BEGIN Main Block)
    
    subgraph "Main Procedure Block"
        MainBegin --> QueryExpenseSources(SELECT Expense Sources)
        
        subgraph "Query Block"
            QueryExpenseSources --> SelectFields(SELECT Exp_code<br/>CONCAT formatted Exp_Desc<br/>CONCAT formatted Exp_Desc_Local)
            SelectFields --> FormatDesc(Format: code + '. ' + description)
            FormatDesc --> FromTable(FROM expenseSourceMaster)
        end
        
        FromTable --> ReturnResults(Return Formatted Expense Source List)
    end
    
    ReturnResults --> MainEnd(END Main Block)
    MainEnd --> Finish([END PROCEDURE])

    %% Styling
    classDef startEnd fill:#e8f5e8,stroke:#4caf50,stroke-width:3px
    classDef process fill:#e3f2fd,stroke:#2196f3
    classDef query fill:#fff3e0,stroke:#ff9800
    classDef format fill:#e1f5fe,stroke:#03a9f4
    
    class Start,Finish startEnd
    class MainBegin,ReturnResults,MainEnd process
    class QueryExpenseSources,SelectFields,FromTable query
    class FormatDesc format
```

## Business Logic

### Data Formatting:
- **Code Conversion**: Casts Exp_code to integer for display
- **Description Formatting**: Combines code number with description text
- **Dual Language**: Formats both English and local language descriptions
- **Consistent Structure**: "1. Description" format for user-friendly display

### Response Fields:
- **Exp_code**: Original expense code identifier
- **Exp_Desc**: Formatted English description (e.g., "1. Travel Expenses")
- **Exp_Desc_Local**: Formatted local language description

## Tables Accessed
- `[secExpense].[sec].[expenseSourceMaster]` - Expense source master data

## Usage Context
This procedure provides reference data for:
1. **Expenditure Entry Forms**: Expense type dropdown lists
2. **Mobile App Initialization**: Load expense source options
3. **Data Validation**: Ensure valid expense codes
4. **User Interface**: Display user-friendly expense categories

## Formatting Logic
- **CONCAT Function**: Combines code and description
- **Integer Casting**: Converts code to readable number
- **Separator**: Uses '. ' (dot space) between code and description
- **Example Output**: "001" becomes "1. Office Supplies"

## Integration Points
- **Mobile Dropdowns**: Expense category selection
- **Form Validation**: Valid expense type checking
- **Local Database Sync**: Update mobile reference data
- **Multi-language UI**: Support localized expense categories
