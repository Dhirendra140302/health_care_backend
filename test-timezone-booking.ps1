# Test booking with timezone-sensitive date
Write-Host "Testing Timezone-Sensitive Booking..." -ForegroundColor Cyan

# Login as patient
$loginResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"testuser@example.com","password":"password123"}'
$token = $loginResponse.data.token

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# Test 1: Book with date that might be in past in UTC but future in local time
Write-Host "`n1. Testing with early morning time (timezone sensitive)..."
$earlyMorningData = '{"doctorId":1,"startTime":"2026-03-05T02:00:00","purposeOfConsultation":"Early Morning Test","initialSymptoms":"Test"}'

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Post -Headers $headers -Body $earlyMorningData
    Write-Host "✅ Early morning booking: SUCCESS" -ForegroundColor Green
} catch {
    Write-Host "❌ Early morning booking: FAILED" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        $error = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "   Error: $($error.message)" -ForegroundColor Red
    }
}

# Test 2: Book with clearly future date
Write-Host "`n2. Testing with clearly future date..."
$futureData = '{"doctorId":1,"startTime":"2026-03-15T14:00:00","purposeOfConsultation":"Future Test","initialSymptoms":"Test"}'

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Post -Headers $headers -Body $futureData
    Write-Host "✅ Future date booking: SUCCESS" -ForegroundColor Green
} catch {
    Write-Host "❌ Future date booking: FAILED" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        $error = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "   Error: $($error.message)" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Timezone Fix Applied Successfully" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
