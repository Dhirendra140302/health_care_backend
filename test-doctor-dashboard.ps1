# Test Doctor Dashboard functionality
Write-Host "Testing Doctor Dashboard..." -ForegroundColor Yellow

# Login as doctor
Write-Host "`n1. Logging in as doctor..."
$loginResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"doctor@test.com","password":"password123"}'
$token = $loginResponse.data.token
Write-Host "✅ Login successful"

# Get doctor's appointments
Write-Host "`n2. Fetching doctor's appointments..."
$headers = @{ "Authorization" = "Bearer $token" }

try {
    $appointmentsResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Get -Headers $headers
    Write-Host "✅ Appointments retrieved: $($appointmentsResponse.data.Count)"
    
    if ($appointmentsResponse.data.Count -gt 0) {
        Write-Host "`nAppointment Details:"
        $appointmentsResponse.data | ForEach-Object {
            Write-Host "  ---"
            Write-Host "  ID: $($_.id)"
            Write-Host "  Patient: $($_.patient.user.name)"
            Write-Host "  Date: $($_.startTime)"
            Write-Host "  Status: $($_.status)"
            Write-Host "  Purpose: $($_.purposeOfConsultation)"
            if ($_.initialSymptoms) {
                Write-Host "  Symptoms: $($_.initialSymptoms)"
            }
            if ($_.meetingLink) {
                Write-Host "  Meeting: $($_.meetingLink)"
            }
        }
        
        # Test completing an appointment
        $scheduledApt = $appointmentsResponse.data | Where-Object { $_.status -eq "SCHEDULED" } | Select-Object -First 1
        if ($scheduledApt) {
            Write-Host "`n3. Testing 'Complete Appointment' functionality..."
            Write-Host "   Attempting to complete appointment ID: $($scheduledApt.id)"
            
            try {
                $completeResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments/complete/$($scheduledApt.id)" -Method Put -Headers $headers
                Write-Host "   ✅ Appointment marked as completed" -ForegroundColor Green
                Write-Host "   Message: $($completeResponse.message)"
            } catch {
                Write-Host "   ❌ Failed to complete appointment" -ForegroundColor Red
                Write-Host "   Error: $($_.ErrorDetails.Message)"
            }
        } else {
            Write-Host "`n3. No scheduled appointments to test completion"
        }
    }
} catch {
    Write-Host "❌ Failed to fetch appointments" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)"
}
