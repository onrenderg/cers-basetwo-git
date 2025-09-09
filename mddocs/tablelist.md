# Database Tables Used by CERS Web API Stored Procedures

This document lists all database tables referenced in the stored procedures within the `stored-procedures-CERSWebApi` directory.

## Schema Overview

The CERS system uses two main database schemas:
- **`sec`** - Security/Core application schema
- **`secExpense`** - Expense management schema

---

## Tables by Schema

### `sec.sec` Schema (Core Security/Application Tables)

#### **Candidate & User Management**
| Table Name | Purpose | Used In Procedures |
|------------|---------|-------------------|
| `CandidatePersonalInfo` | Main candidate information table | Mobile_CERS_AppLogin, Mobile_getusertype, Mobile_saveData, Mobile_getpdfdecdata |
| `CandidatePersonalInfo_arc` | Archived candidate information | Mobile_CERS_AppLogin, Mobile_getusertype |
| `candidateRegister` | Candidate expense registrations | Mobile_saveData, Mobile_updatesaveData, Mobile_CERS_AppLogin |
| `candidateExpenseEvidence` | Evidence files for expenses | Mobile_saveData, Mobile_updatesaveData |

#### **Geographic & Administrative**
| Table Name | Purpose | Used In Procedures |
|------------|---------|-------------------|
| `Panchayats` | Panchayat/constituency information | Mobile_CERS_AppLogin, Mobile_getpdfdecdata |
| `Blocks` | Block/administrative divisions | Mobile_CERS_AppLogin |
| `Districts` | District information | Mobile_CERS_AppLogin |

#### **Election Management**
| Table Name | Purpose | Used In Procedures |
|------------|---------|-------------------|
| `ElectionMaster` | Election details and dates | Mobile_CERS_AppLogin |
| `ElectionPolls` | Poll phase information | Mobile_CERS_AppLogin |

#### **Reference Data**
| Table Name | Purpose | Used In Procedures |
|------------|---------|-------------------|
| `commonmaster` | Common lookup/master data | Mobile_CERS_AppLogin |

#### **Authentication & OTP**
| Table Name | Purpose | Used In Procedures |
|------------|---------|-------------------|
| `Mobile_CERS_Otp` | OTP storage and validation | Mobile_CERS_CheckOtp, Mobile_CERS_SaveOtp_New |

---

### `secExpense.sec` Schema (Expense Management Tables)

#### **Observer Management**
| Table Name | Purpose | Used In Procedures |
|------------|---------|-------------------|
| `ObserverInfo` | Observer user information | Mobile_CERS_ObservorLogin, Mobile_getusertype |
| `OberverRemarks` | Observer remarks on expenses | Mobile_updateobserverremarks |

#### **Expense Configuration**
| Table Name | Purpose | Used In Procedures |
|------------|---------|-------------------|
| `expenseLimitMaster` | Expense limits by post type | Mobile_CERS_AppLogin |
| `expenseSourceMaster` | Expense source categories | getExpenseSource |

---

## Tables by Functional Area

### **Authentication & Login**
- `sec.sec.CandidatePersonalInfo` - Primary user authentication
- `sec.sec.CandidatePersonalInfo_arc` - Archived user data
- `secExpense.sec.ObserverInfo` - Observer authentication
- `sec.Mobile_CERS_Otp` - OTP verification

### **Expense Management**
- `sec.candidateRegister` - Main expense entries
- `sec.candidateExpenseEvidence` - Supporting documents
- `secExpense.sec.expenseLimitMaster` - Spending limits
- `secExpense.sec.expenseSourceMaster` - Expense categories
- `secExpense.sec.OberverRemarks` - Observer comments

### **Geographic & Administrative**
- `sec.sec.Panchayats` - Constituency boundaries
- `sec.sec.Blocks` - Administrative blocks
- `sec.sec.Districts` - District information

### **Election Data**
- `sec.sec.ElectionMaster` - Election schedules
- `sec.sec.ElectionPolls` - Polling information
- `sec.sec.commonmaster` - Election types and categories

---

## Key Relationships

### **User Hierarchy**
```
CandidatePersonalInfo (Candidates/Agents)
    ↓
candidateRegister (Expense Entries)
    ↓
candidateExpenseEvidence (Supporting Files)
    ↓
OberverRemarks (Observer Comments)
```

### **Geographic Hierarchy**
```
Districts
    ↓
Blocks
    ↓
Panchayats
```

### **Election Flow**
```
ElectionMaster
    ↓
ElectionPolls
    ↓
CandidatePersonalInfo
```

---

## Usage Statistics

| Schema | Table Count | Primary Use |
|--------|-------------|-------------|
| `sec.sec` | 9 tables | Core application, authentication, elections |
| `secExpense.sec` | 4 tables | Expense tracking, observer management |
| **Total** | **13 tables** | Complete CERS functionality |

---

## Notes

1. **Archive Pattern**: The system maintains `_arc` tables for historical data
2. **Multi-Schema Design**: Separates core functionality (`sec`) from expense management (`secExpense`)
3. **Geographic Flexibility**: Supports Panchayats, Municipal Corporations, and Nagar Panchayats
4. **Audit Trail**: Most tables include timestamp fields (`DtTm`) for tracking
5. **File Storage**: Binary data stored in `candidateExpenseEvidence.evidenceFile`

---

*Generated from stored procedures analysis on 2025-09-09*
