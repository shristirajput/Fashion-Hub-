-- Create Database
CREATE DATABASE IF NOT EXISTS product_db;
USE product_db;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('USER', 'ADMIN') DEFAULT 'USER',
    wallet_balance DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Categories Table
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- 3. Products Table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    category_id INT,
    image_url VARCHAR(255),
    type ENUM('NEW', 'USED') DEFAULT 'NEW',
    seller_id INT NULL,
    status ENUM('APPROVED', 'PENDING', 'REJECTED') DEFAULT 'APPROVED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 4. Cart Table
CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 5. Orders Table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('PENDING', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 6. Order Items Table
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 7. Transactions Table (Wallet History)
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_type ENUM('CREDIT', 'DEBIT') NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Reset Data
DELETE FROM transactions;
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM cart;
DELETE FROM products;
DELETE FROM categories;
DELETE FROM users;

-- Insert Admin and User
INSERT INTO users (username, email, password, role, wallet_balance) VALUES
('admin', 'admin@fashionhub.com', 'admin123', 'ADMIN', 10000.00),
('john_doe', 'john@example.com', 'user123', 'USER', 500.00),
('jane_smith', 'jane@example.com', 'user123', 'USER', 150.00);

-- Insert Categories
INSERT INTO categories (id, name, description) VALUES
(1, 'Men', 'Men clothing and accessories'),
(2, 'Women', 'Women clothing and accessories'),
(3, 'Kids', 'Kids clothing and accessories'),
(4, 'Accessories', 'Bags, Watches, Belts'),
(5, 'Shoes', 'All kinds of footwear');

-- Insert Products
INSERT INTO products (name, description, price, stock, category_id, image_url, type, status) VALUES
('Premium White T-Shirt', 'Minimalist organic cotton white tee with a perfect fit.', 999.00, 50, 1, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&q=80', 'NEW', 'APPROVED'),
('Floral Summer Dress', 'Lightweight and breezy floral print dress for sunny days.', 2499.00, 30, 2, 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=800&q=80', 'NEW', 'APPROVED'),
('Leather Craft Wallet', 'Hand-stitched genuine leather wallet with multiple slots.', 1499.00, 100, 4, 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=800&q=80', 'NEW', 'APPROVED'),
('Urban Hoodie', 'Heavyweight cotton oversized hoodie in slate grey.', 1899.00, 40, 1, 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800&q=80', 'NEW', 'APPROVED'),
('Slim Fit Denim', 'Classic blue slim fit jeans with slight distressing.', 2199.00, 60, 1, 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800&q=80', 'NEW', 'APPROVED'),
('Red Streak Sneakers', 'Lightweight mesh running shoes with responsive cushioning.', 3599.00, 25, 5, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&q=80', 'NEW', 'APPROVED'),
('Classic Gold Watch', 'Elegant gold-plated wristwatch with a leather strap.', 4999.00, 15, 4, 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=800&q=80', 'NEW', 'APPROVED'),
('Wool Winter Coat', 'Tailored wool blend coat for maximum warmth and style.', 5999.00, 10, 2, 'https://images.unsplash.com/photo-1539533377285-b9222d9892f7?w=800&q=80', 'NEW', 'APPROVED'),
('Aviator Sunglasses', 'Polarized aviator sunglasses with a gold frame.', 1299.00, 45, 4, 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=800&q=80', 'NEW', 'APPROVED'),
('Canvas Backpack', 'Durable canvas backpack with a dedicated laptop sleeve.', 1799.00, 35, 4, 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800&q=80', 'NEW', 'APPROVED');

-- Insert Used Product (Pending Approval)
INSERT INTO products (name, description, price, stock, category_id, image_url, type, seller_id, status) VALUES
('Vintage Denim Jacket', 'Slightly worn Levi denim jacket with a unique vintage wash.', 1200.00, 1, 1, 'https://images.unsplash.com/photo-1576871337622-98d48d1cf027?w=800&q=80', 'USED', 2, 'PENDING');

-- Insert Transaction History for users
INSERT INTO transactions (user_id, amount, transaction_type, description) VALUES
(2, 500.00, 'CREDIT', 'Initial Wallet Top-up'),
(3, 150.00, 'CREDIT', 'Initial Wallet Top-up');
