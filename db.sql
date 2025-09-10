-- Drop tables in a specific order to avoid foreign key constraint issues
DROP TABLE IF EXISTS Saved_Properties;
DROP TABLE IF EXISTS Property_Features;
DROP TABLE IF EXISTS Properties;
DROP TABLE IF EXISTS Agents;
DROP TABLE IF EXISTS Agencies;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Features;
DROP TABLE IF EXISTS Property_Types;
DROP TABLE IF EXISTS Locations;

-- Create Users table
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Locations table (e.g., neighborhoods, cities)
CREATE TABLE Locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    zip_code VARCHAR(20)
);

-- Create Property_Types table (e.g., house, apartment, condo)
CREATE TABLE Property_Types (
    property_type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL UNIQUE
);


-- Create Agencies table
CREATE TABLE Agencies (
    agency_id INT PRIMARY KEY AUTO_INCREMENT,
    agency_name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(100),
    phone_number VARCHAR(20),
    website_url VARCHAR(255)
);

-- Create Agents table
CREATE TABLE Agents (
    agent_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    contact_email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    agency_id INT,
    FOREIGN KEY (agency_id) REFERENCES Agencies(agency_id) ON DELETE SET NULL
);

-- Create Properties table
CREATE TABLE Properties (
    property_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(15, 2) NOT NULL,
    bedrooms INT,
    bathrooms DECIMAL(3, 1),
    area_sqft INT,
    is_for_sale BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    address VARCHAR(255) NOT NULL,
    location_id INT,
    property_type_id INT,
    agent_id INT,
    listing_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id),
    FOREIGN KEY (property_type_id) REFERENCES Property_Types(property_type_id),
    FOREIGN KEY (agent_id) REFERENCES Agents(agent_id) ON DELETE SET NULL
);

-- Create Features table (e.g., pool, gym, balcony)
CREATE TABLE Features (
    feature_id INT PRIMARY KEY AUTO_INCREMENT,
    feature_name VARCHAR(100) NOT NULL UNIQUE
);

-- Create a linking table for Properties and Features (many-to-many relationship)
CREATE TABLE Property_Features (
    property_id INT,
    feature_id INT,
    PRIMARY KEY (property_id, feature_id),
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (feature_id) REFERENCES Features(feature_id) ON DELETE CASCADE
);

-- Create a linking table for Users and Properties (e.g., a "saved" list)
CREATE TABLE Saved_Properties (
    user_id INT,
    property_id INT,
    saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, property_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE
);

-- Seed data for all tables
-- Users
INSERT INTO Users (username, email, password_hash, first_name, last_name) VALUES
('johnMwangi', 'john.mwangi@example.com', 'password123', 'John', 'Mwangi'),
('janeChebet', 'jane.chebet@example.com', 'password456', 'Jane', 'Chebet'),
('peterWamalwa', 'peter.wamalwa@example.com', 'password789', 'Peter', 'Wamalwa');

-- Locations
INSERT INTO Locations (city, country, zip_code) VALUES
('Nairobi', 'Kenya', '00100'),
('Mombasa', 'Kenya', '80100'),
('Kisumu', 'Kenya', '40100'),
('Lavington', 'Kenya', '00100');

-- Property_Types
INSERT INTO Property_Types (type_name) VALUES
('Apartment'),
('House'),
('Condo'),
('Townhouse');

-- Agencies
INSERT INTO Agencies (agency_name, contact_email, phone_number) VALUES
('Urban Dwellings Inc.', 'info@urbandwellings.com', '0722334455'),
('Coastal Properties', 'contact@coastalprop.com', '0712345678');

-- Agents
INSERT INTO Agents (first_name, last_name, contact_email, phone_number, agency_id) VALUES
('Michael', 'Kiptoo', 'michael.kiptoo@urbandwellings.com', '0722334455', 1),
('Leslie', 'Wanjiku', 'leslie.wanjiku@coastalprop.com', '0712345678', 2),
('Dwight', 'Too', 'dwight.too@urbandwellings.com', '0787654321', 1);

-- Properties
INSERT INTO Properties (title, description, price, bedrooms, bathrooms, area_sqft, is_for_sale, is_active, address, location_id, property_type_id, agent_id) VALUES
('Modern Apartment in Kilimani', 'Spacious 2-bedroom apartment with city views.', 15000000.00, 2, 2.0, 1200, TRUE, TRUE, 'Kilimani Road, Nairobi', 1, 1, 1),
('Charming Home in Nyali', 'Beautiful house with a large backyard and pool.', 25000000.00, 4, 3.5, 2500, TRUE, TRUE, 'Nyali-Bamburi Rd, Mombasa', 2, 2, 2),
('Kisumu Condo with Lake View', 'Stylish 1-bedroom condo with stunning lake views.', 9500000.00, 1, 1.0, 750, TRUE, TRUE, 'Dunga Road, Kisumu', 3, 3, 3),
('Executive Townhouse in Lavington', 'Newly built townhouse in a gated community', 10000000.00, 4, 4.0, 2800, TRUE, TRUE, 'James Gichuru Road, Lavington', 4, 4, 1);


-- Features
INSERT INTO Features (feature_name) VALUES
('Swimming Pool'),
('Gym'),
('Balcony'),
('Parking Space'),
('Pet-Friendly'),
('Gated Community');

-- Property_Features
INSERT INTO Property_Features (property_id, feature_id) VALUES
(1, 3), (1, 4), (1, 5),
(2, 1), (2, 4), (2, 5),
(3, 2), (3, 3), (3, 4);

-- Saved_Properties
INSERT INTO Saved_Properties (user_id, property_id) VALUES
(1, 2),
(1, 3),
(2, 1);
