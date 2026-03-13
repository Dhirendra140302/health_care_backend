# Clear all database records
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Clearing Database Records" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "⚠️  WARNING: This will delete all data from the database!" -ForegroundColor Red
Write-Host "   - All users will be deleted" -ForegroundColor Yellow
Write-Host "   - All appointments will be deleted" -ForegroundColor Yellow
Write-Host "   - All consultations will be deleted" -ForegroundColor Yellow
Write-Host "   - Roles table will be preserved (PATIENT, DOCTOR, ADMIN)`n" -ForegroundColor Yellow

$confirmation = Read-Host "Type 'YES' to confirm deletion"

if ($confirmation -ne "YES") {
    Write-Host "`n❌ Operation cancelled" -ForegroundColor Red
    exit 0
}

Write-Host "`nClearing database..." -ForegroundColor Yellow

# Try different MySQL paths
$mysqlPaths = @(
    "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe",
    "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe",
    "C:\Program Files\MySQL\MySQL Server 9.0\bin\mysql.exe",
    "mysql"
)

$mysqlCmd = $null
foreach ($path in $mysqlPaths) {
    if ($path -eq "mysql") {
        if (Get-Command mysql -ErrorAction SilentlyContinue) {
            $mysqlCmd = "mysql"
            break
        }
    } elseif (Test-Path $path) {
        $mysqlCmd = "`"$path`""
        break
    }
}

if (-not $mysqlCmd) {
    Write-Host "❌ MySQL client not found!" -ForegroundColor Red
    Write-Host "`nPlease run this SQL script manually in MySQL Workbench:" -ForegroundColor Yellow
    Write-Host "   File: clear-database.sql" -ForegroundColor Cyan
    Write-Host "`nOr run this command if MySQL is installed:" -ForegroundColor Yellow
    Write-Host '   mysql -u root -proot healthcare < clear-database.sql' -ForegroundColor Cyan
    exit 1
}

# Execute the SQL script
try {
    $result = & $mysqlCmd -u root -proot healthcare -e "source clear-database.sql" 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Database cleared successfully!" -ForegroundColor Green
        Write-Host "`nYou can now register new users with clean data." -ForegroundColor Cyan
    } else {
        Write-Host "❌ Error clearing database" -ForegroundColor Red
        Write-Host $result
    }
} catch {
    Write-Host "❌ Failed to execute SQL script" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "`nPlease run manually: mysql -u root -proot healthcare < clear-database.sql" -ForegroundColor Yellow
}
