# Debug login issues
Write-Host "Testing login endpoint..." -ForegroundColor Yellow

$loginData = @{
    email = "patient@test.com"
    password = "password123"
} | ConvertTo-Json

Write-Host "Request body: $loginData"

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body $loginData -Verbose
    Write-Host "✅ Login successful!" -ForegroundColor Green
    Write-Host "Status Code: $($response.statusCode)"
    Write-Host "Message: $($response.message)"
    Write-Host "Token present: $($null -ne $response.data.token)"
} catch {
    Write-Host "❌ Login failed" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Error: $($_.Exception.Message)"
    if ($_.ErrorDetails.Message) {
        $errorObj = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "Backend Message: $($errorObj.message)"
    }
}
