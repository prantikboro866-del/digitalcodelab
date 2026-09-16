-- ====================================================================
-- Digital Code Lab - Complete MySQL Database Schema
-- Database: digital_code_lab
-- Compatible with MySQL 5.7+, MySQL 8.0+, and MariaDB (XAMPP default)
-- ====================================================================

CREATE DATABASE IF NOT EXISTS `digital_code_lab`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `digital_code_lab`;

-- --------------------------------------------------------------------
-- 1. Table: users
-- Core authentication table for Sign Up, Log In, and Profile data
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(120) NOT NULL COMMENT 'Full user/student display name',
  `email` VARCHAR(180) NOT NULL UNIQUE COMMENT 'Unique login email address',
  `password_hash` VARCHAR(255) NOT NULL COMMENT 'Bcrypt hashed password',
  `callsign` VARCHAR(60) NOT NULL DEFAULT 'AGENT-001' COMMENT 'Sci-fi hacker/cadet callsign',
  `avatar` VARCHAR(255) DEFAULT NULL COMMENT 'Avatar preset icon or image URL',
  `role` VARCHAR(30) NOT NULL DEFAULT 'student' COMMENT 'student, cadet, or instructor',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active, 0 = disabled',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_users_email` (`email`),
  INDEX `idx_users_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Ensure columns exist if table was previously created with older schema
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `role` VARCHAR(30) NOT NULL DEFAULT 'student';
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `is_active` TINYINT(1) NOT NULL DEFAULT 1;
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- --------------------------------------------------------------------
-- 2. Table: user_progress
-- Learning progress, completed roadmap modules, quiz scores, badges
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_progress` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL UNIQUE COMMENT 'Foreign key to users.id',
  `completed_topics` LONGTEXT COMMENT 'JSON array of finished module IDs',
  `quiz_scores` LONGTEXT COMMENT 'JSON object with topic quiz percentages & scores',
  `unlocked_badges` LONGTEXT COMMENT 'JSON array of unlocked achievement badge IDs',
  `last_visited_tab` VARCHAR(50) DEFAULT 'home' COMMENT 'Last active lab tab',
  `total_time_minutes` INT NOT NULL DEFAULT 0 COMMENT 'Total time spent learning in minutes',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Ensure columns exist if table was previously created with older schema
ALTER TABLE `user_progress` ADD COLUMN IF NOT EXISTS `last_visited_tab` VARCHAR(50) DEFAULT 'home';
ALTER TABLE `user_progress` ADD COLUMN IF NOT EXISTS `total_time_minutes` INT NOT NULL DEFAULT 0;

-- --------------------------------------------------------------------
-- 3. Table: certificates
-- Issued verified graduation certificates with cryptographic hash
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `certificates` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NULL COMMENT 'Linked user account or NULL for guest checkout',
  `student_name` VARCHAR(150) NOT NULL COMMENT 'Exact legal or preferred name on certificate',
  `cert_code` VARCHAR(50) NOT NULL UNIQUE COMMENT 'Public verification code e.g. DCL-2026-XXXX',
  `issued_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `score_percent` INT NOT NULL DEFAULT 100 COMMENT 'Graduation quiz score percentage',
  `modules_count` INT NOT NULL DEFAULT 8 COMMENT 'Total modules successfully completed',
  `verification_hash` VARCHAR(100) NOT NULL COMMENT 'SHA256 verification hash fingerprint',
  INDEX `idx_cert_code` (`cert_code`),
  INDEX `idx_cert_user_id` (`user_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 4. Table: quiz_attempts
-- Historical record of all quiz attempts and individual module evaluations
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `quiz_attempts` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL COMMENT 'Foreign key to users.id',
  `topic_id` VARCHAR(50) NOT NULL COMMENT 'Topic identifier e.g. ascii, bcd, matrix',
  `score` INT NOT NULL COMMENT 'Points earned',
  `total_questions` INT NOT NULL COMMENT 'Total questions in quiz',
  `percentage` DECIMAL(5,2) NOT NULL COMMENT 'Percentage score (0.00 - 100.00)',
  `passed` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 = passed (>= 75%), 0 = retry needed',
  `answers_json` LONGTEXT NULL COMMENT 'Optional breakdown of student answers',
  `attempted_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_quiz_user_topic` (`user_id`, `topic_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 5. Table: lab_saved_states
-- User created custom LED Matrix designs, custom Morse, or Playground code
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lab_saved_states` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL COMMENT 'Owner user ID',
  `lab_type` VARCHAR(50) NOT NULL COMMENT 'matrix, morse, playground, or ascii',
  `title` VARCHAR(120) NOT NULL COMMENT 'Name of user save slot',
  `payload_json` LONGTEXT NOT NULL COMMENT 'Serialized state / grid / signal pattern',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_lab_user_type` (`user_id`, `lab_type`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 6. Table: audit_logs
-- Security and event tracking (login attempts, signup, certificate issuance)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `audit_logs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NULL COMMENT 'User ID or NULL for unauthenticated actions',
  `action` VARCHAR(80) NOT NULL COMMENT 'e.g. AUTH_SIGNUP, AUTH_LOGIN, CERT_ISSUED',
  `ip_address` VARCHAR(45) DEFAULT NULL COMMENT 'IPv4 or IPv6 client address',
  `user_agent` VARCHAR(255) DEFAULT NULL,
  `details` TEXT DEFAULT NULL COMMENT 'JSON or descriptive event details',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_audit_user` (`user_id`),
  INDEX `idx_audit_action` (`action`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 7. Seed Initial Demo / Administrator Cadet Account
-- Default Demo User Credentials:
-- Email: demo@code.lab
-- Password: password123 (Bcrypt hash: $2y$10$wT0l0.72Mh90g5N7uE64.uV5Z932B4N24R2x5M6L6O7P8Q9R0S1T2)
-- --------------------------------------------------------------------
INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `callsign`, `avatar`, `role`, `is_active`)
VALUES
(1, 'Cadet Alex Mercer', 'demo@code.lab', '$2y$10$wT0l0.72Mh90g5N7uE64.uV5Z932B4N24R2x5M6L6O7P8Q9R0S1T2', 'CIPHER-PRIME', 'terminal', 'student', 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Seed Demo User Progress
INSERT INTO `user_progress` (`user_id`, `completed_topics`, `quiz_scores`, `unlocked_badges`, `last_visited_tab`, `total_time_minutes`)
VALUES
(1, '["intro","ascii","bcd","binary"]', '{"ascii":{"score":5,"total":5,"percentage":100},"bcd":{"score":4,"total":5,"percentage":80}}', '["first-bit","ascii-ace","byte-bop"]', 'roadmap', 45)
ON DUPLICATE KEY UPDATE `completed_topics` = VALUES(`completed_topics`);

-- Seed a sample verified certificate
INSERT INTO `certificates` (`id`, `user_id`, `student_name`, `cert_code`, `score_percent`, `modules_count`, `verification_hash`)
VALUES
(1, 1, 'Cadet Alex Mercer', 'DCL-2026-X89B2', 98, 8, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855')
ON DUPLICATE KEY UPDATE `student_name` = VALUES(`student_name`);
