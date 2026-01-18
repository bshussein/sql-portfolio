-- =============================================================
-- File: eer2_forward_engineering.sql
-- Description:
--   Forward-engineered SQL script from MySQL Workbench EER Model 2.
--   Defines tables and relationships for a different sample domain.
-- =============================================================

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- Create the database
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8;
USE `mydb`;

-- Create the Countries table
CREATE TABLE IF NOT EXISTS `Countries` (
  `country_id` INT AUTO_INCREMENT,
  `country_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`country_id`),
  UNIQUE INDEX `country_name_UNIQUE` (`country_name`)
) ENGINE = InnoDB;

-- Create the Addresses table
CREATE TABLE IF NOT EXISTS `Addresses` (
  `address_id` INT AUTO_INCREMENT,
  `customer_id` INT NULL,
  `street_address` VARCHAR(255) NOT NULL,
  `city` VARCHAR(100) NOT NULL,
  `state` VARCHAR(100) NULL,
  `zip_code` VARCHAR(20) NOT NULL,
  `country_id` INT NULL,
  PRIMARY KEY (`address_id`),
  INDEX `fk_customer_id_idx` (`customer_id`), -- INDEX creates a sorted structure for fast lookup.
  INDEX `fk_country_id_idx` (`country_id`),
  CONSTRAINT `fk_customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `Customers` (`customer_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_country_id`
    FOREIGN KEY (`country_id`)
    REFERENCES `Countries` (`country_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- Create the Customers table
CREATE TABLE IF NOT EXISTS `Customers` (
  `customer_id` INT AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `billing_address_id` INT NULL,
  `shipping_address_id` INT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE INDEX `email_UNIQUE` (`email`),
  INDEX `fk_billing_address_idx` (`billing_address_id`),
  INDEX `fk_shipping_address_idx` (`shipping_address_id`),
  CONSTRAINT `fk_billing_address`
    FOREIGN KEY (`billing_address_id`)
    REFERENCES `Addresses` (`address_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_shipping_address`
    FOREIGN KEY (`shipping_address_id`)
    REFERENCES `Addresses` (`address_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

------------------------------------------------------------------------------

-- Insert sample data into Countries
INSERT INTO Countries (country_name)
VALUES 
    ('United States'),
    ('Japan'),
    ('Fiji'),
    ('Portugal'),
    ('Spain');

-- Insert sample data into Customers
INSERT INTO Customers (email, first_name, last_name, billing_address_id, shipping_address_id)
VALUES
    ('benblanco@gmail.com', 'Ben', 'Blanco', 1, 2), 
    ('chris.new@gmail.com', 'Chris', 'Doe', 3, 3),   
    ('ronaldo.hu@gmail.com', 'Cris', 'Ronaldo', 4, 5);

-- Insert sample data into Addresses
INSERT INTO Addresses (customer_id, street_address, city, state, zip_code, country_id)
VALUES
    (1, '2420 Cogenbury Cir', 'Virginia', 'VA', '23640', 1), 
    (1, 'Silver Tray Rd', 'California', 'CA', '94016', 1),  
    (2, 'Naka-Meguro St', 'Tokyo', 'Tokyo', '153-0061', 2),
    (3, 'Rua Augusta', 'Lisbon', 'Lisbon', '1100-053', 4), 
    (3, 'Plaza Mayor', 'Madrid', 'Madrid', '28012', 5);

-- Query all customers
SELECT * FROM Customers;

-- Query all addresses
SELECT * FROM Addresses;

-- Query all countries
SELECT * FROM Countries;

-- Query customers with their billing and shipping addresses
SELECT 
    c.first_name, 
    c.last_name,
    b.street_address AS billing_address, 
    s.street_address AS shipping_address
FROM Customers c
LEFT JOIN Addresses b ON c.billing_address_id = b.address_id
LEFT JOIN Addresses s ON c.shipping_address_id = s.address_id;

-- Query detailed customer information with billing and shipping addresses and countries
SELECT 
    c.first_name AS customer_first_name,
    c.last_name AS customer_last_name,
    c.email AS customer_email,
    b.street_address AS billing_address,
    b.city AS billing_city,
    b.state AS billing_state,
    b.zip_code AS billing_zip,
    bc.country_name AS billing_country,
    s.street_address AS shipping_address,
    s.city AS shipping_city,
    s.state AS shipping_state,
    s.zip_code AS shipping_zip,
    sc.country_name AS shipping_country
FROM Customers c
LEFT JOIN Addresses b ON c.billing_address_id = b.address_id
LEFT JOIN Countries bc ON b.country_id = bc.country_id
LEFT JOIN Addresses s ON c.shipping_address_id = s.address_id
LEFT JOIN Countries sc ON s.country_id = sc.country_id;

