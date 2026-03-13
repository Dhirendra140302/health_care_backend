# Test doctor registration with license number
Write-Host "Testing Doctor Registration..." -ForegroundColor Yellow

$registrationData = @{
    name = "Dr. Sarah Johnson"
    email = "sarah.johnson@test.com"
    password = "password123"
    roles = @("DOCTOR")
    licenseNumber = "DOC98765"
    specialization = "PEDIATRICS"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/register" -Method Post -ContentType "application/json" -Body $registrationData
    Write-Host "✅ Doctor registration successful!" -ForegroundColor Green
    Write-Host "Response: $($response | ConvertTo-Json)"
} catch {
    Write-Host "❌ Registration failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host "Details: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
}
