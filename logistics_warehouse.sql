
DROP TABLE IF EXISTS `carrier_dim`;

CREATE TABLE `carrier_dim` (
  `carrier_name` varchar(100) NOT NULL,
  `equipment` varchar(100) DEFAULT NULL,
  `carrier_id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`carrier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- Dumping data for table `carrier_dim`
--

LOCK TABLES `carrier_dim` WRITE;

UNLOCK TABLES;

DROP TABLE IF EXISTS `customer_dim`;

CREATE TABLE `customer_dim` (
  `customer_name` varchar(100) NOT NULL,
  `customer_mode` varchar(100) DEFAULT NULL,
  `customer_id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `customer_dim`
--

LOCK TABLES `customer_dim` WRITE;

UNLOCK TABLES;

DROP TABLE IF EXISTS `financial_dim`;

CREATE TABLE `financial_dim` (
  `customer_charge` double DEFAULT NULL,
  `carrier_charge` double DEFAULT NULL,
  `financial_id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`financial_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `financial_dim`
--

LOCK TABLES `financial_dim` WRITE;

UNLOCK TABLES;

DROP TABLE IF EXISTS `freight_dim`;

CREATE TABLE `freight_dim` (
  `quantity` bigint DEFAULT NULL,
  `weight` double DEFAULT NULL,
  `freight_id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`freight_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `freight_dim`
--

LOCK TABLES `freight_dim` WRITE;

UNLOCK TABLES;

DROP TABLE IF EXISTS `receiving_dim`;

CREATE TABLE `receiving_dim` (
  `rec_name` varchar(100) DEFAULT NULL,
  `rec_addr1` varchar(300) DEFAULT NULL,
  `rec_addr2` varchar(300) DEFAULT NULL,
  `rec_city` varchar(100) DEFAULT NULL,
  `rec_state` varchar(100) DEFAULT NULL,
  `rec_zip` varchar(100) DEFAULT NULL,
  `rec_country` varchar(100) DEFAULT NULL,
  `rec_id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`rec_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `receiving_dim`
--

LOCK TABLES `receiving_dim` WRITE;

UNLOCK TABLES;

DROP TABLE IF EXISTS `shipping_dim`;

CREATE TABLE `shipping_dim` (
  `ship_name` varchar(100) DEFAULT NULL,
  `ship_addr1` varchar(300) DEFAULT NULL,
  `ship_addr2` varchar(300) DEFAULT NULL,
  `ship_city` varchar(100) DEFAULT NULL,
  `ship_state` varchar(100) DEFAULT NULL,
  `ship_zip` varchar(100) DEFAULT NULL,
  `ship_country` varchar(100) DEFAULT NULL,
  `ship_id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ship_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `shipping_dim`
--

LOCK TABLES `shipping_dim` WRITE;

UNLOCK TABLES;

DROP TABLE IF EXISTS `date_time_dim`;

CREATE TABLE `date_time_dim` (
  `actual_ship` datetime DEFAULT NULL,
  `actual_delivery` datetime DEFAULT NULL,
  `date_time_id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`date_time_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `date_time_dim`
--

LOCK TABLES `date_time_dim` WRITE;

UNLOCK TABLES;

DROP TABLE IF EXISTS `logistics_fact`;

CREATE TABLE `logistics_fact` (
  `primary_ref` varchar(100) NOT NULL,
  `carrier` int DEFAULT NULL,
  `customer` int DEFAULT NULL,
  `date_time` int DEFAULT NULL,
  `financial` int DEFAULT NULL,
  `freight` int DEFAULT NULL,
  `receiving` int DEFAULT NULL,
  `shipping` int DEFAULT NULL,
  PRIMARY KEY (`primary_ref`),
  KEY `date_time_idx` (`date_time`),
  KEY `financial_idx` (`financial`),
  KEY `freight_idx` (`freight`),
  KEY `receiving_idx` (`receiving`),
  KEY `shipping_idx` (`shipping`),
  KEY `carrier_idx` (`carrier`),
  KEY `customer_idx` (`customer`),
  CONSTRAINT `carrier` FOREIGN KEY (`carrier`) REFERENCES `carrier_dim` (`carrier_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `customer` FOREIGN KEY (`customer`) REFERENCES `customer_dim` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `date_time` FOREIGN KEY (`date_time`) REFERENCES `date_time_dim` (`date_time_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `financial` FOREIGN KEY (`financial`) REFERENCES `financial_dim` (`financial_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `freight` FOREIGN KEY (`freight`) REFERENCES `freight_dim` (`freight_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `receiving` FOREIGN KEY (`receiving`) REFERENCES `receiving_dim` (`rec_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `shipping` FOREIGN KEY (`shipping`) REFERENCES `shipping_dim` (`ship_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `logistics_fact`
--

LOCK TABLES `logistics_fact` WRITE;

UNLOCK TABLES;
