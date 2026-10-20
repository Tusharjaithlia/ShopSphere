-- ShopSphere Database Setup Script
CREATE DATABASE IF NOT EXISTS shopsphere;
USE shopsphere;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    mobile VARCHAR(15),
    role VARCHAR(20) DEFAULT 'CUSTOMER',
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Categories Table
CREATE TABLE IF NOT EXISTS categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    status BOOLEAN DEFAULT TRUE
);

-- 3. Products Table
CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT,
    name VARCHAR(150) NOT NULL,
    brand VARCHAR(100),
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0,
    stock INT DEFAULT 0,
    image_url VARCHAR(500),
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

-- 4. User Addresses Table
CREATE TABLE IF NOT EXISTS addresses (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(20) NOT NULL,
    address_type VARCHAR(50) DEFAULT 'HOME',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 5. Coupons Table
CREATE TABLE IF NOT EXISTS coupons (
    coupon_id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_type VARCHAR(20) DEFAULT 'PERCENTAGE', -- PERCENTAGE or FIXED
    discount_value DECIMAL(10,2) NOT NULL,
    minimum_order DECIMAL(10,2) DEFAULT 0,
    maximum_discount DECIMAL(10,2) DEFAULT 0,
    expiry_date DATE,
    status BOOLEAN DEFAULT TRUE
);

-- 6. Orders Table
CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    address_id INT,
    total_amount DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) DEFAULT 0,
    payment_method VARCHAR(50) DEFAULT 'COD',
    payment_status VARCHAR(50) DEFAULT 'PENDING',
    order_status VARCHAR(50) DEFAULT 'PLACED',
    shipping_address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 7. Order Items Table
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    product_name VARCHAR(150),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 8. Payments Table
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    transaction_reference VARCHAR(100),
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(50) DEFAULT 'COMPLETED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- 9. Cart Items Table
CREATE TABLE IF NOT EXISTS cart_items (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 10. Wishlist Table
CREATE TABLE IF NOT EXISTS wishlists (
    wishlist_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id)
);

-- 11. Product Reviews Table
CREATE TABLE IF NOT EXISTS reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Sample Data Seeding
INSERT IGNORE INTO categories (category_id, name, description, status) VALUES
(1, 'Electronics', 'Electronic gadgets, phones, laptops and accessories', 1),
(2, 'Clothing', 'Men and women fashion, casuals, and apparel', 1),
(3, 'Books', 'Academic, novels, technical and competitive exam books', 1),
(4, 'Home & Kitchen', 'Home appliances, cookware, and decorative items', 1);

INSERT IGNORE INTO products (product_id, category_id, name, brand, description, price, discount, stock, image_url, status) VALUES
(1, 1, 'Dell Inspiron 15 Laptop', 'Dell', 'Core i5 12th Gen, 16GB RAM, 512GB SSD, Windows 11', 54999.00, 5.0, 10, 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500', 1),
(2, 1, 'Sony Wireless Noise Cancelling Headphones', 'Sony', 'Over-ear Bluetooth headphones with 30-hour battery life', 14990.00, 10.0, 25, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500', 1),
(3, 1, 'Logitech Mechanical Wireless Keyboard', 'Logitech', 'Tactile switches with multi-device Bluetooth support', 3499.00, 0.0, 15, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=500', 1),
(4, 2, 'Classic Denim Jacket', 'Levis', 'Comfortable stretch cotton denim jacket for men and women', 2499.00, 15.0, 30, 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=500', 1),
(5, 2, 'Premium Cotton Crew-Neck T-Shirt', 'Puma', '100% combed breathable cotton casual wear', 799.00, 0.0, 50, 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500', 1),
(6, 3, 'Core Java: Fundamentals (Volume 1)', 'Cay S. Horstmann', 'Comprehensive guide to modern Java concepts, OOP, and APIs', 899.00, 5.0, 40, 'https://images.unsplash.com/photo-1532012164546-f432f2e3edd4?w=500', 1),
(7, 3, 'Clean Code: A Handbook of Agile Craftmanship', 'Robert C. Martin', 'Best practices and patterns for writing robust maintainable code', 749.00, 0.0, 20, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=500', 1),
(8, 4, 'Stainless Steel Chef Knife Set', 'KitchenPro', '5-piece ergonomic precision kitchen knives with block', 1999.00, 10.0, 15, 'https://images.unsplash.com/photo-1593618998160-e34014e67546?w=500', 1);

INSERT IGNORE INTO users (name, email, password, phone, mobile, role, status) VALUES
('Admin User', 'admin@shopsphere.com', 'admin123', '9876543210', '9876543210', 'ADMIN', 1),
('John Doe', 'john@example.com', 'customer123', '9876543211', '9876543211', 'CUSTOMER', 1);

INSERT IGNORE INTO coupons (code, discount_type, discount_value, minimum_order, maximum_discount, expiry_date, status) VALUES
('WELCOME10', 'PERCENTAGE', 10.00, 500.00, 200.00, '2028-12-31', 1),
('FLAT50', 'FIXED', 50.00, 300.00, 50.00, '2028-12-31', 1);