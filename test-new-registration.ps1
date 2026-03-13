# Test new registration with firstName/lastName fix
Write-Host "Testing New Registration..." -ForegroundColor Yellow

# Register a new doctor
Write-Host "`n1. Registering new doctor..."
$registrationData = @{
    name = "Dr. Emily Watson"
    email = "emily.watson@test.com"
    password = "password123"
    roles = @("DOCTOR")
    licenseNumber = "DOC55555"
    specialization = "NEUROLOGY"
} | ConvertTo-Json

try {
    $regResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/register" -Method Post -ContentType "application/json" -Body $registrationData
    Write-Host "✅ Registration successful!" -ForegroundColor Green
} catch {
    Write-Host "❌ Registration failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host "Details: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
    exit 1
}

# Login and check doctor details
Write-Host "`n2. Logging in as patient to fetch doctors list..."
$loginResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"patient@test.com","password":"password123"}'
$token = $loginResponse.data.token

$headers = @{ "Authorization" = "Bearer $token" }
$doctorsResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/doctors" -Method Get -Headers $headers

Write-Host "`n3. Checking new doctor's profile..."
$newDoctor = $doctorsResponse.data | Where-Object { $_.licenseNumber -eq "DOC55555" }
if ($newDoctor) {
    Write-Host "✅ New doctor found in database!" -ForegroundColor Green
    Write-Host "   ID: $($newDoctor.id)"
    Write-Host "   Full Name: $($newDoctor.user.name)"
    Write-Host "   First Name: $($newDoctor.firstName)"
    Write-Host "   Last Name: $($newDoctor.lastName)"
    Write-Host "   Specialization: $($newDoctor.specialization)"
    Write-Host "   License: $($newDoctor.licenseNumber)"
    
    if ($newDoctor.firstName -and $newDoctor.lastName) {
        Write-Host "`n✅ firstName and lastName are properly populated!" -ForegroundColor Green
    } else {
        Write-Host "`n⚠️  firstName or lastName is empty" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ New doctor not found" -ForegroundColor Red
}
