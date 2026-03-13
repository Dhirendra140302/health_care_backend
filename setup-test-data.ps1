# Setup test data for Admin Dashboard
Write-Host "Setting up test data..." -ForegroundColor Cyan

# Register a patient
Write-Host "`n1. Registering patient..."
$patientData = '{"name":"Alice Johnson","email":"alice@test.com","password":"password123","roles":["PATIENT"]}'
try {
    Invoke-RestMethod -Uri "http://localhost:8086/api/auth/register" -Method Post -ContentType "application/json" -Body $patientData | Out-Null
    Write-Host "✅ Patient registered" -ForegroundColor Green
} catch {
    Write-Host "Patient already exists" -ForegroundColor Yellow
}

# Register a doctor
Write-Host "`n2. Registering doctor..."
$doctorData = '{"name":"Dr. Robert Brown","email":"robert@test.com","password":"password123","roles":["DOCTOR"],"licenseNumber":"DOC11111","specialization":"CARDIOLOGY"}'
try {
    Invoke-RestMethod -Uri "http://localhost:8086/api/auth/register" -Method Post -ContentType "application/json" -Body $doctorData | Out-Null
    Write-Host "✅ Doctor registered" -ForegroundColor Green
} catch {
    Write-Host "Doctor already exists" -ForegroundColor Yellow
}

# Login as patient and book appointment
Write-Host "`n3. Booking appointment..."
$loginResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"alice@test.com","password":"password123"}'
$token = $loginResponse.data.token

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$appointmentData = '{"doctorId":1,"startTime":"2026-03-10T14:00:00","purposeOfConsultation":"General Checkup","initialSymptoms":"Routine examination"}'
try {
    Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Post -Headers $headers -Body $appointmentData | Out-Null
    Write-Host "✅ Appointment booked" -ForegroundColor Green
} catch {
    Write-Host "Appointment booking failed or already exists" -ForegroundColor Yellow
}

# Test admin access
Write-Host "`n4. Testing admin access..."
$adminLogin = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"admin@test.com","password":"password123"}'
$adminToken = $adminLogin.data.token
$adminHeaders = @{ "Authorization" = "Bearer $adminToken" }

$users = Invoke-RestMethod -Uri "http://localhost:8086/api/users/all" -Method Get -Headers $adminHeaders
$doctors = Invoke-RestMethod -Uri "http://localhost:8086/api/doctors" -Method Get -Headers $adminHeaders
$appointments = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Get -Headers $adminHeaders

Write-Host "✅ Admin can view:" -ForegroundColor Green
Write-Host "   - Users: $($users.data.Count)" -ForegroundColor Cyan
Write-Host "   - Doctors: $($doctors.data.Count)" -ForegroundColor Cyan
Write-Host "   - Appointments: $($appointments.data.Count)" -ForegroundColor Cyan

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Test Data Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nAdmin Login:" -ForegroundColor White
Write-Host "  URL: http://localhost:3000/login" -ForegroundColor Cyan
Write-Host "  Email: admin@test.com" -ForegroundColor Cyan
Write-Host "  Password: password123" -ForegroundColor Cyan
