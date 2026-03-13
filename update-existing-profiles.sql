-- Update existing doctor profiles with firstName and lastName
-- Run this in MySQL Workbench or command line: mysql -u root -proot healthcare < update-existing-profiles.sql

-- Update doctors table
UPDATE doctors d
JOIN users u ON d.user_id = u.id
SET 
    d.first_name = SUBSTRING_INDEX(u.name, ' ', 1),
    d.last_name = TRIM(SUBSTRING(u.name, LOCATE(' ', u.name) + 1))
WHERE d.first_name IS NULL OR d.first_name = '';

-- Update patients table
UPDATE patients p
JOIN users u ON p.user_id = u.id
SET 
    p.first_name = SUBSTRING_INDEX(u.name, ' ', 1),
    p.last_name = TRIM(SUBSTRING(u.name, LOCATE(' ', u.name) + 1))
WHERE p.first_name IS NULL OR p.first_name = '';

-- Verify updates
SELECT 'Doctors:' as table_name;
SELECT d.id, u.name as full_name, d.first_name, d.last_name, d.specialization 
FROM doctors d 
JOIN users u ON d.user_id = u.id;

SELECT 'Patients:' as table_name;
SELECT p.id, u.name as full_name, p.first_name, p.last_name 
FROM patients p 
JOIN users u ON p.user_id = u.id;
