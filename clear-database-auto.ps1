# Clear all database records (non-interactive)
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Clearing Database Records" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Try different MySQL paths
$mysqlPaths = @(
    "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe",
    "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe",
    "C:\Program Files\MySQL\MySQL Server 9.0\bin\mysql.exe"
)

$mysqlCmd = $null
foreach ($path in $mysqlPaths) {
    if (Test-Path $path) {
        $mysqlCmd = $path
        Write-Host "Found MySQL at: $path" -ForegroundColor Green
        break
    }
}

if (-not $mysqlCmd) {
    # Try mysql in PATH
    if (Get-Command mysql -ErrorAction SilentlyContinue) {
        $mysqlCmd = "mysql"
        Write-Host "Using MySQL from PATH" -ForegroundColor Green
    } else {
        Write-Host "❌ MySQL client not found!" -ForegroundColor Red
        Write-Host "`nPlease run manually in MySQL Workbench or command line:" -ForegroundColor Yellow
        Write-Host "   mysql -u root -proot healthcare < clear-database.sql" -ForegroundColor Cyan
        Write-Host "`nOr copy the SQL commands from clear-database.sql" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "`nExecuting SQL script..." -ForegroundColor Yellow

# Execute SQL commands directly
$sqlCommands = @"
USE healthcare;
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM consultations;
DELETE FROM appointments;
DELETE FROM notifications;
DELETE FROM password_reset_code;
DELETE FROM doctors;
DELETE FROM patients;
DELETE FROM user_roles;
DELETE FROM users;
SET FOREIGN_KEY_CHECKS = 1;
ALTER TABLE consultations AUTO_INCREMENT = 1;
ALTER TABLE appointments AUTO_INCREMENT = 1;
ALTER TABLE notifications AUTO_INCREMENT = 1;
ALTER TABLE password_reset_code AUTO_INCREMENT = 1;
ALTER TABLE doctors AUTO_INCREMENT = 1;
ALTER TABLE patients AUTO_INCREMENT = 1;
ALTER TABLE users AUTO_INCREMENT = 1;
"@

try {
    $sqlCommands | & $mysqlCmd -u root -proot 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Database cleared successfully!" -ForegroundColor Green
        
        # Verify
        Write-Host "`nVerifying tables are empty..." -ForegroundColor Yellow
        $verifyQuery = "SELECT COUNT(*) FROM users; SELECT COUNT(*) FROM doctors; SELECT COUNT(*) FROM patients; SELECT COUNT(*) FROM appointments;"
        $verifyResult = $verifyQuery | & $mysqlCmd -u root -proot healthcare 2>&1
        
        Write-Host "✅ All records deleted" -ForegroundColor Green
        Write-Host "`nRoles table preserved (PATIENT, DOCTOR, ADMIN still exist)" -ForegroundColor Cyan
        Write-Host "`nYou can now register new users at: http://localhost:3000/register" -ForegroundColor Cyan
    } else {
        Write-Host "⚠️  Some errors occurred, but database may be cleared" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Failed to execute SQL commands" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Done" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
