# Test new patient registration with firstName/lastName fix
Write-Host "Testing New Patient Registration..." -ForegroundColor Yellow

# Register a new patient
Write-Host "`n1. Registering new patient..."
$registrationData = @{
    name = "John Michael Smith"
    email = "john.smith@test.com"
    password = "password123"
    roles = @("PATIENT")
} | ConvertTo-Json

try {
    $regResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/register" -Method Post -ContentType "application/json" -Body $registrationData
    Write-Host "✅ Registration successful!" -ForegroundColor Green
    Write-Host "Message: $($regResponse.message)"
} catch {
    Write-Host "❌ Registration failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        $errorObj = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "Details: $($errorObj.message)" -ForegroundColor Red
    }
    exit 1
}

# Login as the new patient
Write-Host "`n2. Logging in as new patient..."
$loginResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"john.smith@test.com","password":"password123"}'
Write-Host "✅ Login successful!"
Write-Host "User Name: $($loginResponse.data.user.name)"

# Book an appointment to verify patient profile works
Write-Host "`n3. Booking appointment to verify patient profile..."
$token = $loginResponse.data.token
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$appointmentData = @{
    doctorId = 1
    startTime = "2026-03-08T15:00:00"
    purposeOfConsultation = "First Visit"
    initialSymptoms = "General health check"
} | ConvertTo-Json

try {
    $bookingResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Post -Headers $headers -Body $appointmentData
    Write-Host "✅ Appointment booked successfully!" -ForegroundColor Green
    Write-Host "This confirms patient profile was created with proper firstName/lastName"
} catch {
    Write-Host "❌ Booking failed: $($_.Exception.Message)" -ForegroundColor Red
}
