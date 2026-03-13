# Test Admin Dashboard functionality
Write-Host "Testing Admin Dashboard..." -ForegroundColor Yellow

# Register an admin user
$adminData = '{"name":"Admin User","email":"admin@test.com","password":"password123","roles":["ADMIN"]}'

try {
    Invoke-RestMethod -Uri "http://localhost:8086/api/auth/register" -Method Post -ContentType "application/json" -Body $adminData | Out-Null
    Write-Host "Admin registered" -ForegroundColor Green
} catch {
    Write-Host "Admin already exists or registration failed" -ForegroundColor Cyan
}

# Login as admin
$loginData = '{"email":"admin@test.com","password":"password123"}'
$loginResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/auth/login" -Method Post -ContentType "application/json" -Body $loginData
$token = $loginResponse.data.token
Write-Host "Admin login successful" -ForegroundColor Green

$headers = @{ "Authorization" = "Bearer $token" }

# Test: Get all users
Write-Host "`nTesting /api/users/all..." -ForegroundColor Yellow
$usersResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/users/all" -Method Get -Headers $headers
Write-Host "Users: $($usersResponse.data.Count)" -ForegroundColor Green

# Test: Get all doctors  
Write-Host "Testing /api/doctors..." -ForegroundColor Yellow
$doctorsResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/doctors" -Method Get -Headers $headers
Write-Host "Doctors: $($doctorsResponse.data.Count)" -ForegroundColor Green

# Test: Get all appointments
Write-Host "Testing /api/appointments..." -ForegroundColor Yellow
$appointmentsResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/appointments" -Method Get -Headers $headers
Write-Host "Appointments: $($appointmentsResponse.data.Count)" -ForegroundColor Green

Write-Host "`nAdmin Dashboard is working!" -ForegroundColor Green
Write-Host "Login at http://localhost:3000/login with admin@test.com / password123" -ForegroundColor Cyan
