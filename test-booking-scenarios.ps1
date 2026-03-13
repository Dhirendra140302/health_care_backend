# Test different booking scenarios
Write-Host "Testing Appointment Booking Scenarios..." -ForegroundColor Cyan

# Scenario 1: Patient booking (should work)
Write-Host "`n[Scenario 1] Patient booking appointment..." -ForegroundColor Yellow
$loginResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"alice@test.com","password":"password123"}'
$token = $loginResponse.data.token

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$appointmentData = '{"doctorId":1,"startTime":"2026-03-12T09:00:00","purposeOfConsultation":"Test","initialSymptoms":"Test"}'

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Post -Headers $headers -Body $appointmentData
    Write-Host "✅ Patient booking: SUCCESS" -ForegroundColor Green
} catch {
    Write-Host "❌ Patient booking: FAILED" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        $error = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "   Error: $($error.message)" -ForegroundColor Red
    }
}

# Scenario 2: Doctor trying to book (should fail - doctors don't book for themselves)
Write-Host "`n[Scenario 2] Doctor trying to book appointment..." -ForegroundColor Yellow
$doctorLogin = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"robert@test.com","password":"password123"}'
$doctorToken = $doctorLogin.data.token

$doctorHeaders = @{
    "Authorization" = "Bearer $doctorToken"
    "Content-Type" = "application/json"
}

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Post -Headers $doctorHeaders -Body $appointmentData
    Write-Host "✅ Doctor booking: SUCCESS (unexpected)" -ForegroundColor Yellow
} catch {
    Write-Host "✅ Doctor booking: FAILED (expected - doctors don't have patient profiles)" -ForegroundColor Green
    if ($_.ErrorDetails.Message) {
        $error = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "   Error: $($error.message)" -ForegroundColor Cyan
    }
}

# Scenario 3: Admin trying to book (should fail - admins don't book)
Write-Host "`n[Scenario 3] Admin trying to book appointment..." -ForegroundColor Yellow
$adminLogin = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"admin@test.com","password":"password123"}'
$adminToken = $adminLogin.data.token

$adminHeaders = @{
    "Authorization" = "Bearer $adminToken"
    "Content-Type" = "application/json"
}

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Post -Headers $adminHeaders -Body $appointmentData
    Write-Host "✅ Admin booking: SUCCESS (unexpected)" -ForegroundColor Yellow
} catch {
    Write-Host "✅ Admin booking: FAILED (expected - admins don't have patient profiles)" -ForegroundColor Green
    if ($_.ErrorDetails.Message) {
        $error = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "   Error: $($error.message)" -ForegroundColor Cyan
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Conclusion:" -ForegroundColor Cyan
Write-Host "Only PATIENTS should be able to book appointments" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
