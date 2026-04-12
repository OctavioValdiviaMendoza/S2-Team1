CREATE DATABASE  IF NOT EXISTS `team1` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `team1`;
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
  PRIMARY KEY (`address_id`),
  KEY `fk_addresses_users` (`user_id`),
  CONSTRAINT `fk_addresses_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (1,1,'123 Market St','Apt 4B','San Jose','CA','95112','home',1),(2,1,'500 Tech Park Dr',NULL,'San Jose','CA','95110','pickup',0),(3,2,'742 Evergreen Terrace',NULL,'San Jose','CA','95123','home',1),(4,3,'88 Willow Rd','Unit 12','Santa Clara','CA','95050','pickup',1),(5,4,'300 First St',NULL,'San Jose','CA','95113','home',1),(6,4,'91 E Tasman Dr',NULL,'San Jose','CA','95134','pickup',0),(7,5,'451 Blossom Hill Rd',NULL,'San Jose','CA','95123','home',1),(8,6,'200 W Santa Clara St',NULL,'San Jose','CA','95113','pickup',1),(9,7,'78 Almaden Blvd','Suite 300','San Jose','CA','95113','billing',1),(10,8,'880 Story Rd',NULL,'San Jose','CA','95122','home',1),(11,9,'1500 Berryessa Rd',NULL,'San Jose','CA','95133','pickup',1),(12,10,'2200 Mission College Blvd',NULL,'Santa Clara','CA','95054','home',1),(13,11,'101 N Market St',NULL,'San Jose','CA','95113','pickup',1),(14,12,'500 El Camino Real',NULL,'Santa Clara','CA','95050','home',1),(15,13,'400 Castro St',NULL,'Mountain View','CA','94041','pickup',1),(16,14,'600 University Ave',NULL,'Palo Alto','CA','94301','home',1),(17,15,'1 Infinite Loop',NULL,'Cupertino','CA','95014','pickup',1);
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
INSERT INTO `bookings` VALUES (1,1,2,'2026-04-01 10:00:00','2026-04-03 10:00:00','confirmed','2026-03-17 03:45:31'),(2,2,3,'2026-04-02 09:00:00','2026-04-04 09:00:00','confirmed','2026-03-17 03:45:31'),(3,3,4,'2026-04-05 12:00:00','2026-04-07 12:00:00','confirmed','2026-03-17 03:45:31'),(4,4,5,'2026-04-01 08:00:00','2026-04-02 08:00:00','completed','2026-03-17 03:45:31'),(5,5,6,'2026-04-03 14:00:00','2026-04-06 14:00:00','confirmed','2026-03-17 03:45:31'),(6,6,7,'2026-04-07 10:00:00','2026-04-09 10:00:00','pending','2026-03-17 03:45:31'),(7,7,8,'2026-04-10 11:00:00','2026-04-12 11:00:00','confirmed','2026-03-17 03:45:31'),(8,8,1,'2026-04-02 15:00:00','2026-04-05 15:00:00','confirmed','2026-03-17 03:45:31'),(9,9,2,'2026-04-06 09:00:00','2026-04-08 09:00:00','cancelled','2026-03-17 03:45:31'),(10,10,3,'2026-04-08 13:00:00','2026-04-10 13:00:00','confirmed','2026-03-17 03:45:31');
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
INSERT INTO `displays` VALUES (1,1),(1,2),(2,3),(3,4),(3,5),(4,6),(5,7),(6,8),(7,9),(7,10),(8,11),(9,12),(10,13),(10,14);
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
INSERT INTO `has` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listing_images`
--

LOCK TABLES `listing_images` WRITE;
/*!40000 ALTER TABLE `listing_images` DISABLE KEYS */;
INSERT INTO `listing_images` VALUES (1,1,'laptop1.jpg'),(2,1,'laptop2.jpg'),(3,2,'drill1.jpg'),(4,3,'basketball1.jpg'),(5,3,'basketball2.jpg'),(6,4,'tent1.jpg'),(7,5,'blender1.jpg'),(8,6,'ladder1.jpg'),(9,7,'camera1.jpg'),(10,7,'camera2.jpg'),(11,8,'ps5_1.jpg'),(12,9,'speaker1.jpg'),(13,10,'kayak1.jpg'),(14,10,'kayak2.jpg');
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
  PRIMARY KEY (`listing_id`),
  KEY `user_id` (`user_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `listings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `listings_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings`
--

LOCK TABLES `listings` WRITE;
/*!40000 ALTER TABLE `listings` DISABLE KEYS */;
INSERT INTO `listings` VALUES (1,1,1,'Laptop','Lightweight laptop for work and school',25.00,'2026-03-17 03:21:13',1),(2,2,2,'Power Drill','Cordless drill with battery included',10.00,'2026-03-17 03:21:13',1),(3,3,3,'Basketball Hoop','Adjustable outdoor hoop',12.00,'2026-03-17 03:21:13',1),(4,4,4,'Camping Tent','4-person waterproof tent',8.00,'2026-03-17 03:21:13',1),(5,5,5,'Blender','High-speed blender for smoothies',6.50,'2026-03-17 03:21:13',1),(6,6,6,'Ladder','10ft aluminum ladder',7.00,'2026-03-17 03:21:13',0),(7,7,7,'DSLR Camera','Canon camera with lens kit',30.00,'2026-03-17 03:21:13',1),(8,8,8,'PlayStation 5','Console with one controller',22.00,'2026-03-17 03:21:13',1),(9,1,9,'Bluetooth Speaker','Portable speaker with deep bass',5.00,'2026-03-17 03:21:13',1),(10,2,10,'Kayak','Single-person kayak for lakes',18.00,'2026-03-17 03:21:13',0);
/*!40000 ALTER TABLE `listings` ENABLE KEYS */;
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
INSERT INTO `makes` VALUES (2,1),(3,2),(4,3),(5,4),(6,5),(7,6),(8,7),(1,8),(2,9),(3,10);
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
INSERT INTO `notifications` VALUES (1,1,'Your booking has been confirmed','2026-03-17 09:34:48',1),(2,2,'Your payment was successful','2026-03-17 09:34:48',1),(3,3,'New message from a renter','2026-03-17 09:34:48',0),(4,4,'Your listing has a new review','2026-03-17 09:34:48',0),(5,5,'Booking request pending approval','2026-03-17 09:34:48',0),(6,6,'Payment failed, please retry','2026-03-17 09:34:48',1),(7,7,'Your item has been returned','2026-03-17 09:34:48',1),(8,8,'New booking request received','2026-03-17 09:34:48',0);
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
INSERT INTO `owns` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(1,9),(2,10);
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
INSERT INTO `payments` VALUES (1,1,50.00,'credit_card','completed','2026-03-17 03:53:54'),(2,2,91.00,'debit_card','completed','2026-03-17 03:53:54'),(3,3,60.00,'paypal','completed','2026-03-17 03:53:54'),(4,4,30.00,'credit_card','completed','2026-03-17 03:53:54'),(5,5,24.00,'apple_pay','completed','2026-03-17 03:53:54'),(6,6,14.00,'debit_card','pending','2026-03-17 03:53:54'),(7,7,60.00,'credit_card','completed','2026-03-17 03:53:54'),(8,8,66.00,'paypal','completed','2026-03-17 03:53:54'),(9,9,10.00,'credit_card','refunded','2026-03-17 03:53:54'),(10,10,36.00,'debit_card','completed','2026-03-17 03:53:54');
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
INSERT INTO `processes` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);
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
INSERT INTO `receives` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);
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
INSERT INTO `reviews` VALUES (1,1,2,4.5,'Great laptop, worked perfectly for my needs'),(2,2,3,4.0,'Drill was powerful and easy to use'),(3,3,4,4.8,'Basketball hoop was sturdy and fun'),(4,4,5,3.9,'Tent was decent but setup took time'),(5,5,6,4.2,'Blender worked well for smoothies'),(6,6,7,3.5,'Ladder was okay, a bit unstable'),(7,7,8,5.0,'Camera quality was amazing'),(8,8,1,4.6,'PS5 was in perfect condition'),(9,9,2,4.1,'Speaker had great sound quality'),(10,10,3,4.7,'Kayak was very fun and easy to use');
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
INSERT INTO `user_profiles` VALUES (1,'email','profile1.jpg',4.5,4.8),(2,'phone','profile2.jpg',3.9,4.2),(3,'email','profile3.jpg',4.7,4.6),(4,'text','profile4.jpg',4.0,3.8),(5,'email','profile5.jpg',3.5,4.1),(6,'phone','profile6.jpg',4.9,4.9),(7,'text','profile7.jpg',4.2,4.0),(8,'email','profile8.jpg',3.8,3.9);
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
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `gov_id` (`gov_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'','','alice.johnson@example.com','408-555-1001','hash_a91d2',NULL,1,'GOV1001','2026-03-15 23:43:20'),(2,'','','brian.smith@example.com','408-555-1002','hash_b38fa','token_1x92ab',0,'GOV1002','2026-03-15 23:43:20'),(3,'','','carla.gomez@example.com','408-555-1003','hash_c21de',NULL,1,'GOV1003','2026-03-15 23:43:20'),(4,'','','david.lee@example.com','408-555-1004','hash_d82ac','token_7z31pq',0,'GOV1004','2026-03-15 23:43:20'),(5,'','','emma.brown@example.com','408-555-1005','hash_e9af2',NULL,1,'GOV1005','2026-03-15 23:43:20'),(6,'','','frank.wilson@example.com','408-555-1006','hash_f34bc','token_8lm22x',0,'GOV1006','2026-03-15 23:43:20'),(7,'','','grace.kim@example.com','408-555-1007','hash_g72df',NULL,1,'GOV1007','2026-03-15 23:43:20'),(8,'','','henry.davis@example.com','408-555-1008','hash_h18cd','token_5k12nv',0,'GOV1008','2026-03-15 23:43:20'),(9,'','','isabella.martinez@example.com','408-555-1009','hash_i29ab',NULL,1,'GOV1009','2026-03-15 23:43:20'),(10,'','','jack.thompson@example.com','408-555-1010','hash_j93ed',NULL,1,'GOV1010','2026-03-15 23:43:20'),(11,'','','karen.white@example.com','408-555-1011','hash_k02ff','token_2ab44y',0,'GOV1011','2026-03-15 23:43:20'),(12,'','','liam.anderson@example.com','408-555-1012','hash_l44bc',NULL,1,'GOV1012','2026-03-15 23:43:20'),(13,'','','maya.patel@example.com','408-555-1013','hash_m77de',NULL,1,'GOV1013','2026-03-15 23:43:20'),(14,'','','noah.clark@example.com','408-555-1014','hash_n62aa','token_4mn77q',0,'GOV1014','2026-03-15 23:43:20'),(15,'','','olivia.harris@example.com','408-555-1015','hash_o11ff',NULL,1,'GOV1015','2026-03-15 23:43:20'),(16,'test1','tester','fakeemail@gmail.com','999-999-9999','$2a$10$S8WjIIxNTypz9Gzh8GXktO4SoGoGy3P7Bje8kEx5jhUbNLXbUgK66','',0,'y1234','2026-04-12 03:40:32');
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

-- Dump completed on 2026-04-12  3:52:22
