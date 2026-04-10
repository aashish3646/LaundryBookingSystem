CREATE DATABASE IF NOT EXISTS laundry_booking_system;
USE laundry_booking_system;

CREATE TABLE users (
                       user_id INT PRIMARY KEY AUTO_INCREMENT,
                       name VARCHAR(100) NOT NULL,
                       email VARCHAR(100) UNIQUE NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       phone VARCHAR(20),
                       role VARCHAR(20) DEFAULT 'user'
);

CREATE TABLE vendors (
                         vendor_id INT PRIMARY KEY AUTO_INCREMENT,
                         vendor_name VARCHAR(100) NOT NULL,
                         area VARCHAR(100),
                         contact VARCHAR(20),
                         service_type VARCHAR(100),
                         price_range VARCHAR(50)
);

CREATE TABLE slots (
                       slot_id INT PRIMARY KEY AUTO_INCREMENT,
                       vendor_id INT,
                       slot_date DATE,
                       slot_time VARCHAR(50),
                       availability_status VARCHAR(20) DEFAULT 'available',
                       FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
);

CREATE TABLE bookings (
                          booking_id INT PRIMARY KEY AUTO_INCREMENT,
                          user_id INT,
                          vendor_id INT,
                          slot_id INT,
                          pickup_address VARCHAR(255),
                          clothes_type VARCHAR(100),
                          quantity INT,
                          pickup_note VARCHAR(255),
                          booking_status VARCHAR(50) DEFAULT 'Pending',
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (user_id) REFERENCES users(user_id),
                          FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id),
                          FOREIGN KEY (slot_id) REFERENCES slots(slot_id)
);