# Test appointment booking exactly as frontend does it
Write-Host "Testing Frontend Booking Flow..." -ForegroundColor Cyan

# Step 1: Register a fresh patient
Write-Host "`n1. Registering new patient..."
$patientReg = '{"name":"Test User","email":"testuser@example.com","password":"password123","roles":["PATIENT"]}'
try {
    Invoke-RestMethod -Uri "http://localhost:8086/api/auth/register" -Method Post -ContentType "application/json" -Body $patientReg | Out-Null
    Write-Host "✅ Patient registered" -ForegroundColor Green
} catch {
    Write-Host "Patient may already exist" -ForegroundColor Yellow
}

# Step 2: Login
Write-Host "`n2. Logging in..."
$loginData = '{"email":"testuser@example.com","password":"password123"}'
try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body $loginData
    $token = $loginResponse.data.token
    Write-Host "✅ Login successful" -ForegroundColor Green
    Write-Host "   Token: $($token.Substring(0,30))..."
} catch {
    Write-Host "❌ Login failed" -ForegroundColor Red
    Write-Host "   Error: $($_.ErrorDetails.Message)"
    exit 1
}

# Step 3: Fetch doctors (as frontend does)
Write-Host "`n3. Fetching doctors list..."
$headers = @{ "Authorization" = "Bearer $token" }
try {
    $doctorsResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/doctors" -Method Get -Headers $headers
    $doctors = $doctorsResponse.data
    Write-Host "✅ Doctors fetched: $($doctors.Count)" -ForegroundColor Green
    
    if ($doctors.Count -eq 0) {
        Write-Host "❌ No doctors available to book with!" -ForegroundColor Red
        exit 1
    }
    
    $firstDoctor = $doctors[0]
    Write-Host "   First doctor: ID=$($firstDoctor.id), Name=$($firstDoctor.user.name)"
} catch {
    Write-Host "❌ Failed to fetch doctors" -ForegroundColor Red
    Write-Host "   Error: $($_.ErrorDetails.Message)"
    exit 1
}

# Step 4: Book appointment (exactly as frontend does)
Write-Host "`n4. Booking appointment..."
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# Create date in future (mimicking frontend date picker)
$futureDate = (Get-Date).AddDays(5).ToString("yyyy-MM-ddT10:00:00")

$bookingPayload = @{
    doctorId = [int]$firstDoctor.id
    startTime = $futureDate
    purposeOfConsultation = "General Checkup"
    initialSymptoms = "Routine examination"
} | ConvertTo-Json

Write-Host "   Payload: $bookingPayload"

try {
    $bookingResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Post -Headers $headers -Body $bookingPayload
    Write-Host "✅ Appointment booked successfully!" -ForegroundColor Green
    Write-Host "   Status: $($bookingResponse.statusCode)"
    Write-Host "   Message: $($bookingResponse.message)"
} catch {
    Write-Host "❌ Booking failed!" -ForegroundColor Red
    Write-Host "   Status Code: $($_.Exception.Response.StatusCode.value__)"
    if ($_.ErrorDetails.Message) {
        $error = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "   Error Message: $($error.message)" -ForegroundColor Red
    }
    exit 1
}

# Step 5: Verify appointment was created
Write-Host "`n5. Verifying appointment..."
try {
    $appointmentsResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Get -Headers $headers
    Write-Host "✅ Appointments retrieved: $($appointmentsResponse.data.Count)" -ForegroundColor Green
    
    $latestApt = $appointmentsResponse.data[0]
    Write-Host "   Latest appointment:"
    Write-Host "     ID: $($latestApt.id)"
    Write-Host "     Doctor: $($latestApt.doctor.user.name)"
    Write-Host "     Date: $($latestApt.startTime)"
    Write-Host "     Status: $($latestApt.status)"
} catch {
    Write-Host "❌ Failed to verify" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Frontend Booking Flow: SUCCESS" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
