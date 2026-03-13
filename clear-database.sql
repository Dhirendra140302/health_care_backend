-- Clear all database records (keeps table structure and roles)
-- Run this: mysql -u root -proot healthcare < clear-database.sql

USE healthcare;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Clear all tables (order matters due to foreign keys)
DELETE FROM consultations;
DELETE FROM appointments;
DELETE FROM notifications;
DELETE FROM password_reset_code;
DELETE FROM doctors;
DELETE FROM patients;
DELETE FROM user_roles;
DELETE FROM users;
-- Keep roles table (PATIENT, DOCTOR, ADMIN should remain)

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Reset auto-increment counters
ALTER TABLE consultations AUTO_INCREMENT = 1;
ALTER TABLE appointments AUTO_INCREMENT = 1;
ALTER TABLE notifications AUTO_INCREMENT = 1;
ALTER TABLE password_reset_code AUTO_INCREMENT = 1;
ALTER TABLE doctors AUTO_INCREMENT = 1;
ALTER TABLE patients AUTO_INCREMENT = 1;
ALTER TABLE users AUTO_INCREMENT = 1;

-- Verify tables are empty
SELECT 'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'patients', COUNT(*) FROM patients
UNION ALL
SELECT 'doctors', COUNT(*) FROM doctors
UNION ALL
SELECT 'appointments', COUNT(*) FROM appointments
UNION ALL
SELECT 'consultations', COUNT(*) FROM consultations
UNION ALL
SELECT 'notifications', COUNT(*) FROM notifications
UNION ALL
SELECT 'password_reset_code', COUNT(*) FROM password_reset_code
UNION ALL
SELECT 'roles', COUNT(*) FROM roles
UNION ALL
SELECT 'user_roles', COUNT(*) FROM user_roles;

SELECT 'Database cleared successfully! Roles table preserved.' as status;
