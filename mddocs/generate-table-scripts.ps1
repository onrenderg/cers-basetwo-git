# PowerShell script to generate CREATE TABLE scripts for CERS database
# Run this on a machine that can connect to the production server

# Production server connection
$ServerName = "10.146.2.114"
$DatabaseName = "secExpense"
$Username = "sec"
$Password = "sec12345"

# Local export directory
$ExportPath = "C:\Exports\Tables"

# Create export directory if it doesn't exist
if (!(Test-Path $ExportPath)) {
    New-Item -ItemType Directory -Path $ExportPath -Force
}

# Import SQL Server module (install if needed: Install-Module -Name SqlServer)
Import-Module SqlServer -ErrorAction SilentlyContinue

# Connection string
$ConnectionString = "Server=$ServerName;Database=$DatabaseName;User Id=$Username;Password=$Password;TrustServerCertificate=true;"

# List of tables to export
$Tables = @(
    @{Schema="sec"; Table="CandidatePersonalInfo"; File="CREATE_sec_CandidatePersonalInfo.sql"},
    @{Schema="sec"; Table="CandidatePersonalInfo_arc"; File="CREATE_sec_CandidatePersonalInfo_arc.sql"},
    @{Schema="sec"; Table="candidateRegister"; File="CREATE_sec_candidateRegister.sql"},
    @{Schema="sec"; Table="candidateExpenseEvidence"; File="CREATE_sec_candidateExpenseEvidence.sql"},
    @{Schema="sec"; Table="Panchayats"; File="CREATE_sec_Panchayats.sql"},
    @{Schema="sec"; Table="Blocks"; File="CREATE_sec_Blocks.sql"},
    @{Schema="sec"; Table="Districts"; File="CREATE_sec_Districts.sql"},
    @{Schema="sec"; Table="ElectionMaster"; File="CREATE_sec_ElectionMaster.sql"},
    @{Schema="sec"; Table="ElectionPolls"; File="CREATE_sec_ElectionPolls.sql"},
    @{Schema="sec"; Table="commonmaster"; File="CREATE_sec_commonmaster.sql"},
    @{Schema="sec"; Table="Mobile_CERS_Otp"; File="CREATE_sec_Mobile_CERS_Otp.sql"},
    @{Schema="sec"; Table="ObserverInfo"; File="CREATE_secExpense_ObserverInfo.sql"},
    @{Schema="sec"; Table="OberverRemarks"; File="CREATE_secExpense_OberverRemarks.sql"},
    @{Schema="sec"; Table="expenseLimitMaster"; File="CREATE_secExpense_expenseLimitMaster.sql"},
    @{Schema="sec"; Table="expenseSourceMaster"; File="CREATE_secExpense_expenseSourceMaster.sql"}
)

Write-Host "Starting table script generation..." -ForegroundColor Green

foreach ($TableInfo in $Tables) {
    $Schema = $TableInfo.Schema
    $TableName = $TableInfo.Table
    $FileName = $TableInfo.File
    $FilePath = Join-Path $ExportPath $FileName
    
    Write-Host "Processing table: [$Schema].[$TableName]" -ForegroundColor Yellow
    
    try {
        # Query to get table structure
        $Query = @"
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = '$Schema' AND TABLE_NAME = '$TableName'
ORDER BY ORDINAL_POSITION
"@

        # Execute query
        $Columns = Invoke-Sqlcmd -ConnectionString $ConnectionString -Query $Query
        
        if ($Columns.Count -eq 0) {
            Write-Host "  Warning: No columns found for table [$Schema].[$TableName]" -ForegroundColor Red
            continue
        }
        
        # Build CREATE TABLE statement
        $CreateStatement = "CREATE TABLE [$Schema].[$TableName] (`n"
        
        $ColumnDefinitions = @()
        foreach ($Column in $Columns) {
            $ColumnName = $Column.COLUMN_NAME
            $DataType = $Column.DATA_TYPE.ToUpper()
            $MaxLength = $Column.CHARACTER_MAXIMUM_LENGTH
            $Precision = $Column.NUMERIC_PRECISION
            $Scale = $Column.NUMERIC_SCALE
            $IsNullable = $Column.IS_NULLABLE
            $DefaultValue = $Column.COLUMN_DEFAULT
            
            # Build column definition
            $ColumnDef = "    [$ColumnName] $DataType"
            
            # Add length/precision
            if ($MaxLength -and $MaxLength -ne -1) {
                if ($MaxLength -eq 2147483647) {
                    $ColumnDef += "(MAX)"
                } else {
                    $ColumnDef += "($MaxLength)"
                }
            } elseif ($Precision -and $Scale -ne $null) {
                $ColumnDef += "($Precision,$Scale)"
            } elseif ($Precision) {
                $ColumnDef += "($Precision)"
            }
            
            # Add NULL/NOT NULL
            if ($IsNullable -eq "NO") {
                $ColumnDef += " NOT NULL"
            } else {
                $ColumnDef += " NULL"
            }
            
            # Add default value if exists
            if ($DefaultValue) {
                $ColumnDef += " DEFAULT $DefaultValue"
            }
            
            $ColumnDefinitions += $ColumnDef
        }
        
        $CreateStatement += ($ColumnDefinitions -join ",`n")
        $CreateStatement += "`n);"
        
        # Write to file
        $CreateStatement | Out-File -FilePath $FilePath -Encoding UTF8
        Write-Host "  Created: $FileName" -ForegroundColor Green
        
    } catch {
        Write-Host "  Error processing table [$Schema].[$TableName]: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nTable script generation completed!" -ForegroundColor Green
Write-Host "Scripts saved to: $ExportPath" -ForegroundColor Cyan
