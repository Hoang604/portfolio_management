-- MySQL dump 10.13  Distrib 8.0.41, for Linux (x86_64)
--
-- Host: localhost    Database: portfolio2
-- ------------------------------------------------------
-- Server version	8.0.41-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `capital_injections`
--

DROP TABLE IF EXISTS `capital_injections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `capital_injections` (
  `capital_injection_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `injection_date` date NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`capital_injection_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `capital_injections_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `capital_injections_chk_1` CHECK ((`amount` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `capital_injections`
--

LOCK TABLES `capital_injections` WRITE;
/*!40000 ALTER TABLE `capital_injections` DISABLE KEYS */;
INSERT INTO `capital_injections` VALUES (1,1,'2024-10-18',271000.00,'Lần mua cổ phiếu đầu tiên (HPG)','2025-02-04 09:56:30','2025-02-04 11:07:01'),(2,3,'2024-10-27',500000.00,'Lần đầu mua cổ phiếu','2025-02-05 01:51:52','2025-02-05 01:51:52'),(3,2,'2024-11-11',2000000.00,'góp vốn tháng 11','2025-02-05 01:52:38','2025-02-05 01:52:38'),(4,1,'2024-11-11',450000.00,'Chị cho 500k tiền quản lý, đầu tư 450k để vừa mua đủ 100 cổ phiếu MB','2025-02-05 01:54:31','2025-02-05 01:54:31'),(5,1,'2024-11-28',300000.00,'góp vốn cuối tháng 11 lần 1','2025-02-05 01:55:30','2025-02-05 01:55:30'),(6,1,'2024-11-28',500000.00,'góp vốn cuối tháng 11 lần 2','2025-02-05 01:55:46','2025-02-05 01:55:46'),(7,2,'2024-12-10',2000000.00,'góp vốn tháng 12','2025-02-05 01:52:55','2025-02-05 01:52:55'),(8,1,'2024-12-11',500000.00,'tiền chị cho quản lý tài khoản tháng 12','2025-02-05 01:58:43','2025-02-05 01:58:43'),(9,5,'2024-12-19',505000.00,'Góp vốn lần đầu mua cổ phiếu rạng đông','2025-02-05 01:58:10','2025-02-05 01:58:10'),(10,1,'2024-01-08',1040000.00,'Tăng vốn tháng 1 2025','2025-02-05 01:59:29','2025-02-05 01:59:29'),(11,1,'2024-01-10',500000.00,'Tiền chị cho quản lý tài khoản tháng 1','2025-02-05 02:00:40','2025-02-05 02:00:40'),(12,1,'2024-01-13',800000.00,'Tăng vốn tháng 1 lần 3','2025-02-05 02:01:25','2025-02-05 02:01:25'),(13,1,'2024-01-13',400000.00,'Tăng vốn tháng 1 lần 4','2025-02-05 02:01:36','2025-02-05 02:01:36'),(14,1,'2024-01-13',70000.00,'góp vốn tháng 2','2025-02-05 02:25:31','2025-02-05 02:25:31'),(15,1,'2024-01-23',1900000.00,'Tăng vốn tháng 1 lần 5','2025-02-05 02:02:44','2025-02-05 02:02:44'),(16,1,'2024-01-24',40000.00,'Tăng vốn tháng 1 lần 6 (mua thêm vài cổ phiếu hòa phát cho đủ 100)','2025-02-05 02:03:22','2025-02-05 02:03:22'),(17,2,'2025-01-10',2000000.00,'Góp vốn tháng 1 2025','2025-02-05 02:04:00','2025-02-05 02:04:00'),(18,1,'2025-02-05',30000.00,'Thêm bù vào phần dùng tiền người khác mua 1 cổ phiếu hòa phát','2025-02-05 04:27:57','2025-02-05 04:27:57'),(19,4,'2025-02-10',3200000.00,'Góp vốn lần đầu','2025-02-09 20:34:54','2025-02-09 20:34:54'),(20,2,'2025-02-10',2000000.00,'Góp vốn tháng 2','2025-02-09 22:17:10','2025-02-09 22:17:10'),(21,1,'2025-02-10',800000.00,'Góp vốn tháng 2','2025-02-09 22:17:49','2025-02-09 22:17:49');
/*!40000 ALTER TABLE `capital_injections` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`Hoang`@`%`*/ /*!50003 TRIGGER `after_capital_injection_insert_increase_cash` AFTER INSERT ON `capital_injections` FOR EACH ROW BEGIN
    
    UPDATE users
    SET cash_balance = cash_balance + NEW.amount
    WHERE user_id = NEW.user_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`Hoang`@`%`*/ /*!50003 TRIGGER `after_capital_injection_update_adjust_cash` AFTER UPDATE ON `capital_injections` FOR EACH ROW BEGIN
    
    SET @change_amount = NEW.amount - OLD.amount;

    
    UPDATE users
    SET cash_balance = cash_balance + @change_amount
    WHERE user_id = NEW.user_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`Hoang`@`%`*/ /*!50003 TRIGGER `after_capital_injection_delete_decrease_cash` AFTER DELETE ON `capital_injections` FOR EACH ROW BEGIN
    
    UPDATE users
    SET cash_balance = cash_balance - OLD.amount
    WHERE user_id = OLD.user_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `dividends`
--

DROP TABLE IF EXISTS `dividends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dividends` (
  `dividend_id` int NOT NULL AUTO_INCREMENT,
  `stock_code` varchar(20) NOT NULL,
  `payment_date` date NOT NULL,
  `dividend_type` varchar(10) NOT NULL,
  `cash_amount_per_share` decimal(10,2) DEFAULT NULL,
  `stock_ratio_numerator` int DEFAULT NULL,
  `stock_ratio_denominator` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`dividend_id`),
  KEY `stock_code` (`stock_code`),
  CONSTRAINT `dividends_ibfk_1` FOREIGN KEY (`stock_code`) REFERENCES `stocks` (`stock_code`),
  CONSTRAINT `dividends_chk_1` CHECK ((`dividend_type` in (_utf8mb4'Cash',_utf8mb4'Stock')))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dividends`
--

LOCK TABLES `dividends` WRITE;
/*!40000 ALTER TABLE `dividends` DISABLE KEYS */;
INSERT INTO `dividends` VALUES (1,'MBB','2025-01-07','Stock',NULL,15,100,'2025-02-10 08:25:52','2025-02-10 08:25:52');
/*!40000 ALTER TABLE `dividends` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`Hoang`@`%`*/ /*!50003 TRIGGER `after_dividend_insert` AFTER INSERT ON `dividends` FOR EACH ROW BEGIN
    IF NEW.dividend_type = 'Stock' THEN
        
        SET @percentage = NEW.stock_ratio_numerator / NEW.stock_ratio_denominator;
        
        
        UPDATE portfolio_holdings 
        SET current_quantity = current_quantity * (1 + @percentage * 0.95),
            average_cost = average_cost / (1 + @percentage * 0.95),
            update_reason = 'Stock Dividend',
            updated_at = CURRENT_TIMESTAMP
        WHERE stock_code = NEW.stock_code;
        
    ELSEIF NEW.dividend_type = 'Cash' THEN
        
        UPDATE users u
        JOIN portfolio_holdings ph 
            ON u.user_id = ph.user_id 
            AND ph.stock_code = NEW.stock_code
        SET u.cash_balance = u.cash_balance + (ph.current_quantity * NEW.cash_amount_per_share * 0.95);
        
        
        UPDATE portfolio_holdings 
        SET average_cost = average_cost - NEW.cash_amount_per_share,
            update_reason = 'Cash Dividend',
            updated_at = CURRENT_TIMESTAMP
        WHERE stock_code = NEW.stock_code;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `portfolio_holdings`
--

DROP TABLE IF EXISTS `portfolio_holdings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_holdings` (
  `user_id` int NOT NULL,
  `stock_code` varchar(20) NOT NULL,
  `current_quantity` int NOT NULL DEFAULT '0',
  `average_cost` decimal(15,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`,`stock_code`),
  KEY `stock_code` (`stock_code`),
  CONSTRAINT `portfolio_holdings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `portfolio_holdings_ibfk_2` FOREIGN KEY (`stock_code`) REFERENCES `stocks` (`stock_code`),
  CONSTRAINT `portfolio_holdings_chk_1` CHECK ((`current_quantity` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_holdings`
--

LOCK TABLES `portfolio_holdings` WRITE;
/*!40000 ALTER TABLE `portfolio_holdings` DISABLE KEYS */;
INSERT INTO `portfolio_holdings` VALUES (1,'HPG',198,26081.96,'2025-02-10 08:25:52','2025-02-10 08:34:44',NULL),(1,'MBB',7,21153.45,'2025-02-10 08:25:52','2025-02-10 08:25:52','Stock Dividend'),(1,'RAL',20,117985.39,'2025-02-10 08:25:52','2025-02-10 08:25:52',NULL),(2,'HPG',227,25905.66,'2025-02-10 08:25:52','2025-02-10 08:34:44',NULL),(2,'MBB',12,21275.53,'2025-02-10 08:25:52','2025-02-10 08:25:52','Stock Dividend'),(2,'RAL',16,124349.79,'2025-02-10 08:25:52','2025-02-10 08:25:52',NULL),(3,'HPG',17,26087.82,'2025-02-10 08:34:44','2025-02-10 08:34:44',NULL),(3,'MBB',3,21844.63,'2025-02-10 08:25:52','2025-02-10 08:25:52','Stock Dividend'),(4,'HPG',122,26107.83,'2025-02-10 08:25:52','2025-02-10 08:25:52',NULL),(5,'RAL',4,124837.44,'2025-02-10 08:25:52','2025-02-10 08:25:52',NULL);
/*!40000 ALTER TABLE `portfolio_holdings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stocks`
--

DROP TABLE IF EXISTS `stocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stocks` (
  `stock_code` varchar(20) NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `stock_code` (`stock_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stocks`
--

LOCK TABLES `stocks` WRITE;
/*!40000 ALTER TABLE `stocks` DISABLE KEYS */;
INSERT INTO `stocks` VALUES ('HPG','Công ty cổ phần tập đoàn Hòa Phát','2025-02-10 08:25:51','2025-02-10 08:25:51'),('MBB','Ngân Hàng thương mại cổ phần quân đội','2025-02-10 08:25:51','2025-02-10 08:25:51'),('RAL','Bóng đèn phích nước Rạng Đông','2025-02-10 08:25:51','2025-02-10 08:25:51');
/*!40000 ALTER TABLE `stocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `stock_code` varchar(20) NOT NULL,
  `transaction_type` enum('BUY','SELL') NOT NULL,
  `quantity` decimal(15,2) NOT NULL,
  `price_per_share` decimal(15,2) NOT NULL,
  `transaction_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_id`),
  KEY `user_id` (`user_id`),
  KEY `stock_code` (`stock_code`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`stock_code`) REFERENCES `stocks` (`stock_code`),
  CONSTRAINT `transactions_chk_1` CHECK ((`quantity` > 0)),
  CONSTRAINT `transactions_chk_2` CHECK ((`price_per_share` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,1,'HPG','BUY',10.00,26900.00,'2024-10-18','2025-02-10 08:25:52','2025-02-10 08:25:52'),(2,3,'MBB','BUY',20.00,24950.00,'2024-10-29','2025-02-10 08:25:52','2025-02-10 08:25:52'),(3,2,'MBB','BUY',82.00,24300.00,'2024-11-12','2025-02-10 08:25:52','2025-02-10 08:25:52'),(4,1,'MBB','BUY',18.00,24300.00,'2024-11-12','2025-02-10 08:25:52','2025-02-10 08:25:52'),(5,1,'MBB','BUY',13.00,24100.00,'2024-11-28','2025-02-10 08:25:52','2025-02-10 08:25:52'),(6,1,'MBB','BUY',19.00,24050.00,'2024-11-29','2025-02-10 08:25:52','2025-02-10 08:25:52'),(7,1,'MBB','BUY',2.00,24350.00,'2024-12-10','2025-02-10 08:25:52','2025-02-10 08:25:52'),(8,5,'RAL','BUY',4.00,124800.00,'2024-12-10','2025-02-10 08:25:52','2025-02-10 08:25:52'),(9,2,'RAL','BUY',14.00,124500.00,'2024-12-10','2025-02-10 08:25:52','2025-02-10 08:25:52'),(10,1,'HPG','BUY',40.00,26200.00,'2025-01-09','2025-02-10 08:25:52','2025-02-10 08:25:52'),(11,2,'HPG','BUY',78.00,25550.00,'2025-01-13','2025-02-10 08:25:52','2025-02-10 08:25:52'),(12,1,'HPG','BUY',22.00,25550.00,'2025-01-13','2025-02-10 08:25:52','2025-02-10 08:25:52'),(13,1,'HPG','BUY',47.00,26000.00,'2025-01-14','2025-02-10 08:25:52','2025-02-10 08:25:52'),(14,1,'RAL','BUY',10.00,116800.00,'2025-01-24','2025-02-10 08:25:52','2025-02-10 08:25:52'),(15,2,'RAL','BUY',2.00,123000.00,'2024-12-11','2025-02-10 08:25:52','2025-02-10 08:25:52'),(16,1,'RAL','BUY',4.00,123000.00,'2024-12-11','2025-02-10 08:25:52','2025-02-10 08:25:52'),(17,1,'RAL','BUY',6.00,116500.00,'2025-01-24','2025-02-10 08:25:52','2025-02-10 08:25:52'),(18,1,'HPG','BUY',3.00,26500.00,'2025-01-24','2025-02-10 08:25:52','2025-02-10 08:25:52'),(19,1,'MBB','SELL',52.00,22880.00,'2025-02-10','2025-02-10 08:25:52','2025-02-10 08:25:52'),(20,2,'MBB','SELL',82.00,22880.00,'2025-02-10','2025-02-10 08:25:52','2025-02-10 08:25:52'),(21,3,'MBB','SELL',20.00,22880.00,'2025-02-10','2025-02-10 08:25:52','2025-02-10 08:25:52'),(22,4,'HPG','BUY',122.00,26100.00,'2025-02-10','2025-02-10 08:25:52','2025-02-10 08:25:52'),(23,1,'HPG','BUY',76.00,26080.00,'2025-02-10','2025-02-10 08:34:44','2025-02-10 08:34:44'),(24,2,'HPG','BUY',149.00,26080.00,'2025-02-10','2025-02-10 08:34:44','2025-02-10 08:34:44'),(25,3,'HPG','BUY',17.00,26080.00,'2025-02-10','2025-02-10 08:34:44','2025-02-10 08:34:44');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`Hoang`@`%`*/ /*!50003 TRIGGER `before_transaction_insert_cash_check` BEFORE INSERT ON `transactions` FOR EACH ROW BEGIN
    DECLARE cash_balance DECIMAL(15, 2);
    DECLARE transaction_amount DECIMAL(15, 2);

    
    IF NEW.transaction_type = 'BUY' THEN
        
        SELECT u.cash_balance INTO cash_balance
        FROM users u
        WHERE u.user_id = NEW.user_id;

        
        SET transaction_amount = NEW.quantity * NEW.price_per_share;

        
        IF cash_balance IS NULL OR cash_balance < transaction_amount * 1.0003 THEN
            
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient cash balance for transaction';
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`Hoang`@`%`*/ /*!50003 TRIGGER `after_transaction_insert` AFTER INSERT ON `transactions` FOR EACH ROW BEGIN
    DECLARE current_holdings INT;
    DECLARE current_avg_cost DECIMAL(15, 2);
    DECLARE transaction_amount DECIMAL(15, 2);
    
    
    SET transaction_amount = NEW.quantity * NEW.price_per_share;
    
    
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
    
    
    IF NEW.transaction_type = 'BUY' THEN
        UPDATE users 
        SET cash_balance = cash_balance - (transaction_amount * 1.0003)
        WHERE user_id = NEW.user_id;
    ELSE
        UPDATE users 
        SET cash_balance = cash_balance + (transaction_amount * 0.999)
        WHERE user_id = NEW.user_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`Hoang`@`%`*/ /*!50003 TRIGGER `after_transaction_update` AFTER UPDATE ON `transactions` FOR EACH ROW BEGIN
    DECLARE current_holdings INT;
    DECLARE current_avg_cost DECIMAL(15, 2);
    DECLARE old_transaction_amount DECIMAL(15, 2);
    DECLARE new_transaction_amount DECIMAL(15, 2);

    
    SET old_transaction_amount = OLD.quantity * OLD.price_per_share;
    SET new_transaction_amount = NEW.quantity * NEW.price_per_share;

    
    SELECT current_quantity, average_cost
    INTO current_holdings, current_avg_cost
    FROM portfolio_holdings
    WHERE user_id = OLD.user_id AND stock_code = OLD.stock_code;

    
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

    
    IF current_holdings IS NOT NULL THEN
        
        IF OLD.transaction_type = 'BUY' THEN
            SET @old_total_cost = (current_holdings * current_avg_cost) - (old_transaction_amount * 1.0003);
            SET @old_quantity = current_holdings - OLD.quantity;
        ELSE
            SET @old_total_cost = (current_holdings * current_avg_cost) + (old_transaction_amount * 0.999);
            SET @old_quantity = current_holdings + OLD.quantity;
        END IF;

        
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`Hoang`@`%`*/ /*!50003 TRIGGER `after_transaction_delete` AFTER DELETE ON `transactions` FOR EACH ROW BEGIN
    DECLARE current_holdings INT;
    DECLARE current_avg_cost DECIMAL(15, 2);
    DECLARE transaction_amount DECIMAL(15, 2);

    
    SET transaction_amount = OLD.quantity * OLD.price_per_share;

    
    IF OLD.transaction_type = 'BUY' THEN
        UPDATE users
        SET cash_balance = cash_balance + (transaction_amount * 1.0003)
        WHERE user_id = OLD.user_id;
    ELSEIF OLD.transaction_type = 'SELL' THEN
        UPDATE users
        SET cash_balance = cash_balance - (transaction_amount * 0.999)
        WHERE user_id = OLD.user_id;
    END IF;

    
    SELECT current_quantity, average_cost
    INTO current_holdings, current_avg_cost
    FROM portfolio_holdings
    WHERE user_id = OLD.user_id AND stock_code = OLD.stock_code;

    IF current_holdings IS NOT NULL THEN
        IF OLD.transaction_type = 'BUY' THEN
            
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
            
            SET @new_quantity = current_holdings + OLD.quantity;
            UPDATE portfolio_holdings
            SET current_quantity = @new_quantity,
                updated_at = CURRENT_TIMESTAMP
            WHERE user_id = OLD.user_id AND stock_code = OLD.stock_code;
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `contact_info` varchar(255) DEFAULT NULL,
  `cash_balance` decimal(15,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Đinh Việt Hoàng','0865003498',8906.84,'2025-02-10 08:25:51','2025-02-10 08:34:44'),(2,'Đinh Thị Huyền Trang','0979150764',10905.71,'2025-02-10 08:25:51','2025-02-10 08:34:44'),(3,'Trịnh Khắc Quang','0862863144',14499.69,'2025-02-10 08:25:51','2025-02-10 08:34:44'),(4,'Đinh Việt Đức','0393374311',14844.74,'2025-02-10 08:25:51','2025-02-10 08:25:52'),(5,'Nguyễn Trí Minh','',5650.24,'2025-02-10 08:25:51','2025-02-10 08:25:52');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-12  9:39:18
