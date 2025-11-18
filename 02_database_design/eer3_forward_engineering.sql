-- =============================================================
-- File: eer3_forward_engineering.sql
-- Description:
--   Forward-engineered SQL script from MySQL Workbench EER Model 3.
--   Includes table definitions, foreign keys, and sample data.
-- =============================================================

-- Disable foreign key checks temporarily
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- Create the database
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8;
USE `mydb`;

-- Create the Member table
CREATE TABLE IF NOT EXISTS `Member` (
  `member_id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NULL,
  `first_name` VARCHAR(100) NULL,
  `last_name` VARCHAR(100) NULL,
  UNIQUE INDEX `email_UNIQUE` (`email`),
  PRIMARY KEY (`member_id`)
) ENGINE = InnoDB;

-- Create the Group table
CREATE TABLE IF NOT EXISTS `Group` (
  `group_id` INT AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  PRIMARY KEY (`group_id`),
  UNIQUE INDEX `name_UNIQUE` (`name`)
) ENGINE = InnoDB;

-- Create the Membership table
CREATE TABLE IF NOT EXISTS `Membership` (
  `member_id` INT NOT NULL,
  `group_id` INT NULL,
  PRIMARY KEY (`member_id`, `group_id`),
  INDEX `fk_group_id_idx` (`group_id`),
  CONSTRAINT `fk_member_id`
    FOREIGN KEY (`member_id`)
    REFERENCES `Member` (`member_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_group_id`
    FOREIGN KEY (`group_id`)
    REFERENCES `Group` (`group_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- Re-enable original settings
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Insert data into Member table
INSERT INTO Member (email, first_name, last_name)
VALUES 
    ('benblanco@gmail.com', 'Ben', 'Blanco'), 
    ('chris.newman@gmail.com', 'Chris', 'Newman'),   
    ('ronaldo.hu@gmail.com', 'Cris', 'Ronaldo');

-- Insert data into Group table
INSERT INTO `Group` (name)
VALUES
    ('Gaming Club'),
    ('Weightlifting Club'),
    ('Pickleball Club');

-- Insert data into Membership table
INSERT INTO Membership (member_id, group_id)
VALUES
    (1, 1), -- Ben belongs to Gaming Club
    (1, 2), -- Ben belongs to Weightlifting Club
    (2, 2), -- Chris belongs to Weightlifting Club
    (3, 3); -- Ronaldo belongs to Pickleball Club

-- Query all tables
SELECT * FROM Member;

SELECT * FROM `Group`;

SELECT * FROM Membership;

-- Display member ID, member's full name, and group name
SELECT 
    mem.member_id AS `Member ID`,
    CONCAT(m.first_name, ' ', m.last_name) AS `Full Name`,
    g.name AS `Group Name`
FROM Membership mem
JOIN Member m ON mem.member_id = m.member_id
JOIN `Group` g ON mem.group_id = g.group_id
ORDER BY mem.member_id, g.name;

-- Count the number of groups each member is in
SELECT 
    m.member_id AS `Member ID`,
    CONCAT(m.first_name, ' ', m.last_name) AS `Full Name`,
    COUNT(g.group_id) AS `Number of Groups`
FROM Membership mem
JOIN Member m ON mem.member_id = m.member_id
JOIN `Group` g ON mem.group_id = g.group_id
GROUP BY m.member_id
ORDER BY `Number of Groups` DESC;

