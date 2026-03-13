# Test new doctor login
Write-Host "Testing login for newly registered doctor..." -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"sarah.johnson@test.com","password":"password123"}'
    Write-Host "✅ Login successful!" -ForegroundColor Green
    Write-Host "Token: $($response.data.token.Substring(0,30))..."
    Write-Host "User: $($response.data.user.name)"
    Write-Host "Roles: $($response.data.user.roles -join ', ')"
} catch {
    Write-Host "❌ Login failed" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)"
    if ($_.ErrorDetails.Message) {
        Write-Host "Details: $($_.ErrorDetails.Message)"
    }
}
