-- Initial roles setup
-- This will run on application startup if spring.jpa.hibernate.ddl-auto is set to create or create-drop
-- For 'update' mode, you need to run this manually

INSERT IGNORE INTO roles (name) VALUES ('PATIENT');
INSERT IGNORE INTO roles (name) VALUES ('DOCTOR');
INSERT IGNORE INTO roles (name) VALUES ('ADMIN');
