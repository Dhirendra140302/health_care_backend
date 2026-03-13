# Check all database tables for data
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Database Tables Verification" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$mysqlPath = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
$mysqlCmd = "mysql"

# Try to find mysql
if (Test-Path $mysqlPath) {
    $mysqlCmd = "`"$mysqlPath`""
} elseif (Get-Command mysql -ErrorAction SilentlyContinue) {
    $mysqlCmd = "mysql"
} else {
    Write-Host "❌ MySQL client not found. Please install MySQL or add it to PATH" -ForegroundColor Red
    exit 1
}

$tables = @(
    "users",
    "roles", 
    "user_roles",
    "patients",
    "doctors",
    "appointments",
    "consultations",
    "notifications",
    "password_reset_code"
)

foreach ($table in $tables) {
    Write-Host "Table: $table" -ForegroundColor Yellow
    
    $query = "SELECT COUNT(*) as count FROM $table;"
    $countResult = & $mysqlCmd -u root -proot -D healthcare -e $query 2>&1 | Select-String "count" -Context 0,1
    
    if ($countResult) {
        $count = ($countResult -split "`n")[1].Trim()
        Write-Host "  Records: $count" -ForegroundColor Green
        
        # Show sample data for key tables
        if ($count -gt 0 -and $table -in @("users", "doctors", "patients", "appointments", "consultations")) {
            Write-Host "  Sample data:" -ForegroundColor Cyan
            $sampleQuery = "SELECT * FROM $table LIMIT 3;"
            & $mysqlCmd -u root -proot -D healthcare -e $sampleQuery 2>&1 | Select-Object -First 10
        }
    } else {
        Write-Host "  ⚠️  Could not query table" -ForegroundColor Yellow
    }
    
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Verification Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
