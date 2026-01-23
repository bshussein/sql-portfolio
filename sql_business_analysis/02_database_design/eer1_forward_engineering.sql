-- =============================================================
-- File: eer1_forward_engineering.sql
-- Description:
--   Forward-engineered SQL script from MySQL Workbench EER Model 1.
--   Creates the schema, tables, relationships, and constraints
--   defined in the ER diagram.
-- =============================================================

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Categories` (
  `category_id` INT NULL,
  `category_name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Products` (
  `product_id` INT NULL AUTO_INCREMENT,
  `product_name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`product_id`),
  INDEX `fk_products_category_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `fk_products_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `mydb`.`Categories` (`category_id`)
    ON DELETE CASCADE                     
    ON UPDATE CASCADE )
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

---------------------------------------------------------------------------------------------

-- Insert sample data into Categories
INSERT INTO Categories (category_id, category_name, description)
VALUES 
    (1, 'Electronics', 'Devices like TVs and phones'),
    (2, 'Furniture', 'Home items like couches and tables'),
    (3, 'Clothing', 'Clothes for men and women'),
    (4, 'Shoes', 'All types of footwear'),
    (5, 'Toys', 'Figures, dolls, and other kids’ toys');

-- Insert sample data into Products
INSERT INTO Products (product_name, description, price, category_id)
VALUES 
    ('iPhone 16', 'Latest iPhone model with 5G', 999.99, 1),
    ('MacBook Pro', 'High-performance laptop by Apple', 1299.99, 1),
    ('L-Shaped Couch', 'Comfortable L-shaped couch with right armrest', 599.99, 2),
    ('T-shirt', 'Cotton T-shirt', 19.99, 3),
    ('Lebron Basketball Shoes', 'Premium basketball shoes for top performance', 149.99, 4),
    ('Adidas Predator Shoes', 'High-quality Adidas Predator soccer shoes', 89.99, 4),
    ('Bartman Action Figure', 'Bartman figure by Jakks Pacific', 14.99, 5);

-- Query all products
SELECT * FROM Products;

-- Query all categories
SELECT * FROM Categories;

-- Query products with their categories
SELECT p.product_name, p.price, c.category_name
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
ORDER BY p.price DESC;

-- Query total value of products in each category
SELECT c.category_name, SUM(p.price) AS total_value
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY total_value DESC;

