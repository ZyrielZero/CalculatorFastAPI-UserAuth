-- Module 9: Working with Raw SQL in pgAdmin
-- Run each section in the pgAdmin Query Tool against fastapi_db,
-- screenshotting the output pane after each one.

-- ============================================================
-- (A) Create Tables
-- ============================================================
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE calculations (
    id SERIAL PRIMARY KEY,
    operation VARCHAR(20) NOT NULL,
    operand_a FLOAT NOT NULL,
    operand_b FLOAT NOT NULL,
    result FLOAT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- (B) Insert Records
-- ============================================================
INSERT INTO users (username, email)
VALUES
('alice', 'alice@example.com'),
('bob', 'bob@example.com');

INSERT INTO calculations (operation, operand_a, operand_b, result, user_id)
VALUES
('add', 2, 3, 5, 1),
('divide', 10, 2, 5, 1),
('multiply', 4, 5, 20, 2);

-- ============================================================
-- (C) Query Data
-- ============================================================
-- Retrieve all users
SELECT * FROM users;

-- Retrieve all calculations
SELECT * FROM calculations;

-- Join users and calculations
SELECT u.username, c.operation, c.operand_a, c.operand_b, c.result
FROM calculations c
JOIN users u ON c.user_id = u.id;

-- ============================================================
-- (D) Update a Record
-- ============================================================
UPDATE calculations
SET result = 6
WHERE id = 1;

-- ============================================================
-- (E) Delete a Record
-- ============================================================
DELETE FROM calculations
WHERE id = 2;

-- ============================================================
-- Optional extra: demonstrate the FK cascade explicitly.
-- Deleting user 'bob' also removes his 'multiply' calculation
-- because of ON DELETE CASCADE.
-- ============================================================
DELETE FROM users WHERE username = 'bob';

SELECT * FROM calculations;  -- bob's row is gone via cascade
SELECT * FROM users;         -- only alice remains
