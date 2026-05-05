-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: team1
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresses` (
  `address_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `line_1` varchar(150) NOT NULL,
  `line_2` varchar(150) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `state` char(2) NOT NULL,
  `zip` varchar(10) NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT '0',
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `place_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`address_id`),
  KEY `fk_addresses_users` (`user_id`),
  CONSTRAINT `fk_addresses_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (28,47,'One Washington Square','','San Jose','CA','95192','pickup',1,37.3372730,-121.8802700,'ChIJMWzftLjMj4ARSnC2w8Hgens'),(29,48,'Tyler Court','','Santa Clara','CA','95051','pickup',0,37.3257560,-121.9827900,'EiRUeWxlciBDdCwgU2FudGEgQ2xhcmEsIENBIDk1MDUxLCBVU0EiLiosChQKEgmjcETghcqPgBGITgj8x051tBIUChIJk8EIXIG3j4ARwL_Ao3ykdeQ'),(30,49,'447 East William Street','','San Jose','CA','95112','pickup',1,37.3331450,-121.8758540,'ChIJzdrOiMjMj4AR4gO-qTmVzh0'),(31,50,'2323 McKee Road','','San Jose','CA','95116','pickup',1,37.3669100,-121.8501100,'ChIJlS_SyQbNj4ARE_hh884WshQ');
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `listing_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_id`),
  KEY `listing_id` (`listing_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`listing_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (9,'Audio Equipment'),(4,'Camping Gear'),(1,'Electronics'),(8,'Gaming'),(6,'Home Improvement'),(5,'Kitchen Appliances'),(10,'Outdoor Equipment'),(7,'Photography'),(3,'Sports Equipment'),(2,'Tools');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `displays`
--

DROP TABLE IF EXISTS `displays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `displays` (
  `listing_id` int NOT NULL,
  `image_id` int NOT NULL,
  PRIMARY KEY (`listing_id`,`image_id`),
  KEY `image_id` (`image_id`),
  CONSTRAINT `displays_ibfk_1` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`listing_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `displays_ibfk_2` FOREIGN KEY (`image_id`) REFERENCES `listing_images` (`image_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `displays`
--

LOCK TABLES `displays` WRITE;
/*!40000 ALTER TABLE `displays` DISABLE KEYS */;
/*!40000 ALTER TABLE `displays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `has`
--

DROP TABLE IF EXISTS `has`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `has` (
  `listing_id` int NOT NULL,
  `booking_id` int NOT NULL,
  PRIMARY KEY (`listing_id`,`booking_id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `has_ibfk_1` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`listing_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `has_ibfk_2` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `has`
--

LOCK TABLES `has` WRITE;
/*!40000 ALTER TABLE `has` DISABLE KEYS */;
/*!40000 ALTER TABLE `has` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listing_images`
--

DROP TABLE IF EXISTS `listing_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listing_images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `listing_id` int DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`image_id`),
  KEY `listing_id` (`listing_id`),
  CONSTRAINT `listing_images_ibfk_1` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`listing_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listing_images`
--

LOCK TABLES `listing_images` WRITE;
/*!40000 ALTER TABLE `listing_images` DISABLE KEYS */;
INSERT INTO `listing_images` VALUES (34,26,'https://i.ebayimg.com/images/g/EGUAAOSwSWhjxdjA/s-l1200.jpg'),(35,26,'https://m.media-amazon.com/images/I/81rNO0tZ+EL.jpg'),(38,27,'https://www.cnet.com/a/img/resize/bebef835df90640f9aa2e4a2f2a2699cf53a301f/hub/2020/10/26/b60bfe6f-3193-4381-b0d4-ac628cdcc565/img-1419.jpg?auto=webp&width=1200'),(39,28,'https://hips.hearstapps.com/hmg-prod/images/cordless-drills-004-68152dbb47215.jpg?crop=1xw:1xh;center,top&resize=1200:*'),(40,29,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnAhfFLQjMjB1jGPFHOVm7Lw6EZ2PZqHNtKA&s'),(41,30,'https://whiteduckoutdoors.com/cdn/shop/files/13-Regatta-Bell-Tent-sandstone-beige-main-picture.jpg?v=1766397551'),(42,31,'https://hips.hearstapps.com/hmg-prod/images/camping-stoves-group-003-66b3cfb563bca.jpg?crop=0.604xw:0.907xh;0.252xw,0.0881xh&resize=640:*'),(43,32,'https://ooni.com/cdn/shop/products/RockerBlade1.jpg?crop=center&format=webp&height=2048&v=1685741150&width=2048'),(44,33,'https://m.media-amazon.com/images/I/61diuHxtr-L._AC_UF894,1000_QL80_.jpg');
/*!40000 ALTER TABLE `listing_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listings`
--

DROP TABLE IF EXISTS `listings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listings` (
  `listing_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `price` decimal(10,2) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `availability` tinyint(1) DEFAULT NULL,
  `address_id` int DEFAULT NULL,
  PRIMARY KEY (`listing_id`),
  KEY `user_id` (`user_id`),
  KEY `category_id` (`category_id`),
  KEY `fk_listings_addresses` (`address_id`),
  CONSTRAINT `fk_listings_addresses` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`address_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `listings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `listings_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings`
--

LOCK TABLES `listings` WRITE;
/*!40000 ALTER TABLE `listings` DISABLE KEYS */;
INSERT INTO `listings` VALUES (26,47,1,'Mac Book Pro','Great for School Work!\r\nWorks as good as new.',30.00,'2026-05-05 15:17:54',1,28),(27,47,8,'PS5','PS5 Account comes with many games!',20.00,'2026-05-05 15:19:55',1,28),(28,48,2,'Drill','Comes with two batteries.',25.00,'2026-05-05 15:53:26',1,29),(29,49,9,'Guitar','Acoustic \r\nSix string',8.00,'2026-05-05 16:06:53',1,30),(30,49,4,'Regatta Bell Tent','The Regatta is America\'s Favorite Bell Tent. It\'s versatile, spacious, and quick to pitch. Perfect for family camping, hunting trips or glamping getaways.',50.00,'2026-05-05 16:09:34',1,30),(31,49,4,'Portable Stove','Works great! Easy use for weekend trips.',10.00,'2026-05-05 16:13:12',1,30),(32,50,5,'Pizza Cutter','Sharp and Easy to Use',3.00,'2026-05-05 16:37:09',1,31),(33,50,5,'Hand Mixer','This hand mixer has the right speed for the task at hand, from mixing in nuts and chocolate chips at speed one, to whipping perfect meringues at speed five.\r\nLockable swivel cord keeps the cord out of your way while mixing.\r\nQuickly remove any of the included accessories from the hand mixer with the single-handed press of the button.',4.00,'2026-05-05 16:39:36',1,31);
/*!40000 ALTER TABLE `listings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `details` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `fk_logs_user` (`user_id`),
  CONSTRAINT `fk_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
INSERT INTO `logs` VALUES (12,NULL,'ACCOUNT_CREATED','New account 43 added to database','2026-05-04 20:15:39'),(13,NULL,'EMAIL_VERIFIED','Status changed in database','2026-05-04 20:15:51'),(14,NULL,'CREATE_LISTING','Created listing ID: 23','2026-05-04 20:18:37'),(15,NULL,'CREATE_LISTING','Created listing ID: 24','2026-05-04 20:20:10'),(16,NULL,'CREATE_LISTING','Created listing ID: 25','2026-05-04 20:21:07'),(17,NULL,'UPDATED_PASSWORD','password has been changed','2026-05-04 20:22:18'),(19,NULL,'ACCOUNT_CREATED','New account 44 added to database','2026-05-04 21:19:47'),(20,NULL,'ACCOUNT_CREATED','New account 45 added to database','2026-05-05 03:13:37'),(21,NULL,'EMAIL_VERIFIED','Status changed in database','2026-05-05 03:36:54'),(22,47,'ACCOUNT_CREATED','New account 47 added to database','2026-05-05 15:12:33'),(23,47,'CREATE_LISTING','Created listing ID: 26','2026-05-05 15:17:54'),(24,47,'CREATE_LISTING','Created listing ID: 27','2026-05-05 15:19:55'),(25,47,'EDIT_LISTING','Edited Listing ID:27','2026-05-05 15:38:54'),(26,48,'ACCOUNT_CREATED','New account 48 added to database','2026-05-05 15:46:18'),(27,48,'CREATE_LISTING','Created listing ID: 28','2026-05-05 15:53:26'),(28,49,'ACCOUNT_CREATED','New account 49 added to database','2026-05-05 16:03:23'),(29,49,'CREATE_LISTING','Created listing ID: 29','2026-05-05 16:06:53'),(30,49,'CREATE_LISTING','Created listing ID: 30','2026-05-05 16:09:34'),(31,49,'CREATE_LISTING','Created listing ID: 31','2026-05-05 16:13:12'),(32,50,'ACCOUNT_CREATED','New account 50 added to database','2026-05-05 16:33:45'),(33,50,'CREATE_LISTING','Created listing ID: 32','2026-05-05 16:37:09'),(34,50,'CREATE_LISTING','Created listing ID: 33','2026-05-05 16:39:36'),(35,NULL,'ACCOUNT_CREATED','New account 51 added to database','2026-05-05 16:42:41'),(36,NULL,'EMAIL_VERIFIED','Status changed in database','2026-05-05 16:43:50');
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `makes`
--

DROP TABLE IF EXISTS `makes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `makes` (
  `user_id` int NOT NULL,
  `booking_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`booking_id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `makes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `makes_ibfk_2` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `makes`
--

LOCK TABLES `makes` WRITE;
/*!40000 ALTER TABLE `makes` DISABLE KEYS */;
/*!40000 ALTER TABLE `makes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `message` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_read` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`notification_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `owns`
--

DROP TABLE IF EXISTS `owns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `owns` (
  `user_id` int NOT NULL,
  `listing_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`listing_id`),
  KEY `listing_id` (`listing_id`),
  CONSTRAINT `owns_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `owns_ibfk_2` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`listing_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `owns`
--

LOCK TABLES `owns` WRITE;
/*!40000 ALTER TABLE `owns` DISABLE KEYS */;
/*!40000 ALTER TABLE `owns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `amount` decimal(6,2) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_status` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `processes`
--

DROP TABLE IF EXISTS `processes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `processes` (
  `booking_id` int NOT NULL,
  `payment_id` int NOT NULL,
  PRIMARY KEY (`booking_id`,`payment_id`),
  KEY `payment_id` (`payment_id`),
  CONSTRAINT `processes_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `processes_ibfk_2` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `processes`
--

LOCK TABLES `processes` WRITE;
/*!40000 ALTER TABLE `processes` DISABLE KEYS */;
/*!40000 ALTER TABLE `processes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receives`
--

DROP TABLE IF EXISTS `receives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receives` (
  `listing_id` int NOT NULL,
  `review_id` int NOT NULL,
  PRIMARY KEY (`listing_id`,`review_id`),
  KEY `review_id` (`review_id`),
  CONSTRAINT `receives_ibfk_1` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`listing_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `receives_ibfk_2` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`review_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receives`
--

LOCK TABLES `receives` WRITE;
/*!40000 ALTER TABLE `receives` DISABLE KEYS */;
/*!40000 ALTER TABLE `receives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `listing_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `rating` decimal(2,1) DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`review_id`),
  KEY `listing_id` (`listing_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`listing_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_profiles`
--

DROP TABLE IF EXISTS `user_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_profiles` (
  `user_id` int NOT NULL,
  `preferred_contact_method` varchar(50) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `renter_rating` decimal(2,1) DEFAULT NULL,
  `lender_rating` decimal(2,1) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `user_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_profiles`
--

LOCK TABLES `user_profiles` WRITE;
/*!40000 ALTER TABLE `user_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `verification_token` varchar(255) DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `gov_id` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_admin` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `gov_id` (`gov_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (41,'Admin','Lender','admin@lender.com','4089000909','$2a$10$iTdi679od2EUAUw6q4E4U.2EMfbhW4OUGvh8SqS3feyTgR7Q0vu3e','53619933-6581-4735-9834-ddc0ceb0ee77',1,'A1111111','2026-05-04 15:40:53',1),(47,'James','Smith','James@lender.com','4081112020','$2a$10$byD/ofEjcyLxUZb6VgXd..M.TEY0Y4pBXCtn5VP4urH5jON2D3WYC','32b52ce0-2e5f-4b2d-ae11-a7eebac236b8',1,'A1111112','2026-05-05 15:12:31',0),(48,'Maria','Garcia','Maria@lender.com','4081113030','$2a$10$oZpLQdWukxyySfXsCC/eae8MoUjSX5q0YwVFnxFcBlvDAzRXNMfOa','163b8fa9-f029-45f5-83f1-0f0d456953fa',1,'A1111113','2026-05-05 15:46:16',0),(49,'Micheal','Smith','Micheal@lender.com','4081234567','$2a$10$.R10GF0CZ4w.uOQqShKC2.jAk6Kj8r76Xdl.gshJegef3GfC3mcWa','cf4e0ed9-2c30-4ca4-9f75-63877bfbc591',1,'A1111114','2026-05-05 16:03:22',0),(50,'Anthony','Davis','Anthony@lender.com','4081120234','$2a$10$js4RxtabBRqvY.rXANvi9uq1FQa.IeA399sjPdtlVLa.iOKZEWIVK','1d086a50-48fb-4963-9a98-851fd68c6f2f',1,'A1111115','2026-05-05 16:33:43',0);
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

-- Dump completed on 2026-05-05 16:58:52
