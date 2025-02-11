CREATE DATABASE IF NOT EXISTS portfolio2;
use portfolio2;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255),
    cash_balance DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE stocks (
    stock_code VARCHAR(20) UNIQUE NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    stock_code VARCHAR(20) NOT NULL,
    transaction_type ENUM('BUY', 'SELL') NOT NULL,
    quantity DECIMAL(15,2) NOT NULL CHECK (quantity > 0),
    price_per_share DECIMAL(15, 2) NOT NULL CHECK (price_per_share > 0),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (stock_code) REFERENCES stocks(stock_code)
);


CREATE TABLE capital_injections (
    capital_injection_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    injection_date DATE NOT NULL,
    amount DECIMAL(15, 2) NOT NULL CHECK (amount > 0),
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE dividends (
    dividend_id INT AUTO_INCREMENT PRIMARY KEY,
    stock_code VARCHAR(20) NOT NULL,
    payment_date DATE NOT NULL,
    dividend_type VARCHAR(10) NOT NULL CHECK (dividend_type IN ('Cash', 'Stock')),
    cash_amount_per_share DECIMAL(10, 2) NULL,  -- Cho phép giá trị thập phân, ví dụ: 1234.56
    stock_ratio_numerator INT NULL,
    stock_ratio_denominator INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (stock_code) REFERENCES stocks(stock_code)  -- Thêm khóa ngoại
);
-- Tạo bảng portfolio_holdings
CREATE TABLE portfolio_holdings (
    user_id INT NOT NULL,
    stock_code VARCHAR(20) NOT NULL,
    current_quantity INT NOT NULL DEFAULT 0,
    average_cost DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    update_reason VARCHAR(255),
    PRIMARY KEY (user_id, stock_code),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (stock_code) REFERENCES stocks(stock_code),
    CHECK (current_quantity >= 0)
);

-- Tạo trigger để tự động cập nhật portfolio_holdings sau khi thêm transaction mới

DELIMITER //

CREATE TRIGGER after_transaction_insert 
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    DECLARE current_holdings INT;
    DECLARE current_avg_cost DECIMAL(15, 2);
    DECLARE transaction_amount DECIMAL(15, 2);
    
    -- Tính toán giá trị giao dịch
    SET transaction_amount = NEW.quantity * NEW.price_per_share;
    
    -- Update holdings
    SELECT current_quantity, average_cost 
    INTO current_holdings, current_avg_cost
    FROM portfolio_holdings 
    WHERE user_id = NEW.user_id AND stock_code = NEW.stock_code;
    
    IF current_holdings IS NULL THEN
        IF NEW.transaction_type = 'BUY' THEN
            INSERT INTO portfolio_holdings (user_id, stock_code, current_quantity, average_cost)
            VALUES (NEW.user_id, NEW.stock_code, NEW.quantity, NEW.price_per_share * 1.0003);
        END IF;
    ELSE
        IF NEW.transaction_type = 'BUY' THEN
            SET @new_total_cost = (current_holdings * current_avg_cost) + (transaction_amount * 1.0003);
            SET @new_quantity = current_holdings + NEW.quantity;
            SET @new_avg_cost = @new_total_cost / @new_quantity;
            
            UPDATE portfolio_holdings 
            SET current_quantity = @new_quantity,
                average_cost = @new_avg_cost
            WHERE user_id = NEW.user_id AND stock_code = NEW.stock_code;
        ELSE
            SET @new_quantity = current_holdings - NEW.quantity;
            
            IF @new_quantity > 0 THEN
                UPDATE portfolio_holdings 
                SET current_quantity = @new_quantity
                WHERE user_id = NEW.user_id AND stock_code = NEW.stock_code;
            ELSE
                DELETE FROM portfolio_holdings 
                WHERE user_id = NEW.user_id AND stock_code = NEW.stock_code;
            END IF;
        END IF;
    END IF;
    
    -- Update cash balance
    IF NEW.transaction_type = 'BUY' THEN
        UPDATE users 
        SET cash_balance = cash_balance - (transaction_amount * 1.0003)
        WHERE user_id = NEW.user_id;
    ELSE
        UPDATE users 
        SET cash_balance = cash_balance + (transaction_amount * 0.999)
        WHERE user_id = NEW.user_id;
    END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER after_transaction_update 
AFTER UPDATE ON transactions
FOR EACH ROW
BEGIN
    DECLARE current_holdings INT;
    DECLARE current_avg_cost DECIMAL(15, 2);
    DECLARE old_transaction_amount DECIMAL(15, 2);
    DECLARE new_transaction_amount DECIMAL(15, 2);

    -- Calculate transaction amounts
    SET old_transaction_amount = OLD.quantity * OLD.price_per_share;
    SET new_transaction_amount = NEW.quantity * NEW.price_per_share;

    -- Get current holdings
    SELECT current_quantity, average_cost
    INTO current_holdings, current_avg_cost
    FROM portfolio_holdings
    WHERE user_id = OLD.user_id AND stock_code = OLD.stock_code;

    -- Update cash balance
    IF OLD.transaction_type = 'BUY' THEN
        UPDATE users
        SET cash_balance = cash_balance + (old_transaction_amount * 1.0003)
        WHERE user_id = OLD.user_id;
    ELSEIF OLD.transaction_type = 'SELL' THEN
        UPDATE users
        SET cash_balance = cash_balance - (old_transaction_amount * 0.999)
        WHERE user_id = OLD.user_id;
    END IF;

    IF NEW.transaction_type = 'BUY' THEN
        UPDATE users
        SET cash_balance = cash_balance - (new_transaction_amount * 1.0003)
        WHERE user_id = NEW.user_id;
    ELSEIF NEW.transaction_type = 'SELL' THEN
        UPDATE users
        SET cash_balance = cash_balance + (new_transaction_amount * 0.999)
        WHERE user_id = NEW.user_id;
    END IF;

    -- Update holdings
    IF current_holdings IS NOT NULL THEN
        -- Reverse old transaction effect
        IF OLD.transaction_type = 'BUY' THEN
            SET @old_total_cost = (current_holdings * current_avg_cost) - (old_transaction_amount * 1.0003);
            SET @old_quantity = current_holdings - OLD.quantity;
        ELSE
            SET @old_total_cost = (current_holdings * current_avg_cost) + (old_transaction_amount * 0.999);
            SET @old_quantity = current_holdings + OLD.quantity;
        END IF;

        -- Apply new transaction effect
        IF NEW.transaction_type = 'BUY' THEN
            SET @new_total_cost = IFNULL(@old_total_cost, (current_holdings * current_avg_cost)) 
                               + (new_transaction_amount * 1.0003);
            SET @new_quantity = IFNULL(@old_quantity, current_holdings) + NEW.quantity;
            SET @new_avg_cost = @new_total_cost / @new_quantity;

            UPDATE portfolio_holdings
            SET current_quantity = @new_quantity,
                average_cost = @new_avg_cost,
                updated_at = CURRENT_TIMESTAMP
            WHERE user_id = NEW.user_id AND stock_code = NEW.stock_code;
        ELSE
            SET @new_quantity = IFNULL(@old_quantity, current_holdings) - NEW.quantity;

            IF @new_quantity > 0 THEN
                UPDATE portfolio_holdings
                SET current_quantity = @new_quantity,
                    updated_at = CURRENT_TIMESTAMP
                WHERE user_id = NEW.user_id AND stock_code = NEW.stock_code;
            ELSE
                DELETE FROM portfolio_holdings
                WHERE user_id = NEW.user_id AND stock_code = NEW.stock_code;
            END IF;
        END IF;
    END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER after_transaction_delete
AFTER DELETE ON transactions
FOR EACH ROW
BEGIN
    DECLARE current_holdings INT;
    DECLARE current_avg_cost DECIMAL(15, 2);
    DECLARE transaction_amount DECIMAL(15, 2);

    -- Calculate transaction amount
    SET transaction_amount = OLD.quantity * OLD.price_per_share;

    -- Update cash balance
    IF OLD.transaction_type = 'BUY' THEN
        UPDATE users
        SET cash_balance = cash_balance + (transaction_amount * 1.0003)
        WHERE user_id = OLD.user_id;
    ELSEIF OLD.transaction_type = 'SELL' THEN
        UPDATE users
        SET cash_balance = cash_balance - (transaction_amount * 0.999)
        WHERE user_id = OLD.user_id;
    END IF;

    -- Get current holdings
    SELECT current_quantity, average_cost
    INTO current_holdings, current_avg_cost
    FROM portfolio_holdings
    WHERE user_id = OLD.user_id AND stock_code = OLD.stock_code;

    IF current_holdings IS NOT NULL THEN
        IF OLD.transaction_type = 'BUY' THEN
            -- Reverse BUY transaction: decrease quantity, recalculate average cost
            SET @new_total_cost = (current_holdings * current_avg_cost) - (OLD.quantity * OLD.price_per_share * 1.0003);
            SET @new_quantity = current_holdings - OLD.quantity;

            IF @new_quantity > 0 THEN
                SET @new_avg_cost = @new_total_cost / @new_quantity;
                UPDATE portfolio_holdings
                SET current_quantity = @new_quantity,
                    average_cost = @new_avg_cost,
                    updated_at = CURRENT_TIMESTAMP
                WHERE user_id = OLD.user_id AND stock_code = OLD.stock_code;
            ELSE
                DELETE FROM portfolio_holdings
                WHERE user_id = OLD.user_id AND stock_code = OLD.stock_code;
            END IF;
        ELSE 
            -- Reverse SELL transaction: increase quantity
            SET @new_quantity = current_holdings + OLD.quantity;
            UPDATE portfolio_holdings
            SET current_quantity = @new_quantity,
                updated_at = CURRENT_TIMESTAMP
            WHERE user_id = OLD.user_id AND stock_code = OLD.stock_code;
        END IF;
    END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER before_transaction_insert_cash_check
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
    DECLARE cash_balance DECIMAL(15, 2);
    DECLARE transaction_amount DECIMAL(15, 2);

    -- Check only for BUY transactions
    IF NEW.transaction_type = 'BUY' THEN
        -- Get user's current cash balance
        SELECT u.cash_balance INTO cash_balance
        FROM users u
        WHERE u.user_id = NEW.user_id;

        -- Calculate transaction amount
        SET transaction_amount = NEW.quantity * NEW.price_per_share;

        -- Check if cash balance is insufficient
        IF cash_balance IS NULL OR cash_balance < transaction_amount * 1.0003 THEN
            -- Raise error with details
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient cash balance for transaction';
        END IF;
    END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER after_capital_injection_insert_increase_cash
AFTER INSERT ON capital_injections
FOR EACH ROW
BEGIN
    -- Tăng cash_balance trong cash_accounts cho user_id tương ứng
    UPDATE users
    SET cash_balance = cash_balance + NEW.amount
    WHERE user_id = NEW.user_id;
END//

DELIMITER ;

DELIMITER //
CREATE TRIGGER after_capital_injection_delete_decrease_cash
AFTER DELETE ON capital_injections
FOR EACH ROW
BEGIN
    -- Giảm cash_balance trong cash_accounts cho user_id tương ứng
    UPDATE users
    SET cash_balance = cash_balance - OLD.amount
    WHERE user_id = OLD.user_id;
END//

DELIMITER ;

DELIMITER //
CREATE TRIGGER after_capital_injection_update_adjust_cash
AFTER UPDATE ON capital_injections
FOR EACH ROW
BEGIN
    -- Tính toán sự thay đổi số dư tiền mặt
    SET @change_amount = NEW.amount - OLD.amount;

    -- Cập nhật số dư tiền mặt cho user_id tương ứng
    UPDATE users
    SET cash_balance = cash_balance + @change_amount
    WHERE user_id = NEW.user_id;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER after_dividend_insert
AFTER INSERT ON dividends
FOR EACH ROW
BEGIN
    IF NEW.dividend_type = 'Stock' THEN
        -- Calculate stock dividend percentage
        SET @percentage = NEW.stock_ratio_numerator / NEW.stock_ratio_denominator;
        
        -- Update holdings for stock dividend
        UPDATE portfolio_holdings 
        SET current_quantity = current_quantity * (1 + @percentage * 0.95),
            average_cost = average_cost / (1 + @percentage * 0.95),
            update_reason = 'Stock Dividend',
            updated_at = CURRENT_TIMESTAMP
        WHERE stock_code = NEW.stock_code;
        
    ELSEIF NEW.dividend_type = 'Cash' THEN
        -- Update user balances for cash dividend
        UPDATE users u
        JOIN portfolio_holdings ph 
            ON u.user_id = ph.user_id 
            AND ph.stock_code = NEW.stock_code
        SET u.cash_balance = u.cash_balance + (ph.current_quantity * NEW.cash_amount_per_share * 0.95);
        
        -- Update average cost
        UPDATE portfolio_holdings 
        SET average_cost = average_cost - NEW.cash_amount_per_share,
            update_reason = 'Cash Dividend',
            updated_at = CURRENT_TIMESTAMP
        WHERE stock_code = NEW.stock_code;
    END IF;
END//

DELIMITER ;


INSERT INTO users (name, contact_info) 
VALUES 
('Đinh Việt Hoàng','0865003498'),
('Đinh Thị Huyền Trang', '0979150764'),
('Trịnh Khắc Quang','0862863144'),
('Đinh Việt Đức','0393374311'),
('Nguyễn Trí Minh','');

INSERT INTO stocks (stock_code, company_name)
VALUES 
('HPG', 'Công ty cổ phần tập đoàn Hòa Phát'),
('MBB', 'Ngân Hàng thương mại cổ phần quân đội'),
('RAL', 'Bóng đèn phích nước Rạng Đông');

INSERT INTO capital_injections 
(user_id, injection_date, amount, description, created_at, updated_at) 
VALUES 
-- Initial investments - October 2024
(1, '2024-10-18', 271000.00,  'Lần mua cổ phiếu đầu tiên (HPG)',                                    '2025-02-04 16:56:30', '2025-02-04 18:07:01'),
(3, '2024-10-27', 500000.00,  'Lần đầu mua cổ phiếu',                                               '2025-02-05 08:51:52', '2025-02-05 08:51:52'),

-- November 2024
(2, '2024-11-11', 2000000.00, 'góp vốn tháng 11',                                                   '2025-02-05 08:52:38', '2025-02-05 08:52:38'),
(1, '2024-11-11', 450000.00,  'Chị cho 500k tiền quản lý, đầu tư 450k để vừa mua đủ 100 cổ phiếu MB', '2025-02-05 08:54:31', '2025-02-05 08:54:31'),
(1, '2024-11-28', 300000.00,  'góp vốn cuối tháng 11 lần 1',                                        '2025-02-05 08:55:30', '2025-02-05 08:55:30'),
(1, '2024-11-28', 500000.00,  'góp vốn cuối tháng 11 lần 2',                                        '2025-02-05 08:55:46', '2025-02-05 08:55:46'),

-- December 2024
(2, '2024-12-10', 2000000.00, 'góp vốn tháng 12',                                                   '2025-02-05 08:52:55', '2025-02-05 08:52:55'),
(1, '2024-12-11', 500000.00,  'tiền chị cho quản lý tài khoản tháng 12',                           '2025-02-05 08:58:43', '2025-02-05 08:58:43'),
(5, '2024-12-19', 505000.00,  'Góp vốn lần đầu mua cổ phiếu rạng đông',                           '2025-02-05 08:58:10', '2025-02-05 08:58:10'),

-- January 2025
(1, '2024-01-08', 1040000.00, 'Tăng vốn tháng 1 2025',                                                   '2025-02-05 08:59:29', '2025-02-05 08:59:29'),
(1, '2024-01-10', 500000.00,  'Tiền chị cho quản lý tài khoản tháng 1',                            '2025-02-05 09:00:40', '2025-02-05 09:00:40'),
(1, '2024-01-13', 800000.00,  'Tăng vốn tháng 1 lần 3',                                            '2025-02-05 09:01:25', '2025-02-05 09:01:25'),
(1, '2024-01-13', 400000.00,  'Tăng vốn tháng 1 lần 4',                                            '2025-02-05 09:01:36', '2025-02-05 09:01:36'),
(1, '2024-01-13', 70000.00,   'góp vốn tháng 2',                                                    '2025-02-05 09:25:31', '2025-02-05 09:25:31'),
(1, '2024-01-23', 1900000.00, 'Tăng vốn tháng 1 lần 5',                                            '2025-02-05 09:02:44', '2025-02-05 09:02:44'),
(1, '2024-01-24', 40000.00,   'Tăng vốn tháng 1 lần 6 (mua thêm vài cổ phiếu hòa phát cho đủ 100)','2025-02-05 09:03:22', '2025-02-05 09:03:22'),
(2, '2025-01-10', 2000000.00, 'Góp vốn tháng 1 2025',                                              '2025-02-05 09:04:00', '2025-02-05 09:04:00'),

-- February 2025
(1, '2025-02-05', 30000.00,   'Thêm bù vào phần dùng tiền người khác mua 1 cổ phiếu hòa phát',     '2025-02-05 11:27:57', '2025-02-05 11:27:57'),
(4, '2025-02-10', 3200000.00, 'Góp vốn lần đầu',                                                    '2025-02-10 03:34:54', '2025-02-10 03:34:54'),
(2, '2025-02-10', 2000000.00, 'Góp vốn tháng 2',                                                    '2025-02-10 05:17:10', '2025-02-10 05:17:10'),
(1, '2025-02-10', 800000.00,  'Góp vốn tháng 2',                                                    '2025-02-10 05:17:49', '2025-02-10 05:17:49');

INSERT INTO transactions(user_id, transaction_type, quantity, price_per_share, transaction_date, stock_code) 
VALUES 
(1,'BUY',10,26900.00,'2024-10-18','HPG'),
(3,'BUY',20,24950.00,'2024-10-29','MBB'),
(2,'BUY',82,24300.00,'2024-11-12','MBB'),
(1,'BUY',18,24300.00,'2024-11-12','MBB'),
(1,'BUY',13,24100.00,'2024-11-28','MBB'),
(1,'BUY',19,24050.00,'2024-11-29','MBB'),
(1,'BUY',2,24350.00,'2024-12-10','MBB'),
(5,'BUY',4,124800.00,'2024-12-10','RAL'),
(2,'BUY',14,124500.00,'2024-12-10','RAL'),
(1,'BUY',40,26200.00,'2025-01-09','HPG'),
(2,'BUY',78,25550.00,'2025-01-13','HPG'),
(1,'BUY',22,25550.00,'2025-01-13','HPG'),
(1,'BUY',47,26000.00,'2025-01-14','HPG'),
(1,'BUY',10,116800.00,'2025-01-24','RAL'),
(2,'BUY',2,123000.00,'2024-12-11','RAL'),
(1,'BUY',4,123000.00,'2024-12-11','RAL'),
(1,'BUY',6,116500.00,'2025-01-24','RAL'),
(1,'BUY',3,26500.00,'2025-01-24','HPG');

INSERT INTO dividends(stock_code, payment_date, dividend_type, cash_amount_per_share, stock_ratio_numerator, stock_ratio_denominator)
VALUES ('MBB', '2025-01-07', 'Stock', NULL, 15, 100);

INSERT INTO transactions(user_id, transaction_type, quantity, price_per_share, transaction_date, stock_code)
VALUES
(1,'SELL',52,22880.00,'2025-02-10','MBB'),
(2,'SELL',82,22880.00,'2025-02-10','MBB'),
(3,'SELL',20,22880.00,'2025-02-10','MBB'),
(4,'BUY',122,26100.00,'2025-02-10','HPG');

INSERT INTO transactions(user_id, transaction_type, quantity, price_per_share, transaction_date, stock_code)
VALUES
(1,'BUY',76,26080.00,'2025-02-10','HPG'),
(2,'BUY',149,26080.00,'2025-02-10','HPG'),
(3,'BUY',17,26080.00,'2025-02-10','HPG');
