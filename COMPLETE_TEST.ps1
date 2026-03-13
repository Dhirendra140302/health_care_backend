# Complete System Test
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Healthcare Management System - Full Test" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Test 1: Patient Login
Write-Host "[Test 1] Patient Login..." -ForegroundColor Yellow
try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"patient@test.com","password":"password123"}'
    $patientToken = $loginResponse.data.token
    Write-Host "✅ Patient login successful" -ForegroundColor Green
} catch {
    Write-Host "❌ Patient login failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 2: Doctor Login
Write-Host "`n[Test 2] Doctor Login..." -ForegroundColor Yellow
try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"doctor@test.com","password":"password123"}'
    $doctorToken = $loginResponse.data.token
    Write-Host "✅ Doctor login successful" -ForegroundColor Green
} catch {
    Write-Host "❌ Doctor login failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 3: Get Doctors List
Write-Host "`n[Test 3] Fetching Doctors List..." -ForegroundColor Yellow
try {
    $headers = @{ "Authorization" = "Bearer $patientToken" }
    $doctorsResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/doctors" -Method Get -Headers $headers
    $doctorCount = $doctorsResponse.data.Count
    Write-Host "✅ Doctors list retrieved: $doctorCount doctor(s) found" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to fetch doctors: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Book Appointment
Write-Host "`n[Test 4] Booking Appointment..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $patientToken"
        "Content-Type" = "application/json"
    }
    $appointmentData = @{
        doctorId = 1
        startTime = "2026-03-07T11:00:00"
        purposeOfConsultation = "Annual Checkup"
        initialSymptoms = "Routine examination"
    } | ConvertTo-Json
    
    $bookingResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Post -Headers $headers -Body $appointmentData
    Write-Host "✅ Appointment booked successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Appointment booking failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host "   Details: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
}

# Test 5: Get Patient Appointments
Write-Host "`n[Test 5] Fetching Patient Appointments..." -ForegroundColor Yellow
try {
    $headers = @{ "Authorization" = "Bearer $patientToken" }
    $appointmentsResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Get -Headers $headers
    $appointmentCount = $appointmentsResponse.data.Count
    Write-Host "✅ Patient appointments retrieved: $appointmentCount appointment(s)" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to fetch appointments: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 6: Get Doctor Appointments
Write-Host "`n[Test 6] Fetching Doctor Appointments..." -ForegroundColor Yellow
try {
    $headers = @{ "Authorization" = "Bearer $doctorToken" }
    $appointmentsResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Get -Headers $headers
    $appointmentCount = $appointmentsResponse.data.Count
    Write-Host "✅ Doctor appointments retrieved: $appointmentCount appointment(s)" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to fetch doctor appointments: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 7: Get Consultation History
Write-Host "`n[Test 7] Fetching Consultation History..." -ForegroundColor Yellow
try {
    $headers = @{ "Authorization" = "Bearer $patientToken" }
    $historyResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/consultations/history" -Method Get -Headers $headers
    $recordCount = $historyResponse.data.Count
    Write-Host "✅ Consultation history retrieved: $recordCount record(s)" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to fetch history: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "All Tests Completed!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
