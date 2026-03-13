# Test appointment booking to reproduce the error
Write-Host "Testing appointment booking..." -ForegroundColor Yellow

# Login as patient
$loginResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"alice@test.com","password":"password123"}'
$token = $loginResponse.data.token
Write-Host "Logged in as patient" -ForegroundColor Green

# Try to book appointment
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$appointmentData = @{
    doctorId = 1
    startTime = "2026-03-11T10:00:00"
    purposeOfConsultation = "Test Booking"
    initialSymptoms = "Test symptoms"
} | ConvertTo-Json

Write-Host "`nBooking appointment..."
Write-Host "Request: $appointmentData"

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Post -Headers $headers -Body $appointmentData
    Write-Host "✅ Booking successful!" -ForegroundColor Green
    Write-Host "Response: $($response | ConvertTo-Json)"
} catch {
    Write-Host "❌ Booking failed!" -ForegroundColor Red
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)"
    if ($_.ErrorDetails.Message) {
        $error = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "Error Message: $($error.message)" -ForegroundColor Red
    }
}
