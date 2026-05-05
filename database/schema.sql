DROP DATABASE IF EXISTS laundry_booking_system;
CREATE DATABASE laundry_booking_system;
USE laundry_booking_system;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    role ENUM('admin', 'user', 'vendor') NOT NULL DEFAULT 'user',
    status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    approval_status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vendors (
    vendor_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    vendor_name VARCHAR(120) NOT NULL,
    owner_name VARCHAR(100),
    area VARCHAR(100) NOT NULL,
    contact VARCHAR(40) NOT NULL,
    service_type VARCHAR(120) NOT NULL,
    price_range VARCHAR(80) NOT NULL,
    document_type VARCHAR(50),
    document_path VARCHAR(255),
    approval_status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    admin_remarks VARCHAR(255),
    status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vendors_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE SET NULL
);

CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(10,2) NOT NULL,
    status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE slots (
    slot_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id INT NOT NULL,
    slot_date DATE NOT NULL,
    slot_time VARCHAR(50) NOT NULL,
    availability_status ENUM('available', 'booked', 'unavailable') NOT NULL DEFAULT 'available',
    CONSTRAINT fk_slots_vendor
        FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
        ON DELETE CASCADE
);

CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    vendor_id INT NOT NULL,
    service_id INT NOT NULL,
    slot_id INT NOT NULL,
    pickup_address VARCHAR(255) NOT NULL,
    clothes_type VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    pickup_note VARCHAR(255),
    booking_status ENUM('Pending', 'Accepted', 'Picked Up', 'Washing', 'Ready', 'Delivered', 'Cancelled') NOT NULL DEFAULT 'Pending',
    total_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_bookings_quantity CHECK (quantity > 0),
    CONSTRAINT fk_bookings_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_bookings_vendor
        FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_bookings_service
        FOREIGN KEY (service_id) REFERENCES services(service_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_bookings_slot
        FOREIGN KEY (slot_id) REFERENCES slots(slot_id)
        ON DELETE RESTRICT
);

CREATE TABLE contact_messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL,
    subject VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    booking_id INT,
    rating INT NOT NULL,
    comment VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_feedback_rating CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT fk_feedback_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_feedback_booking
        FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE SET NULL
);

INSERT INTO users (name, email, password, phone, role, status, approval_status) VALUES
('Aashish Ghimire', 'admin@quickwash.com', SHA2('admin123', 256), '9800000001', 'admin', 'active', 'approved'),
('Susmita Rai', 'susmita@example.com', SHA2('user123', 256), '9800000002', 'user', 'active', 'approved'),
('Nischal Karki', 'vendor@quickwash.com', SHA2('vendor123', 256), '9800000003', 'vendor', 'active', 'pending');

INSERT INTO vendors (user_id, vendor_name, area, contact, service_type, price_range, document_path, status) VALUES
(3, 'Himalayan Dhobi Service', 'Dharan-10', '9800000003', 'Wash and Iron, Dry Cleaning', 'Rs. 120 - Rs. 500', NULL, 'active'),
(NULL, 'Itahari Fresh Wash', 'Itahari Chowk', '9811111111', 'Wash Only, Express Service', 'Rs. 120 - Rs. 350', NULL, 'active'),
(NULL, 'Everest Laundry Hub', 'Baneshwor', '9822222222', 'Dry Cleaning, Blanket Wash', 'Rs. 250 - Rs. 800', NULL, 'active'),
(NULL, 'Saptakoshi Cleaners', 'Traffic Chowk', '9833333333', 'Wash and Iron', 'Rs. 120 - Rs. 400', NULL, 'active');

INSERT INTO services (service_name, description, price, status) VALUES
('Wash Only', 'Basic washing service for daily clothes.', 120.00, 'active'),
('Wash and Iron', 'Washing and ironing for office and formal wear.', 180.00, 'active'),
('Dry Cleaning', 'Careful dry cleaning for saree, kurta suruwal, and delicate clothes.', 350.00, 'active'),
('Blanket Wash', 'Heavy blanket washing and drying service.', 400.00, 'active'),
('Express Service', 'Fast same-day washing service when available.', 250.00, 'active');

INSERT INTO slots (vendor_id, slot_date, slot_time, availability_status) VALUES
(1, '2026-05-04', '07:00 AM - 09:00 AM', 'available'),
(1, '2026-05-04', '04:00 PM - 06:00 PM', 'available'),
(2, '2026-05-05', '08:00 AM - 10:00 AM', 'available'),
(3, '2026-05-05', '01:00 PM - 03:00 PM', 'available'),
(4, '2026-05-06', '09:00 AM - 11:00 AM', 'available');
