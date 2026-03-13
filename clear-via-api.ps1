# Clear database using REST API endpoint
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Clear Database via API" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "⚠️  WARNING: This will delete ALL data from the database!" -ForegroundColor Red
Write-Host "   This action cannot be undone!`n" -ForegroundColor Yellow

Write-Host "Calling database clear endpoint..." -ForegroundColor Yellow

try {
    # Call the clear database endpoint (no authentication required for this utility endpoint)
    $response = Invoke-RestMethod -Uri "http://localhost:8086/api/admin/clear-database" -Method Delete
    
    Write-Host "✅ Database cleared successfully!" -ForegroundColor Green
    Write-Host "Message: $($response.message)" -ForegroundColor Cyan
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Next Steps:" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "1. Go to http://localhost:3000/register" -ForegroundColor White
    Write-Host "2. Register new users (patients and doctors)" -ForegroundColor White
    Write-Host "3. All new registrations will have proper data" -ForegroundColor White
    Write-Host "`nRoles preserved: PATIENT, DOCTOR, ADMIN" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Failed to clear database" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.ErrorDetails.Message) {
        $errorObj = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "Backend Message: $($errorObj.message)" -ForegroundColor Yellow
    }
    
    Write-Host "`nAlternative: Use MySQL Workbench" -ForegroundColor Yellow
    Write-Host "See CLEAR_DATABASE_MANUAL.md for instructions" -ForegroundColor Cyan
}
