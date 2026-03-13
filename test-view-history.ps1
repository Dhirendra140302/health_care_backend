# Test view history functionality
Write-Host "Testing Medical History View..." -ForegroundColor Yellow

# Login as patient
Write-Host "`n1. Logging in as patient..."
$loginResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"patient@test.com","password":"password123"}'
$token = $loginResponse.data.token
Write-Host "✅ Login successful"

# Get consultation history
Write-Host "`n2. Fetching consultation history..."
$headers = @{ "Authorization" = "Bearer $token" }

try {
    $historyResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/consultations/history" -Method Get -Headers $headers
    Write-Host "✅ History endpoint responded"
    Write-Host "Status Code: $($historyResponse.statusCode)"
    Write-Host "Message: $($historyResponse.message)"
    Write-Host "Records Count: $($historyResponse.data.Count)"
    
    if ($historyResponse.data.Count -gt 0) {
        Write-Host "`nConsultation Records:"
        $historyResponse.data | ForEach-Object {
            Write-Host "  - ID: $($_.id), Date: $($_.consultationDate), Assessment: $($_.assessment)"
        }
    } else {
        Write-Host "`nNo consultation records found (this is expected if no consultations have been created yet)"
    }
} catch {
    Write-Host "❌ Failed to fetch history" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)"
    if ($_.ErrorDetails.Message) {
        Write-Host "Details: $($_.ErrorDetails.Message)"
    }
}

# Get appointments to see if any are completed
Write-Host "`n3. Checking appointments status..."
try {
    $appointmentsResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Get -Headers $headers
    Write-Host "✅ Appointments retrieved: $($appointmentsResponse.data.Count)"
    
    if ($appointmentsResponse.data.Count -gt 0) {
        Write-Host "`nAppointment Statuses:"
        $appointmentsResponse.data | ForEach-Object {
            Write-Host "  - ID: $($_.id), Status: $($_.status), Date: $($_.startTime)"
        }
    }
} catch {
    Write-Host "❌ Failed to fetch appointments" -ForegroundColor Red
}
