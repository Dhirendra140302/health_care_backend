# Test consultation history endpoint
Write-Host "Logging in as patient..."
$loginResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"patient@test.com","password":"password123"}'
$token = $loginResponse.data.token
Write-Host "Token received"

Write-Host "`nFetching consultation history..."
$headers = @{
    "Authorization" = "Bearer $token"
}

try {
    $historyResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/consultations/history" -Method Get -Headers $headers
    Write-Host "Success! History retrieved."
    Write-Host "Response: $($historyResponse | ConvertTo-Json -Depth 3)"
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    if ($_.ErrorDetails.Message) {
        Write-Host "Response: $($_.ErrorDetails.Message)"
    }
}
