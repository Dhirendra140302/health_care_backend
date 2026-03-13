# Test appointment booking
Write-Host "Logging in as patient..."
$loginResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"patient@test.com","password":"password123"}'
$token = $loginResponse.data.token
Write-Host "Token received: $($token.Substring(0,20))..."

Write-Host "`nBooking appointment..."
$appointmentData = @{
    doctorId = 1
    startTime = "2026-03-06T10:30:00"
    purposeOfConsultation = "Follow-up Consultation"
    initialSymptoms = "Mild cough"
} | ConvertTo-Json

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

try {
    $bookingResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Post -Headers $headers -Body $appointmentData
    Write-Host "Success! Appointment booked."
    Write-Host "Response: $($bookingResponse | ConvertTo-Json)"
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    Write-Host "Response: $($_.ErrorDetails.Message)"
}
