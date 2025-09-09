# Mobile_getLocalResources Stored Procedure

## Purpose
Retrieves localization resources for mobile application UI elements, supporting multi-language functionality.

## Parameters
None - Returns all localization resources

## Logic Flow

```mermaid
flowchart TD
    Start([START: Mobile_getLocalResources]) --> MainBegin(BEGIN Main Block)
    
    subgraph "Main Procedure Block"
        MainBegin --> QueryResources(SELECT Localization Resources)
        
        subgraph "Query Block"
            QueryResources --> SelectFields(SELECT MultipleResourceKey<br/>ResourceKey<br/>ResourceValue<br/>LocalResourceValue)
            SelectFields --> FromTable(FROM Mobile_LocalResource)
        end
        
        FromTable --> ReturnResults(Return Resource List)
    end
    
    ReturnResults --> MainEnd(END Main Block)
    MainEnd --> Finish([END PROCEDURE])

    %% Styling
    classDef startEnd fill:#e8f5e8,stroke:#4caf50,stroke-width:3px
    classDef process fill:#e3f2fd,stroke:#2196f3
    classDef query fill:#fff3e0,stroke:#ff9800
    
    class Start,Finish startEnd
    class MainBegin,ReturnResults,MainEnd process
    class QueryResources,SelectFields,FromTable query
```

## Business Logic

### Data Retrieval:
- **Complete Resource Set**: Returns all localization resources
- **Multi-language Support**: Both default and local language values
- **Key-Value Structure**: Organized by resource keys for easy lookup

### Response Fields:
- **MultipleResourceKey**: Grouping identifier for related resources
- **ResourceKey**: Unique identifier for each resource
- **ResourceValue**: Default language text (typically English)
- **LocalResourceValue**: Local language translation

## Tables Accessed
- `sec.Mobile_LocalResource` - Localization resource master data

## Usage Context
This procedure supports mobile app localization:
1. **App Initialization**: Load all text resources
2. **Language Switching**: Provide translations for UI elements
3. **Offline Support**: Cache resources locally on mobile device
4. **Dynamic Content**: Support runtime language changes

## Integration Points
- **Mobile App Startup**: Download and cache resources
- **UI Rendering**: Display appropriate language text
- **Settings Management**: Support language preference changes
- **Content Management**: Update translations without app updates
