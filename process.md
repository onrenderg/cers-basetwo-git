# App sepecfic vs general 

# Process
## Obsidian
* obs-main git repo @obsidian-bk
* windsurf--> https://aistudio.google.com/ --> obsidian md 
* agentic protmp to --> bk read @obsidian-base-deploy/publish uses commonmd full yaml 
* to push prj  use -git folder copy 
* modify or fromstrach using gitgraph  appr 





# Git cmds
## Git logging 
* git reflog
* git status 
* git log --pretty=oneline 


## Git branching 
* git branch
* git switch branchname

## Git remote 
* git remote set-url origin <new-url>
* git remote -v
* ? dealing with multiple remotes (like upstream or origin2).

## Git Flows :
### \\ make current commit seprate branch named mock-login and  hard reset  with remote to previous commit 
* git checkout -b mock-login
* git push origin  mock-login
* git checkout main/ git switch main 
* git reset --hard prev-commit-hash
* git push origin main --force
<!-- Push Changes to Remote -->

* git push origin main --force


## Tech specefic 
### .net 
* api xam & maui in same base folder of that app 1.baseone, 2.basetwo
* db connect for procedure read and  modfiy using vs autocoplete enable as comment help PRE: @home/ [label](./path) : [pre-tsql-procedures](./pre-tsql-procedures)
* syntax & lang concepts  practice in md vs code vsplit with **mddoc**


## Skey:
## VS
* alt + ctrl + l = solution explorer 
* ctrl + ` = devloper temrinal `
* ctrl + shift + c = copy row 
* ctrl + alt + s = sql server window 
* ctrl + alt + e = exec line / lines sql 


## VS-code
* 


# Dev flow 
* put manually in  prjname file or put full trajectory --> aimd 



## Skills

### Postman 
#### How to use
* 1. create new folder || collection and give related name as prj 
* 2. to create request in *** of colelcion  **add request**
* data as query parameter ? = 
* add path parameters 
* raw  and key value json data to post req 





# Docs 
* code is more more data in less space compact use it as it is implaable as module etc or testing 
you don't see these CheckOtp logs when entering the OTP, it means the verification request isn't reaching the server, which could indicate a client-side issue in the mobile app's OTP verification call.

Try entering "123456" and let me know if you see the CheckOtp debug output.

# Explain debug-driven development methodology
# Tell me  developement process whic uses debug ouput statment to find where is issue in code  based on missing debug oupts 
# Questions llm usch it is determis it ouput ? *****


## Debug Output Analysis Process

I identified the issue location using **debug output flow analysis**:

### 1. **Expected Debug Flow**
```
[GetOtp] → [CheckOtp] → [Database Response]
```

### 2. **Actual Debug Flow**
```
[GetOtp] ✅ Present
[CheckOtp] ❌ Missing  
[Database Response] ❌ Missing
```

### 3. **Logical Deduction**
Since [GetOtp](cci:1://file:///c:/Users/Parth/Desktop/2025/CERS-baseone/CERS/WebApi/HitServices.cs:389:8-485:9) succeeded but `CheckOtp` never appeared, the issue is between these two points.

## Development Debug Process

### **Step 1: Add Debug Statements at Entry Points**
```csharp
// At start of each major function
System.Diagnostics.Debug.WriteLine("[FunctionName] Starting...");
```

### **Step 2: Add Debug at Decision Points**
```csharp
// Before API calls, database calls, conditions
System.Diagnostics.Debug.WriteLine("[FunctionName] About to call API...");
if (condition) {
    System.Diagnostics.Debug.WriteLine("[FunctionName] Condition true");
} else {
    System.Diagnostics.Debug.WriteLine("[FunctionName] Condition false");
}
```

### **Step 3: Add Debug at Exit Points**
```csharp
// Before returns, after operations
System.Diagnostics.Debug.WriteLine("[FunctionName] Completed successfully");
System.Diagnostics.Debug.WriteLine("[FunctionName] Error: " + ex.Message);
```

### **Step 4: Analyze Missing Logs**
- **Present logs** = Code executed successfully
- **Missing logs** = Code never reached OR crashed before log
- **Last present log** = Likely location of issue

### **Step 5: Narrow Down**
Add more granular debug statements around the last successful log point.

## Example Debug Strategy

```csharp
// Mobile app OTP verification
public async Task<int> checkotp_Get(string mobile, string otp)
{
    Debug.WriteLine("[CheckOtp-Client] Starting verification"); // ✅ Should appear
    
    if (networkCheck) {
        Debug.WriteLine("[CheckOtp-Client] Network OK"); // ✅ Should appear
        
        var response = await httpClient.GetAsync(url);
        Debug.WriteLine("[CheckOtp-Client] API called"); // ❌ If missing = network/URL issue
        
        var result = await response.Content.ReadAsStringAsync();
        Debug.WriteLine("[CheckOtp-Client] Response received"); // ❌ If missing = API timeout
    }
}
```

This systematic approach quickly isolates where code execution stops, making debugging much faster than guessing.


# User must able to bifercaste isoalte and  keep context of bifercate read 
rather para  use list with context of where tags 

### 1. Application Launch & Login
- **[CERS.MAUI]** User opens CERS mobile application
- **[CERS.MAUI]** Navigates to `LoginPage.xaml`
- **[CERS.MAUI]** Enters mobile number
- **[CERS.MAUI]** Clicks "Get OTP" button (`btn_getotp_Clicked` event)

# Generate end to end ** for implement highlights 