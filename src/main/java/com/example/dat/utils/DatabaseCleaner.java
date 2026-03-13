package com.example.dat.utils;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@RequiredArgsConstructor
@Slf4j
public class DatabaseCleaner {

    private final JdbcTemplate jdbcTemplate;

    @Transactional
    public void clearAllData() {
        log.warn("CLEARING ALL DATABASE RECORDS - THIS CANNOT BE UNDONE!");
        
        try {
            // Disable foreign key checks
            jdbcTemplate.execute("SET FOREIGN_KEY_CHECKS = 0");
            
            // Delete all records (order matters due to foreign keys)
            jdbcTemplate.execute("DELETE FROM consultations");
            log.info("Cleared consultations table");
            
            jdbcTemplate.execute("DELETE FROM appointments");
            log.info("Cleared appointments table");
            
            jdbcTemplate.execute("DELETE FROM notifications");
            log.info("Cleared notifications table");
            
            jdbcTemplate.execute("DELETE FROM password_reset_code");
            log.info("Cleared password_reset_code table");
            
            jdbcTemplate.execute("DELETE FROM doctors");
            log.info("Cleared doctors table");
            
            jdbcTemplate.execute("DELETE FROM patients");
            log.info("Cleared patients table");
            
            jdbcTemplate.execute("DELETE FROM user_roles");
            log.info("Cleared user_roles table");
            
            jdbcTemplate.execute("DELETE FROM users");
            log.info("Cleared users table");
            
            // Re-enable foreign key checks
            jdbcTemplate.execute("SET FOREIGN_KEY_CHECKS = 1");
            
            // Reset auto-increment counters
            jdbcTemplate.execute("ALTER TABLE consultations AUTO_INCREMENT = 1");
            jdbcTemplate.execute("ALTER TABLE appointments AUTO_INCREMENT = 1");
            jdbcTemplate.execute("ALTER TABLE notifications AUTO_INCREMENT = 1");
            jdbcTemplate.execute("ALTER TABLE password_reset_code AUTO_INCREMENT = 1");
            jdbcTemplate.execute("ALTER TABLE doctors AUTO_INCREMENT = 1");
            jdbcTemplate.execute("ALTER TABLE patients AUTO_INCREMENT = 1");
            jdbcTemplate.execute("ALTER TABLE users AUTO_INCREMENT = 1");
            
            log.info("Reset all auto-increment counters");
            log.warn("DATABASE CLEARED SUCCESSFULLY - Roles table preserved");
            
        } catch (Exception e) {
            log.error("Error clearing database: {}", e.getMessage());
            throw e;
        }
    }
}
