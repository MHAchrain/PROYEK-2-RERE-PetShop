-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: gateway01.ap-southeast-1.prod.aws.tidbcloud.com    Database: test
-- ------------------------------------------------------
-- Server version	8.0.11-TiDB-v8.5.3-serverless

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
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `id_admin` int unsigned NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_admin`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `admin_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorites` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pelanggan_id` int unsigned NOT NULL,
  `produk_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `favorites_pelanggan_id_foreign` (`pelanggan_id`),
  KEY `favorites_produk_id_foreign` (`produk_id`),
  CONSTRAINT `favorites_pelanggan_id_foreign` FOREIGN KEY (`pelanggan_id`) REFERENCES `pelanggan` (`id_pelanggan`) ON DELETE CASCADE,
  CONSTRAINT `favorites_produk_id_foreign` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`id_produk`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=411945;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
INSERT INTO `favorites` VALUES (60003,1485001,69,'2026-11-09 13:48:45','2026-11-09 13:48:45'),(261945,3515001,90073,'2026-11-18 16:52:38','2026-11-18 16:52:38'),(291945,1425002,70,'2026-11-18 17:53:21','2026-11-18 17:53:21'),(321946,1455002,60073,'2026-11-19 13:48:25','2026-11-19 13:48:25'),(351945,1425001,51,'2026-11-19 19:35:56','2026-11-19 19:35:56');
/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grooming_bookings`
--

DROP TABLE IF EXISTS `grooming_bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grooming_bookings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_pelanggan` int unsigned NOT NULL,
  `grooming_service_id` bigint unsigned NOT NULL,
  `pet_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pet_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pet_breed` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pet_size` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pet_note` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date` date NOT NULL,
  `time` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(12,2) NOT NULL DEFAULT '0',
  `status` enum('menunggu_pembayaran','terjadwal','dikonfirmasi','selesai','dibatalkan','gagal') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'menunggu_pembayaran',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `grooming_bookings_id_pelanggan_foreign` (`id_pelanggan`),
  KEY `grooming_bookings_grooming_service_id_foreign` (`grooming_service_id`),
  KEY `grooming_bookings_id_pelanggan_index` (`id_pelanggan`),
  CONSTRAINT `grooming_bookings_id_pelanggan_foreign` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`) ON DELETE CASCADE,
  CONSTRAINT `grooming_bookings_grooming_service_id_foreign` FOREIGN KEY (`grooming_service_id`) REFERENCES `grooming_services` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=180001;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grooming_bookings`
--

LOCK TABLES `grooming_bookings` WRITE;
/*!40000 ALTER TABLE `grooming_bookings` DISABLE KEYS */;
INSERT INTO `grooming_bookings` VALUES (60001,1455002,2,'Suli','Kucing','Anggora','Dewasa',NULL,'2026-10-07','09:00',250000.00,'selesai','2026-10-06 20:58:42','2026-10-15 09:19:15',NULL),(90001,1425001,2,'ocil','kucing','kampung','besar','lucu','2026-10-08','15:00',250000.00,'selesai','2026-10-08 13:09:19','2026-10-15 09:19:07',NULL),(120001,1455002,2,'Cipeng','Kucing','Anggora','Besar','bulunya rontok dan banyak kutu','2026-10-28','13:00',250000.00,'selesai','2026-10-26 14:13:42','2026-10-26 14:18:50',NULL),(150001,1455002,2,'Mochi','Kucing','Persia','Sedang','-','2026-10-26','17:00',250000.00,'menunggu_pembayaran','2026-10-26 14:45:41','2026-10-26 14:45:41',NULL);
/*!40000 ALTER TABLE `grooming_bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grooming_services`
--

DROP TABLE IF EXISTS `grooming_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grooming_services` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(12,2) NOT NULL DEFAULT '0',
  `duration_minutes` int NOT NULL DEFAULT '60',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=60002;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grooming_services`
--

LOCK TABLES `grooming_services` WRITE;
/*!40000 ALTER TABLE `grooming_services` DISABLE KEYS */;
INSERT INTO `grooming_services` VALUES (1,'Grooming Basic','Mandi dan perawatan dasar untuk hewan peliharaan Anda.',150000.00,60,1,'2026-10-04 08:30:58','2026-10-04 08:30:58',NULL),(2,'Grooming Medium','Mandi, perawatan, dan pemotongan bulu untuk hewan peliharaan Anda.',250000.00,60,1,'2026-10-04 08:30:58','2026-10-04 08:30:58',NULL),(3,'Grooming Premium','Perawatan lengkap termasuk mandi, pemotongan bulu, dan perawatan tambahan untuk hewan peliharaan Anda.',350000.00,90,1,'2026-10-04 08:30:58','2026-10-04 08:30:58',NULL),(30002,'Grooming potong kuku','potong kuku uy',20000.00,10,1,'2026-10-13 13:52:14','2026-10-13 13:54:39','2026-10-13 13:54:39');
/*!40000 ALTER TABLE `grooming_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kategori`
--

DROP TABLE IF EXISTS `kategori`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kategori` (
  `id_kategori` int unsigned NOT NULL AUTO_INCREMENT,
  `nama_kategori` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_kategori`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=60005;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kategori`
--

LOCK TABLES `kategori` WRITE;
/*!40000 ALTER TABLE `kategori` DISABLE KEYS */;
INSERT INTO `kategori` VALUES (1,'Food','2026-03-05 02:23:08','2026-03-08 01:22:42'),(2,'Medicine','2026-03-08 01:15:44','2026-03-08 01:15:44'),(3,'Toys','2026-03-08 01:18:11','2026-03-08 01:18:11'),(4,'Equipment','2026-03-08 01:20:32','2026-03-08 01:20:32');
/*!40000 ALTER TABLE `kategori` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `keranjang`
--

DROP TABLE IF EXISTS `keranjang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `keranjang` (
  `id_keranjang` int unsigned NOT NULL AUTO_INCREMENT,
  `id_pelanggan` int unsigned NOT NULL,
  `total` decimal(12,2) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_keranjang`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `keranjang_id_pelanggan_unique` (`id_pelanggan`),
  CONSTRAINT `keranjang_id_pelanggan_foreign` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=240001;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `keranjang`
--

LOCK TABLES `keranjang` WRITE;
/*!40000 ALTER TABLE `keranjang` DISABLE KEYS */;
INSERT INTO `keranjang` VALUES (90001,1425002,0.00,'2026-10-06 20:54:48','2026-11-18 17:58:11'),(90002,1455001,0.00,'2026-10-06 20:54:53','2026-10-26 15:02:53'),(90003,1425001,0.00,'2026-10-06 20:59:02','2026-11-19 20:37:04'),(90004,1455002,0.00,'2026-10-06 21:02:50','2026-11-19 13:50:28'),(120001,1455003,0.00,'2026-10-29 19:30:11','2026-11-09 13:45:23'),(150001,1485001,175000.00,'2026-10-29 22:30:37','2026-11-09 13:49:11'),(180001,1515001,10000.00,'2026-11-14 23:05:42','2026-11-14 23:05:42'),(210001,3515001,0.00,'2026-11-17 14:15:18','2026-11-19 13:36:36');
/*!40000 ALTER TABLE `keranjang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `keranjang_item`
--

DROP TABLE IF EXISTS `keranjang_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `keranjang_item` (
  `id_item` int unsigned NOT NULL AUTO_INCREMENT,
  `id_keranjang` int unsigned NOT NULL,
  `id_produk` int unsigned NOT NULL,
  `qty` int NOT NULL DEFAULT '1',
  `harga_satuan` decimal(12,2) NOT NULL DEFAULT '0',
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_item`) /*T![clustered_index] CLUSTERED */,
  KEY `keranjang_item_id_keranjang_foreign` (`id_keranjang`),
  KEY `keranjang_item_id_produk_foreign` (`id_produk`),
  CONSTRAINT `keranjang_item_id_keranjang_foreign` FOREIGN KEY (`id_keranjang`) REFERENCES `keranjang` (`id_keranjang`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `keranjang_item_id_produk_foreign` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=870001;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `keranjang_item`
--

LOCK TABLES `keranjang_item` WRITE;
/*!40000 ALTER TABLE `keranjang_item` DISABLE KEYS */;
INSERT INTO `keranjang_item` VALUES (480003,150001,68,1,150000.00,150000.00),(480004,150001,69,1,25000.00,25000.00),(660001,180001,90073,1,10000.00,10000.00);
/*!40000 ALTER TABLE `keranjang_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=673420;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2026_03_01_043700_create_admin_table',1),(5,'2026_03_01_043758_create_kategori_table',1),(6,'2026_03_01_043835_create_pelanggan_table',1),(7,'2026_03_01_043835_create_produk_table',1),(8,'2026_03_01_043937_create_keranjang_item_table',1),(9,'2026_03_01_043937_create_keranjang_table',1),(10,'2026_03_01_045111_create_pesanan_table',1),(11,'2026_03_01_045115_create_pesanan_detail_table',1),(12,'2026_03_01_045214_create_pembayaran_table',1),(13,'2026_03_01_045214_create_pengiriman_table',1),(14,'2026_03_05_101544_add_role_to_users_table',1),(15,'2026_03_07_063602_add_jumlah_bayar_to_pembayarans_table',1),(16,'2026_03_07_073445_create_personal_access_tokens_table',1),(17,'2026_04_10_152252_add_views_to_produks_table',1),(18,'2026_04_14_101418_create_favorites_table',1),(19,'2026_04_14_105006_add_pelanggan_id_to_users_table',1),(20,'2026_04_17_090000_add_no_telp_to_pesanan_table',1),(21,'2026_04_27_120000_add_snap_token_to_pembayaran_table',1),(22,'2026_08_11_224540_add_google_id_to_users_table',1),(155819,'2026_10_04_000001_create_grooming_services_table',2),(155820,'2026_10_04_000002_create_grooming_bookings_table',2);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pelanggan`
--

DROP TABLE IF EXISTS `pelanggan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pelanggan` (
  `id_pelanggan` int unsigned NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_hp` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alamat` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_pelanggan`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `pelanggan_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=3992973;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pelanggan`
--

LOCK TABLES `pelanggan` WRITE;
/*!40000 ALTER TABLE `pelanggan` DISABLE KEYS */;
INSERT INTO `pelanggan` VALUES (1425001,'sakhi ardra','ardrasakhi390@gmail.com','$2y$12$rrMDKfNAyAihgHxZuMm/O.SkB4N4s.2JGsud4J65yW4PXv6eUnuy6','+622928424747','jl ujang, indramayu','2026-10-06 20:36:13','2026-10-06 21:00:55'),(1425002,'skirdrax Corporation','skirdraxcorporation@gmail.com','$2y$12$12KpaA9LSCrIqnGz0fXxWupBJwynH7GPsfA8fq3TH9gwcQXA.BFr2','+62232474774','jl sulawesi, kota bandung','2026-10-06 20:36:39','2026-10-06 20:56:00'),(1455001,'dobleh hans','skhiadr@student.polindra.ac.id','$2y$12$d.vD1wT8L8gpQJXVj9ODJ.6RaHBG0uzGaNHoNELNHxWG5zJn8G.hm','+6283744772','jl aja, ciamis','2026-10-06 20:52:08','2026-10-06 20:56:12'),(1455002,'TEAM KDR','rayenyen7@gmail.com','$2y$12$9GyKiO1b7euvwoKAQX.oqeWje4jt1JB7AsD3tflQLkYh1OXOv7DO.','+6281231913101','Jl lohbener','2026-10-06 20:57:36','2026-10-06 21:03:35'),(1455003,'Rayen','Rayen@gmail.com','$2y$12$/fD3GIMTCChRKAGuHT6BleeW9bFaDPxRAEWmF5rFuKOtw2UpByq72','+628123414112','Apaa aja','2026-10-06 21:08:23','2026-10-06 21:08:23'),(1485001,'Rendy Caninghem','rendycaninghem@gmail.com','$2y$12$A5UzHDGcCWW4rXu8dHU9Q.gKzw0HJ8RFYapAS7LsGEbvMvosI4PKq',NULL,NULL,'2026-10-29 22:29:45','2026-10-29 22:29:45'),(1515001,'Sakhi ardra','ardrasakhi@gmail.com','$2y$12$/tpUL7ugQR8RdfGtISqcWe2Vrp8jVZIJihlQi7rgEazc0WnmYn1tK',NULL,NULL,'2026-10-30 15:47:08','2026-10-30 15:47:08'),(3515001,'ardi','ardi@gmail.com','$2y$12$a8gmmQS97/sBcoBw04P3h.SI3tFRalZWRwkggLAUdobPF7zS4pnYu','02873878447637','hsjjsjsjhsjhs','2026-11-17 12:47:31','2026-11-17 12:47:31');
/*!40000 ALTER TABLE `pelanggan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pembayaran`
--

DROP TABLE IF EXISTS `pembayaran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pembayaran` (
  `id_pembayaran` int unsigned NOT NULL AUTO_INCREMENT,
  `id_pesanan` int unsigned NOT NULL,
  `metode_bayar` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pakasir',
  `status_bayar` enum('pending','paid','failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `ref_gateway` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `snap_token` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `waktu_bayar` datetime DEFAULT NULL,
  `jumlah_bayar` decimal(15,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_pembayaran`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `pembayaran_id_pesanan_unique` (`id_pesanan`),
  CONSTRAINT `pembayaran_id_pesanan_foreign` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=720002;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pembayaran`
--

LOCK TABLES `pembayaran` WRITE;
/*!40000 ALTER TABLE `pembayaran` DISABLE KEYS */;
INSERT INTO `pembayaran` VALUES (240002,240002,'QRIS','paid','ORDER-240002-1791294992','950802d6-8531-43ae-9b94-80f81e040251','2026-10-06 20:56:58',18000.00,'2026-10-06 20:56:33','2026-10-06 20:56:58'),(240003,240003,'QRIS','paid','ORDER-240003-1791295013','b220de1f-d33e-4b7c-a313-5f86374126be','2026-10-06 20:57:13',50000.00,'2026-10-06 20:56:54','2026-10-06 20:57:13'),(240004,240004,'QRIS','paid','ORDER-240004-1791295277','3de3da2b-5051-47ec-9901-ca7aa4eefb60','2026-10-06 21:01:42',235000.00,'2026-10-06 21:01:18','2026-10-06 21:01:42'),(240005,240005,'QRIS','failed','ORDER-240005-1791295436','0942649b-e10b-4067-941a-f55edc8e4cf2',NULL,120000.00,'2026-10-06 21:03:56','2026-10-06 21:07:53'),(270002,270002,'QRIS','paid','ORDER-270002-1791456402','95b85103-28f7-4a9b-b7b1-cc73fe56da7c','2026-10-08 17:46:59',180000.00,'2026-10-08 17:46:43','2026-10-08 17:46:59'),(300002,300002,'QRIS','paid','ORDER-300002-1793001779','d729b961-0e2b-46a2-a7a2-a7b7388cd64f','2026-10-26 15:03:15',18000.00,'2026-10-26 15:03:00','2026-10-26 15:03:15'),(330002,330002,'QRIS','failed','ORDER-330002-1793276281','b6948997-2257-46a9-ad1b-32a3ac6d64e4',NULL,70000.00,'2026-10-29 19:18:02','2026-11-12 15:11:32'),(330003,330003,'Menunggu Pilihan Metode','pending','ORDER-330003-1793277035','749208c8-c3f8-49b5-bce0-d5eddf727eea',NULL,30000.00,'2026-10-29 19:30:36','2026-10-29 19:30:36'),(360002,390002,'Menunggu Pilihan Metode','pending','ORDER-390002-1793287875','16b3b909-c7e3-46f6-9760-94b45725cc30',NULL,10000.00,'2026-10-29 22:31:15','2026-10-29 22:31:15'),(390002,420002,'Menunggu Pilihan Metode','failed','ORDER-420002-1793344553','518d6f37-c0eb-4642-8dd3-dc080e0053d3',NULL,20000.00,'2026-10-30 14:15:54','2026-11-12 15:08:06'),(420002,360002,'Menunggu Pilihan Metode','pending','ORDER-360002-1793353817','2dbc6265-4e98-4aca-bf99-6c8178298abf',NULL,30000.00,'2026-10-30 16:50:17','2026-10-30 16:50:17'),(450002,450002,'Menunggu Pilihan Metode','pending','ORDER-450002-1793429991','ab156e04-53dd-4170-8d8a-d0ce550b43c2',NULL,10000.00,'2026-10-31 13:59:53','2026-10-31 13:59:53'),(480002,480002,'Menunggu Pilihan Metode','pending','ORDER-480002-1794206727','79280f8f-4e69-4192-8f6d-df5c36f8c9d8',NULL,60000.00,'2026-11-09 13:45:28','2026-11-09 13:45:28'),(510002,510002,'Menunggu Pilihan Metode','pending','ORDER-510002-1794470617','1ba8e02b-2792-4c30-8bef-2943a916d35f',NULL,18000.00,'2026-11-12 15:03:37','2026-11-12 15:03:37'),(540002,540002,'QRIS','paid','ORDER-540002-1794556987','c97f444c-cc04-44bf-8e7b-842436f0e5f2','2026-11-13 15:03:31',18000.00,'2026-11-13 15:03:08','2026-11-13 15:03:31'),(570002,570002,'QRIS','paid','ORDER-570002-1794624067','af645949-e868-4c7f-bba7-e449ca313700','2026-11-14 09:43:17',70000.00,'2026-11-14 09:41:08','2026-11-14 09:43:17'),(600002,600002,'Menunggu Pilihan Metode','pending','ORDER-600002-1794672274','8f2576aa-5220-4458-ab26-365172096777',NULL,30000.00,'2026-11-14 23:04:34','2026-11-14 23:04:34'),(630002,630002,'Menunggu Pilihan Metode','pending','ORDER-630002-1794999496','4aa73207-f8c8-4087-90d1-a8c28203d91a',NULL,100000.00,'2026-11-18 17:58:17','2026-11-18 17:58:17'),(660002,660003,'Menunggu Pilihan Metode','pending','ORDER-660003-1795070467','f4510d8a-6f8f-4c9e-afac-691d4f6c7837',NULL,20000.00,'2026-11-19 13:41:07','2026-11-19 13:41:07'),(690002,690002,'Menunggu Pilihan Metode','pending','ORDER-690002-1795095425','1fab1358-7a8e-4745-b443-9b02c9e2bf83',NULL,10000.00,'2026-11-19 20:37:06','2026-11-19 20:37:06');
/*!40000 ALTER TABLE `pembayaran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pengiriman`
--

DROP TABLE IF EXISTS `pengiriman`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pengiriman` (
  `id_pengiriman` int unsigned NOT NULL AUTO_INCREMENT,
  `id_pesanan` int unsigned NOT NULL,
  `status_kirim` enum('diproses','dikirim','diterima') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'diproses',
  `kurir` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resi` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tanggal_kirim` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_pengiriman`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `pengiriman_id_pesanan_unique` (`id_pesanan`),
  CONSTRAINT `pengiriman_id_pesanan_foreign` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=330002;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pengiriman`
--

LOCK TABLES `pengiriman` WRITE;
/*!40000 ALTER TABLE `pengiriman` DISABLE KEYS */;
INSERT INTO `pengiriman` VALUES (180002,240004,'diterima','jne','RESI-20261008-240004','2026-10-08 13:13:42','2026-10-08 13:13:42','2026-10-08 13:37:14'),(180003,240003,'dikirim','internal','RESI-20261008-240003','2026-10-08 13:13:51','2026-10-08 13:13:51','2026-10-08 13:13:51'),(180004,240002,'diterima','ojol','RESI-20261008-240002','2026-10-08 13:14:01','2026-10-08 13:14:01','2026-10-15 09:16:02'),(210002,270002,'diterima','jne','RESI-20261012-270002','2026-10-12 20:46:20','2026-10-12 20:46:19','2026-10-15 09:15:55'),(240002,300002,'diproses','menunggu_kurir','RESI-20261026-300002','2026-10-26 15:03:53','2026-10-26 15:03:54','2026-10-26 15:03:54'),(270002,540002,'dikirim','jne','RESI-20261113-540002','2026-11-13 15:14:02','2026-11-13 15:14:02','2026-11-13 15:14:02'),(300002,570002,'dikirim','internal','RESI-20261119-570002','2026-11-19 20:12:01','2026-11-19 20:12:01','2026-11-19 20:12:01');
/*!40000 ALTER TABLE `pengiriman` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=77615147;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES (46640793,'App\\Models\\User',90002,'customer_token','edb2e0b08a23e857c256f77414af3cfaae86002897d45dcf82c6fd462cffdc85','[\"*\"]','2026-11-09 13:46:54',NULL,'2026-11-09 13:42:01','2026-11-09 13:46:54'),(48080649,'App\\Models\\User',14,'customer_token','1e4c3d480db53432f6a8add953866f5b0549a708eda59813ac4a6cafc667d1ae','[\"*\"]','2026-11-11 14:56:41',NULL,'2026-11-11 14:56:32','2026-11-11 14:56:41'),(54416699,'App\\Models\\User',13,'customer_token','3498f93a5c290598bdceb9f3b11112872ecd8a397075f3a37b691f356b9aa6cb','[\"*\"]','2026-11-14 23:07:38',NULL,'2026-11-14 23:07:19','2026-11-14 23:07:38'),(69032743,'App\\Models\\User',60001,'customer_token','f3c2f49aba0b9447ff6e2c26c3c47cabf5995db57ae5f41fb347f67c79f4e95d','[\"*\"]','2026-11-18 17:59:22',NULL,'2026-11-18 17:53:49','2026-11-18 17:59:22'),(69062743,'App\\Models\\User',150001,'customer_token','b794b26a6e2fe8461d4d392de2fbe6e44d46fc9fa0f76ecbf6214bf7ab47eff0','[\"*\"]','2026-11-19 13:36:47',NULL,'2026-11-19 13:31:55','2026-11-19 13:36:47'),(72170555,'App\\Models\\User',90001,'customer_token','4a6f252aefb617483d57563ed14d15e8798ca2cd344b54aa74b56fdda6f41b56','[\"*\"]','2026-11-19 20:07:29',NULL,'2026-11-19 19:57:43','2026-11-19 20:07:29'),(75585147,'App\\Models\\User',11,'customer_token','d819fceabaa4d478ff20441a31869b53436b354f7ffb20e597e6f5e6e0ef212b','[\"*\"]','2026-11-20 18:14:50',NULL,'2026-11-19 20:54:19','2026-11-20 18:14:50'),(75615147,'App\\Models\\User',120001,'customer_token','5bcd8e7d61a7fda9f2c590be4f57a8d6f0c90c325847ab4edfd0a0db396b0979','[\"*\"]','2026-11-22 20:53:29',NULL,'2026-11-22 20:52:50','2026-11-22 20:53:29');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pesanan`
--

DROP TABLE IF EXISTS `pesanan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pesanan` (
  `id_pesanan` int unsigned NOT NULL AUTO_INCREMENT,
  `id_pelanggan` int unsigned NOT NULL,
  `tanggal_pesanan` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `alamat_kirim` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total` decimal(12,2) NOT NULL DEFAULT '0',
  `status_pesanan` enum('baru','diproses','dikirim','selesai','batal') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'baru',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `no_telp` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_pesanan`) /*T![clustered_index] CLUSTERED */,
  KEY `pesanan_id_pelanggan_foreign` (`id_pelanggan`),
  CONSTRAINT `pesanan_id_pelanggan_foreign` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=720002;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pesanan`
--

LOCK TABLES `pesanan` WRITE;
/*!40000 ALTER TABLE `pesanan` DISABLE KEYS */;
INSERT INTO `pesanan` VALUES (240002,1425002,'2026-10-06 20:56:21','jl sulawesi, kota bandung',18000.00,'selesai','2026-10-06 20:56:21','2026-10-15 09:16:02','+62232474774'),(240003,1455001,'2026-10-06 20:56:30','jl aja, ciamis',50000.00,'dikirim','2026-10-06 20:56:30','2026-10-08 13:13:51','+6283744772'),(240004,1425001,'2026-10-06 21:01:09','jl ujang, indramayu',235000.00,'selesai','2026-10-06 21:01:09','2026-10-08 13:37:14','+622928424747'),(240005,1455002,'2026-10-06 21:03:46','Jl lohbener',120000.00,'batal','2026-10-06 21:03:46','2026-10-06 21:07:53','+6281231913101'),(270002,1455001,'2026-10-08 17:46:34','jl aja, ciamis',180000.00,'selesai','2026-10-08 17:46:34','2026-10-15 09:15:55','+6283744772'),(300002,1455001,'2026-10-26 15:02:53','jl aja, ciamis',18000.00,'dikirim','2026-10-26 15:02:53','2026-10-26 15:03:54','+6283744772'),(330002,1425001,'2026-10-29 19:17:51','jl ujang, indramayu',70000.00,'batal','2026-10-29 19:17:51','2026-11-12 15:11:32','+622928424747'),(330003,1455003,'2026-10-29 19:30:31','Apaa aja',30000.00,'baru','2026-10-29 19:30:31','2026-10-29 19:30:31','+628123414112'),(360002,1425002,'2026-10-29 21:08:53','jl sulawesi, kota b\nbandung',30000.00,'baru','2026-10-29 21:08:53','2026-10-29 21:08:53','+62232474774'),(390002,1485001,'2026-10-29 22:31:11','jalan pulang',10000.00,'baru','2026-10-29 22:31:11','2026-10-29 22:31:11','84613155151'),(420002,1425001,'2026-10-30 14:15:35','jl ujang, indramayu',20000.00,'batal','2026-10-30 14:15:35','2026-11-12 15:08:06','+622928424747'),(450002,1485001,'2026-10-31 13:59:42','jalan anjay',10000.00,'baru','2026-10-31 13:59:42','2026-10-31 13:59:42','1315188455'),(480002,1455003,'2026-11-09 13:45:22','Apaa aja',60000.00,'baru','2026-11-09 13:45:22','2026-11-09 13:45:22','+628123414112'),(510002,1425001,'2026-11-12 15:03:11','jl ujang, indramayu',18000.00,'baru','2026-11-12 15:03:11','2026-11-12 15:03:11','+622928424747'),(540002,1425001,'2026-11-13 15:02:57','jl ujang, indramayu',18000.00,'dikirim','2026-11-13 15:02:57','2026-11-13 15:14:02','+622928424747'),(570002,1425001,'2026-11-14 09:40:52','jl ujang, indramayu',70000.00,'dikirim','2026-11-14 09:40:52','2026-11-19 20:12:01','+622928424747'),(600002,1425001,'2026-11-14 23:04:31','jl ujang, indramayu',30000.00,'baru','2026-11-14 23:04:31','2026-11-14 23:04:31','+622928424747'),(630002,1425002,'2026-11-18 17:58:11','jl sulawesi, kota bandung',100000.00,'baru','2026-11-18 17:58:11','2026-11-18 17:58:11','+62232474774'),(660002,3515001,'2026-11-19 13:36:36','hsjjsjsjhsjhs',260000.00,'baru','2026-11-19 13:36:36','2026-11-19 13:36:36','02873878447637'),(660003,1425001,'2026-11-19 13:41:00','jl ujang, indramayu',20000.00,'baru','2026-11-19 13:41:00','2026-11-19 13:41:00','+622928424747'),(690002,1425001,'2026-11-19 20:37:03','jl ujang, indramayu',10000.00,'baru','2026-11-19 20:37:03','2026-11-19 20:37:03','+622928424747');
/*!40000 ALTER TABLE `pesanan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pesanan_detail`
--

DROP TABLE IF EXISTS `pesanan_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pesanan_detail` (
  `id_detail` int unsigned NOT NULL AUTO_INCREMENT,
  `id_pesanan` int unsigned NOT NULL,
  `id_produk` int unsigned NOT NULL,
  `qty` int NOT NULL DEFAULT '1',
  `harga_satuan` decimal(12,2) NOT NULL DEFAULT '0',
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_detail`) /*T![clustered_index] CLUSTERED */,
  KEY `pesanan_detail_id_pesanan_foreign` (`id_pesanan`),
  KEY `pesanan_detail_id_produk_foreign` (`id_produk`),
  CONSTRAINT `pesanan_detail_id_pesanan_foreign` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pesanan_detail_id_produk_foreign` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=720024;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pesanan_detail`
--

LOCK TABLES `pesanan_detail` WRITE;
/*!40000 ALTER TABLE `pesanan_detail` DISABLE KEYS */;
INSERT INTO `pesanan_detail` VALUES (240024,240002,16,1,18000.00,18000.00),(240025,240003,59,1,25000.00,25000.00),(240026,240003,31,1,25000.00,25000.00),(240027,240004,67,2,100000.00,200000.00),(240028,240004,8,1,35000.00,35000.00),(240029,240005,35,6,20000.00,120000.00),(270024,270002,6,1,180000.00,180000.00),(300024,300002,15,1,18000.00,18000.00),(330024,330002,54,1,70000.00,70000.00),(330025,330003,70,1,30000.00,30000.00),(360024,360002,66,1,20000.00,20000.00),(360025,360002,90073,1,10000.00,10000.00),(390024,390002,90073,1,10000.00,10000.00),(420024,420002,44,1,20000.00,20000.00),(450024,450002,90073,1,10000.00,10000.00),(480024,480002,3,1,25000.00,25000.00),(480025,480002,8,1,35000.00,35000.00),(510024,510002,25,1,18000.00,18000.00),(540024,540002,24,1,18000.00,18000.00),(570024,570002,57,1,70000.00,70000.00),(600024,600002,70,1,30000.00,30000.00),(630024,630002,60073,1,100000.00,100000.00),(660024,660002,90073,1,10000.00,10000.00),(660025,660002,60073,1,100000.00,100000.00),(660026,660002,70,5,30000.00,150000.00),(660027,660003,66,1,20000.00,20000.00),(690024,690002,90073,1,10000.00,10000.00);
/*!40000 ALTER TABLE `pesanan_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produk`
--

DROP TABLE IF EXISTS `produk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produk` (
  `id_produk` int unsigned NOT NULL AUTO_INCREMENT,
  `id_kategori` int unsigned NOT NULL,
  `nama_produk` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `harga` decimal(12,2) NOT NULL DEFAULT '0',
  `stok` int NOT NULL DEFAULT '0',
  `deskripsi` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `foto` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `views` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_produk`) /*T![clustered_index] CLUSTERED */,
  KEY `produk_id_kategori_foreign` (`id_kategori`),
  CONSTRAINT `produk_id_kategori_foreign` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=120073;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produk`
--

LOCK TABLES `produk` WRITE;
/*!40000 ALTER TABLE `produk` DISABLE KEYS */;
INSERT INTO `produk` VALUES (1,1,'Whiskas 80g',7000.00,49,'Whiskas Pouch 80 gram adalah makanan basah (wet food) bernutrisi lengkap untuk kucing, tersedia dalam varian Junior (2-12 bulan) dan Adult (di atas 1 tahun). Diformulasikan oleh ahli gizi hewan, makanan ini mengandung ikan asli, omega 6, dan zink untuk kesehatan kulit dan bulu, serta tersedia dalam berbagai rasa seperti tuna dan mackere','produk/01M3H3SQ47QFJHSFEW6G4W5CNY.avif','2026-03-06 11:47:31','2026-09-27 16:40:34',0),(2,1,'Royal canin adult persia 400 gr',95000.00,78,'Royal Canin Persian30 Makanan seimbang dan lengkap untuk kucing dewasa Khusus untuk kucing Persia RAHANG BRACHYCEPHALIC KHUSUS Almond 11, kibble yang dirancang khusus agar lebih mudah dipegang oleh kucing Persia Anda dengan bagian bawah lidah. PENGURANGAN GUMPALAN BULU Membatasi pembentukan gumpalan bulu dan meningkatkan pembuangan alami kotoran yang tertelan','produk/01KP507DXZN9GDTDSEPM5M6KBC.png','2026-03-10 09:58:03','2026-10-06 15:42:06',0),(3,1,'Cat Choize Kitten salmon with milk',25000.00,299,'makanan kering premium yang diformulasikan khusus untuk anak kucing usia 0-12 bulan, menggabungkan nutrisi ikan salmon dan susu untuk mendukung pertumbuhan optimal. Produk ini mengandung protein berkualitas tinggi, asam lemak omega 6, dan Zinc yang menjaga kesehatan kulit, bulu, serta meningkatkan daya tahan tubuh anak kucing. Dengan tekstur kibble yang renyah dan aroma nikmat, makanan ini efektif membantu pertumbuhan tulang dan gigi sekaligus mengurangi karang gigi','produk/01KP54QKB7511DGZDHDZQ10824.png','2026-04-06 08:37:34','2026-11-09 13:45:22',0),(4,1,'Meo adult Tuna',18000.00,220,'makanan kucing kering premium beraroma tuna yang diformulasikan untuk kucing dewasa usia 1 tahun ke atas. Produk ini memberikan nutrisi lengkap, seimbang, dan mudah dicerna, yang mengandung taurin, protein, serta omega 3 & 6 untuk kesehatan mata, kulit, dan bulu.','produk/01KP52ERPHT7NWFNCCRKS4G0S3.png','2026-04-06 09:24:55','2026-08-21 20:26:16',0),(5,4,'Kandang mandi kucing',75000.00,30,'didesain untuk membatasi gerak kucing saat dimandikan, dikeringkan, atau dirawat, guna mencegah kucing melarikan diri atau mencakar. Kandang ini terbuat dari kawat besi tebal anti karat, aman, dan praktis.','produk/01KP52HE9GQ9GKBH43V9QQDBET.png','2026-04-06 09:31:09','2026-04-13 21:03:41',0),(6,4,'Kandang M kucing',180000.00,13,'berukuran sekitar 45x30x35 cm hingga 50x30x37 cm, cocok untuk 1 induk kucing dewasa atau 2-3 kitten. Kandang ini biasanya berbahan besi tebal dengan pelapis powder coating anti karat, dapat dilipat, dan dilengkapi tatakan plastik untuk kotoran.','produk/01KP52J31MNFAVXN2SJMHCS6W3.png','2026-04-06 09:31:54','2026-10-08 17:46:34',0),(7,1,'Excel Ungu Tuna',18000.00,4,'Excel Ungu (bentuk ikan) adalah makanan kucing kering produksi Japfa Comfeed yang diformulasikan dengan rasa Tuna. Pakan ini populer karena ekonomis, mengandung nutrisi seimbang untuk pertumbuhan, dan memiliki bentuk ikan yang menarik bagi kucing. Cocok untuk menjaga kesehatan harian kucing dewasa dan anak kucing.','produk/01KP52T871C3Y3SYYX41F29H9M.png','2026-04-06 09:38:09','2026-04-13 21:08:26',0),(8,1,'Susu Top Groth',35000.00,58,'susu formula khusus untuk anak kucing (kitten) yang diformulasikan sebagai pengganti susu induk, cocok untuk anak kucing baru lahir hingga dewasa. Susu ini rendah laktosa untuk mencegah diare, aman bagi pencernaan, serta membantu pertumbuhan, daya tahan tubuh, dan memberikan nutrisi lengkap.','produk/01KP52TTGNCQF81TE31CVMBT81.png','2026-04-06 09:39:11','2026-11-09 13:45:23',0),(9,1,'Nico cat food',18000.00,1,'Makanan baru kucing nico adult tuna yang nikmat untuk kucing dewasa','produk/01KP532CBB73AHCA5MA9RB4N63.png','2026-04-10 02:07:57','2026-04-14 08:26:52',1),(10,1,'Bolt Ikan Ungu',20000.00,0,'Bolt Ikan Ungu merupakan makanan kucing kering rasa tuna dengan butiran renyah berbentuk ikan yang diformulasikan khusus untuk kucing dewasa. Kandungan Omega-6, taurin, serta vitamin di dalamnya berfungsi menjaga kesehatan kulit, mempertajam penglihatan, dan meningkatkan sistem kekebalan tubuh. Tekstur kibble-nya dirancang untuk membantu menjaga kebersihan gigi dengan cara mengurangi pembentukan plak secara alami.','produk/01KP52YE57YR84AF2DSVJ9NQWX.png','2026-04-11 11:47:37','2026-04-27 07:25:47',0),(11,1,'Bolt Donat Kuning 500g',20000.00,998,'Bolt Kuning merupakan makanan kucing kering rasa tuna dengan butiran (kibble) berbentuk donat yang renyah dan mudah dikunyah. Produk ini mengandung nutrisi seimbang untuk mendukung kesehatan kulit, keindahan bulu, serta daya tahan tubuh kucing dewasa. Selain itu, formulanya diperkaya dengan taurin untuk kesehatan mata dan serat alami guna mendukung sistem pencernaan yang optimal.','produk/01KP532ZCA8M3223WHFGAXNGYH.png','2026-04-11 11:47:37','2026-09-27 16:27:04',0),(12,1,'Bolt Salmon 800g',30000.00,10,'Bolt Salmon merupakan varian makanan kucing kering dengan butiran (kibble) berbentuk bulat yang diformulasikan khusus untuk menjaga daya tahan tubuh kucing dewasa. Kandungan protein sebesar 28% serta tambahan taurin di dalamnya sangat efektif untuk mendukung kesehatan penglihatan dan fungsi jantung. Diperkaya dengan Omega-6 dan Zink, pakan ini juga membantu menutrisi kulit agar sehat dan membuat bulu kucing menjadi lebih lebat serta berkilau.','produk/01KP534M52DPYP0D22YSWRNE9M.png','2026-04-11 11:47:37','2026-04-13 21:14:06',0),(13,1,'Cat Choize Adult Tuna',20000.00,10,'makanan kucing kering rasa tuna yang diformulasikan untuk memenuhi nutrisi harian kucing dewasa agar tetap aktif dan sehat. Produk ini mengandung serat pangan alami untuk mendukung sistem pencernaan serta kalsium untuk menjaga kekuatan tulang dan gigi. Setiap kemasannya hadir dalam pilihan ukuran 800 gram','produk/01KP538BA12X0FG83Q0P952ZZS.png','2026-04-11 11:47:37','2026-04-13 21:16:08',0),(14,1,'Cat Choize Adult Salmon',18000.00,0,' adalah makanan kering kucing berkualitas tinggi yang diformulasikan khusus untuk memenuhi kebutuhan nutrisi kucing dewasa di atas 1 tahun. Dengan rasa salmon yang gurih dan disukai kucing, makanan ini mengandung nutrisi lengkap, vitamin, dan mineral untuk memastikan kesehatan yang optimal. ','produk/01KP539MZ1C7653RZ4MKXEW706.png','2026-04-11 11:47:37','2026-08-21 13:35:15',0),(15,1,'cat choize kitten tuna',18000.00,18,'Cat Choize Kitten Tuna & Salmon (Pink) adalah makanan kucing kering bernutrisi lengkap yang diformulasikan khusus untuk anak kucing (usia 2-12 bulan) dan induk menyusui. Dengan kombinasi rasa ikan tuna dan salmon yang lezat, makanan ini diperkaya dengan susu untuk membantu pertumbuhan dan perkembangan yang tepat pada masa pertumbuhan.800 g','produk/01KP53V3ET5CQ0YSWB4Q0QSBQY.png','2026-04-11 11:47:37','2026-10-26 15:02:53',0),(16,1,'Lezatto tuna',18000.00,19,'merupakan makanan kering yang diformulasikan secara khusus untuk memenuhi nutrisi harian segar pilihan dan campuran susu, menghasilkan makanan kucing dengan kandungan nutrisi yang lengkap dan seimbang.','produk/01KP53XST2HTSY1QPA6NT509SG.png','2026-04-11 11:47:37','2026-10-06 20:56:21',0),(17,1,'cleo adult',18000.00,0,'iformulasikan dengan nutrisi lengkap dan seimbang, kaya protein tinggi dari ikan laut/ayam, serta diperkaya omega 3 & 6 untuk kulit dan bulu sehat','produk/01KP540E0CQZSKFKS6NV1C9PSV.png','2026-04-11 11:47:37','2026-10-06 15:42:05',0),(18,1,'Excel Oren tuna',18000.00,20,'Excel Orange adalah makanan kering premium yang dirancang khusus untuk memenuhi kebutuhan nutrisi harian kucing dewasa (adult). Dengan perpaduan rasa daging ayam dan tuna yang lezat, kibble berbentuk segitiga ini sangat disukai kucing dan mudah dikunyah. 500g\n','produk/01KP540W7GJW08RAJKJ4P8VCZM.png','2026-04-11 11:47:37','2026-04-13 21:29:42',0),(19,1,'Excel Hijau',18000.00,20,'. Diformulasikan khusus untuk kucing dewasa (adult) dengan aroma ikan tuna yang gurih dan lezat, dijamin membuat anabul (anak bulu) nafsu makan. 500g','produk/01KP541WXZB9FDW3MMPYN50GXY.png','2026-04-11 11:47:37','2026-04-13 21:30:05',0),(20,1,'Excel Kuning salmon',18000.00,14,'pilihan pakan kering berkualitas tinggi yang diformulasikan khusus untuk kucing dewasa, dengan aroma salmon yang menggugah selera dan disukai kucing. Dikemas dalam bentuk kibble koin yang unik, pakan ini tidak hanya lezat tetapi juga memberikan nutrisi seimbang 500g\n','produk/01KP542HH72MMSNYQ6MXYTPXAE.png','2026-04-11 11:47:37','2026-08-22 17:42:23',0),(21,1,'Excel Pink Mother & Kitten',18000.00,0,'Diformulasikan khusus oleh PT Japfa Comfeed untuk memenuhi kebutuhan nutrisi induk yang sedang hamil/menyusui serta pertumbuhan anak kucing.','produk/01KP5436040V3PMD1P7ATPNSY2.png','2026-04-11 11:47:37','2026-09-27 15:42:52',0),(22,1,'Omegga Cat Food Tuna',25000.00,19,' adalah makanan kucing kering (dry food) berkualitas yang diformulasikan khusus untuk memenuhi kebutuhan nutrisi harian kucing dewasa. Dibuat dengan rasa tuna yang lezat dan disukai kucing, pakan ini membantu menjaga kesehatan kulit, bulu, serta meningkatkan sistem kekebalan tubuh.1000g','produk/01KP543Q4J1KVD5TY144JZ5FD4.png','2026-04-11 11:47:37','2026-09-27 16:27:04',0),(23,1,'Maxi Premium Cat Food',30000.00,20,'pakan kucing kering berkualitas premium yang diformulasikan untuk memenuhi kebutuhan nutrisi kucing dari berbagai usia, baik kitten (anak kucing) maupun adult (dewasa). Dibuat dengan kombinasi lezat ayam dan tuna, makanan ini memberikan protein tinggi sebesar 32% untuk mendukung otot yang kuat dan kesehatan energi kucing. 1000g','produk/01KP544EDJXEEGZDS637P5576T.png','2026-04-11 11:47:37','2026-04-13 21:31:29',0),(24,1,'Mister Puss Dry Food - Tuna Flavor',18000.00,3,'Mister Puss adalah solusi makanan kucing kering berkualitas dengan harga ekonomis yang dirancang khusus untuk memenuhi kebutuhan nutrisi harian kucing dewasa (adult) semua ras. Dengan aroma tuna yang kuat dan lezat, produk ini sangat disukai kucing dan membantu meningkatkan nafsu makan. 500g','produk/01KP544ZRT9A50ZA77K5STWSCY.png','2026-04-11 11:47:37','2026-11-13 15:02:57',0),(25,1,'MISTER PUSS Salmon Dry Cat Food',18000.00,19,'Berikan nutrisi terbaik untuk kucing kesayangan Anda dengan Mister Puss Salmon Flavor. Makanan kering (dry food) ini diformulasikan khusus untuk kucing dewasa, menghadirkan aroma dan rasa salmon yang sangat disukai kucing. 500g','produk/01KP545MCC16CXS3RW9MZQ1GXM.png','2026-04-11 11:47:37','2026-11-12 15:03:11',0),(26,1,'Mister Puss Dry Cat Food - Tuna & Salmon',18000.00,20,'Berikan nutrisi terbaik untuk kucing kesayangan Anda dengan Mister Puss. Diformulasikan khusus untuk memenuhi kebutuhan gizi harian kucing dewasa dan kitten (6 bulan ke atas). Dengan tekstur kibble yang renyah, membantu mengurangi plak pada gigi. Kombinasi rasa Tuna dan Salmon yang lezat pasti disukai kucing, membantu meningkatkan nafsu makan. 500g','produk/01KP54658SZC3WF7P5Z49PS5XX.png','2026-04-11 11:47:37','2026-04-26 03:49:19',0),(27,1,'Felibite Ikan',18000.00,20,'makanan kucing kering (dry food) yang diformulasikan khusus untuk memenuhi kebutuhan nutrisi harian kucing dewasa maupun anakan. Dengan aroma ikan yang khas dan lezat, Felibite disukai oleh kucing. Diperkaya dengan Omega 3 & 6 untuk menjaga kesehatan kulit dan kilau bulu, serta taurine untuk kesehatan mata.500g','produk/01KP546PES8XP5MKGT1BQ05816.png','2026-04-11 11:47:37','2026-04-13 21:32:42',0),(28,1,'Pussbite Tuna Adult Dry Cat Food',18000.00,19,'\nPussbite Adult Tuna adalah makanan kering ekonomis berkualitas tinggi yang diformulasikan khusus untuk kucing dewasa (usia 1 tahun ke atas) oleh PT Matahari Sakti. Dengan perpaduan rasa tuna yang lezat dan aroma yang kuat, pakan ini sangat disukai oleh kucing. 400g','produk/01KP5476JT88B0MPK127GWPPY4.png','2026-04-11 11:47:37','2026-10-06 15:44:29',0),(29,1,'Amigo Adult Cat Food - Rasa Tuna',18000.00,19,' makanan kering (dry food) yang diformulasikan untuk memenuhi kebutuhan nutrisi kucing dewasa. Dengan rasa Tuna yang gurih dan disukai anabul, produk ini membantu menyehatkan kulit, memperkuat bulu, serta menjaga kesehatan gigi. Mengandung Omega 3 & 6, protein tinggi, serta taurine untuk kesehatan penglihatan dan jantung, menjadikan kucing lebih aktif dan sehat. No Pork (tidak mengandung babi) dan tanpa pewarna buatan. 800g','produk/01KP547R84F7ED3CDAZ2DQSX98.png','2026-04-11 11:47:37','2026-10-06 15:42:06',0),(30,1,'BOLT Mother & Kitten Tuna',18000.00,20,'pakan kucing berkualitas tinggi yang diformulasikan khusus untuk memenuhi kebutuhan nutrisi anak kucing (kitten) usia di bawah 1 tahun, serta aman dikonsumsi oleh induk hamil dan menyusui. Dibuat dengan rasa tuna yang lezat, makanan ini membantu meningkatkan nafsu makan si kecil.500g','produk/01KP5487Q6STZECT5CC6MFNN34.png','2026-04-11 11:47:37','2026-04-26 08:23:53',0),(31,2,'Obat 25K',25000.00,16,'Paket isi 2, biasanya kombinasi obat luar/dalam dan perlengkapan seperti parfum, obat jamur, atau obat tetes mata/telinga.','produk/01KP5497JMXTKZHN7HYPT1F9H9.png','2026-04-11 11:47:37','2026-10-06 20:56:30',0),(32,2,'Obat 30K',30000.00,19,'Formulanya ampuh mengeringkan luka dengan cepat dan mencegah infeksi sekunder pada kulit.','produk/01KP549QZ0WY8BV4GZNDCE1RKC.png','2026-04-11 11:47:37','2026-04-17 11:19:24',1),(33,2,'Obat Obat 45K',45000.00,20,'Detick adalah obat tetes kutu yang efektif membasmi kutu dewasa, larva, dan tungau pada kucing. Cairan ini bekerja merusak sistem saraf kutu dan memberikan perlindungan hingga 5 minggu. Cukup teteskan pada tengkuk kucing agar tidak terjilat dan kutu akan mati.','produk/01KP54ARQ6999MYHWZZB7Y8KY4.png','2026-04-11 11:47:37','2026-04-13 21:34:56',0),(34,2,'Parfum Kucing',20000.00,18,'Parfum khusus kucing ini diformulasikan aman, lembut, dan tidak mengandung alkohol sehingga tidak menyebabkan iritasi pada kulit sensitif anabul. Dengan keharuman yang tahan lama hingga 24 jam, produk ini efektif menghilangkan bau tidak sedap akibat aktivitas sehari-hari maupun sisa bau setelah mandi. Aroma yang lembut dan menenangkan membuat kucing tetap segar, wangi, dan nyaman sepanjang hari tanpa mengganggu penciumannya','produk/01KP54BVXAJMYGTYM6660G4DY6.png','2026-04-11 11:47:37','2026-08-12 17:03:37',0),(35,2,'Parfum Kandang',20000.00,18,'solusi efektif untuk menghilangkan bau tidak sedap bekas kotoran maupun urine hewan peliharaan. Produk ini diformulasikan khusus untuk membunuh bakteri, kuman, dan virus pada area kandang agar tetap higienis. Dengan aroma yang segar dan tahan lama, parfum ini menciptakan lingkungan yang nyaman dan aman bagi hewan kesayangan.','produk/01KP54FS0PY96VMZVF50D4Z8ZQ.png','2026-04-11 11:47:37','2026-10-06 21:07:53',0),(36,2,'Shampoo 100Ml',30000.00,19,'Sampo kucing 100ml ini diformulasikan khusus dengan bahan lembut untuk membersihkan kotoran dan menjaga kelembapan alami kulit serta bulu anabul. Produk ini efektif untuk mengatasi masalah umum seperti bulu rontok, kutu, dan jamur, sekaligus melembutkan bulu agar tidak mudah kusut.','produk/01KP54D1KM8KAXS5HRB6GMXDHM.png','2026-04-11 11:47:37','2026-08-12 17:13:28',0),(37,2,'Shampoo 250Ml',45000.00,19,'Sampo kucing 250ml diformulasikan khusus dengan pH seimbang untuk membersihkan kotoran serta minyak berlebih pada kulit dan bulu anabul secara lembut. Produk ini umumnya diperkaya bahan pelembap dan anti-jamur/kutu, yang efektif mengatasi gatal-gatal, jamur, serta membuat bulu lebih sehat, halus, dan berkilau.','produk/01KP54GWTT5N5XVESPYFEJ2YKT.png','2026-04-11 11:47:37','2026-08-12 05:02:15',0),(38,2,'Shampoo Kutu Jamur',40000.00,20,'Sampo ini mengandung bahan alami yang efektif membasmi kutu dan jamur sekaligus menenangkan kulit yang gatal. Formula khususnya aman untuk kulit sensitif dan mampu menjaga bulu tetap lembut serta berkilau. Cocok digunakan rutin untuk perlindungan total dari infeksi jamur dan kutu.','produk/01KP54KECEYK9HMMXWH17KA183.png','2026-04-11 11:47:37','2026-04-13 21:39:40',0),(39,2,'Shampoo Conditoner',50000.00,18,'diformulasikan khusus untuk membersihkan kotoran sekaligus melembutkan bulu kucing secara maksimal. Kandungan aktif di dalamnya efektif mengatasi masalah kulit seperti jamur, kutu, dan bulu rontok tanpa menyebabkan iritasi. Produk ini aman digunakan secara rutin karena pH-nya seimbang untuk kulit sensitif anabul.','produk/01KP54J9VMNXVZ03YKSGSABY7D.png','2026-04-11 11:47:37','2026-08-12 17:15:34',0),(40,2,'Spetan 1 ML',5000.00,18,'alat bantu makanan, vitamin, atau obat cair yang dirancang khusus untuk mempermudah pemberian nutrisi pada kucing, terutama kitten atau kucing yang sedang sakit. Alat ini terbuat dari bahan plastik food grade yang aman, steril, memiliki skala ukur presisi, serta tersedia dalam opsi dengan atau tanpa jarum. Ukurannya yang kecil dan ujung yang tumpul (jika tanpa jarum) sangat praktis dan nyaman untuk dimasukkan ke mulut hewan tanpa melukai.','produk/01KP54HVR69J4CRHW63BVC4227.png','2026-04-11 11:47:37','2026-08-22 17:55:32',0),(41,3,'Mainan 5K',5000.00,19,'mainan kucing supaya kucing tidak stress','produk/01KP54VF9E6VR5CA8VW2C5RPJJ.png','2026-04-11 11:47:37','2026-08-12 17:12:13',0),(42,3,'Mainan 10K',10000.00,18,'mainan supaya kucing tidak stress 10k','produk/01KP5NG7XCD8QST9R3SKQ8BFGY.png','2026-04-11 11:47:37','2026-09-27 16:27:04',0),(43,3,'Mainan 15K',15000.00,20,'mainann kucing supaya tidak stress 15k','produk/01KP5NJ7BDGGVX5KAS0HT9F11E.png','2026-04-11 11:47:37','2026-04-14 02:36:06',0),(44,3,'Mainan 20K',20000.00,20,'mainan kucing supaya tidak stress 20k','produk/01KP5NM1JPCNBMKBJS682M42GH.png','2026-04-11 11:47:37','2026-11-12 15:08:06',0),(45,3,'Kalung 10k',10000.00,20,'kalung klinting kucing 10k','produk/01KP5NNNJ74YZ8SJ18BFX18N98.png','2026-04-11 11:47:37','2026-04-14 02:37:59',0),(46,3,'Kalung 15k',15000.00,20,'kalung kucing 15k','produk/01KP5NQBZZ0BSNYEV79W9WMSRY.png','2026-04-11 11:47:37','2026-04-14 02:38:55',0),(47,4,'Baju Kucing S',25000.00,19,'Baju kucing untuk fashion','produk/01KP5NRXKYB18GDNME9458A6SR.png','2026-04-11 11:47:37','2026-11-19 13:46:22',0),(48,4,'Baju Kucing M',30000.00,20,'baju kucing buat fashion','produk/01KP5NXQ100MB0HXS35SEC2BJ8.png','2026-04-11 11:47:37','2026-11-19 13:45:37',0),(49,4,'Tempat makan kucing kecil',15000.00,19,'tempat makan kucing untuk ukuran kecil ','produk/01KP5NZVQ87BW5X7RRQFC49947.png','2026-04-11 11:47:37','2026-08-12 16:41:07',0),(51,4,'Tempat makan kucing penampung',30000.00,20,'Tempat makan kucing penampung banyak makanan','produk/01KP5P68AR15JKKKDJWRFRJDNC.png','2026-04-11 11:47:37','2026-11-19 13:47:10',0),(52,4,'Ps Anabul 5L Strawberry',40000.00,20,'pasir anabul 5L strawbery','produk/01KP5P82V39JDETCK3KNS4QCWZ.png','2026-04-11 11:47:37','2026-04-14 02:48:02',0),(53,4,'Ps Anbul 10L Strawbery',50000.00,0,'Pasir anabul 10 L dengan aroma strawbery','produk/01KP5PA9RFYAH0HMRQVXJYGT7F.png','2026-04-11 11:47:37','2026-05-03 05:14:32',0),(54,4,'Ps Anbul 25L Lavender',70000.00,20,'pasir anabul 25 L aroma lavender','produk/01KP5PC7PEEQRGEMX580DMF45G.png','2026-04-11 11:47:37','2026-11-12 15:11:32',0),(55,4,'Ps Taro 5L Cotton candy',30000.00,20,'pasir taro 5L cotoon candy','produk/01KP5PEVCT9856WGMWNV14M197.png','2026-04-11 11:47:37','2026-04-14 02:52:04',0),(56,4,'Ps Magnum 5L',20000.00,20,'pasir magnum kapasitas 5L','produk/01KP5PJFV02RC7APSPA4HM5STJ.png','2026-04-11 11:47:37','2026-04-14 02:53:43',0),(57,4,'Ps Magnum 25L',70000.00,18,'pasir 25 magnum\n','produk/01KP5PN1EG1N07172DSX700DKB.png','2026-04-11 11:47:37','2026-11-14 09:40:52',0),(58,4,'Ps Markotop 5L Capucino',20000.00,18,'pasir markotop kcapucino 5L','produk/01KP5PQB86R18RY0N024YWGTJK.png','2026-04-11 11:47:37','2026-09-30 22:32:25',0),(59,4,'Liter Box S',25000.00,18,'liter box kucing s','produk/01KP5PS55J6P91RS2EKR5DSBQK.png','2026-04-11 11:47:37','2026-10-06 20:56:30',0),(60,4,'Liter Box M',50000.00,19,'Liter box kucing M','produk/01KP5PT420ZVMYY3AP04FHFDKG.png','2026-04-11 11:47:37','2026-10-06 15:42:05',0),(61,4,'Liter Box L',75000.00,20,'Liter box kucing L','produk/01KP5PVBNPX0J11K6WKCA22ZXV.png','2026-04-11 11:47:37','2026-04-14 02:58:40',0),(62,4,'Liter Box XL',100000.00,19,'Liter box kucing XL','produk/01KP5Q2GVGA6Y6QPFZ51JBVY5F.png','2026-04-11 11:47:37','2026-08-12 03:12:38',0),(63,4,'Dot Besar',15000.00,20,'dot besar kucing','produk/01KP5Q7DKYRM4H00KQJ3H91E2D.png','2026-04-11 11:47:37','2026-04-14 03:05:09',1),(64,4,'Dot Kecil',10000.00,20,'Dot kecil ku','produk/01KP5Q8G60ZQZ6Z1JVJZYENFF6.png','2026-04-11 11:47:37','2026-04-14 03:05:45',1),(65,4,'Tali Tuntun',25000.00,20,'Tali tuntun kucing','produk/01KP5QAP9JMY0CFQSY0TN3NK0P.png','2026-04-11 11:47:37','2026-04-14 03:06:56',1),(66,4,'Gunting Kuku Bs',20000.00,17,'Gunting kuku Bs Kucing dengan aman','produk/01KP5QCMM8543VDZRVFJ31Q669.png','2026-04-11 11:47:37','2026-11-19 13:41:01',1),(67,4,'Kandang S',100000.00,18,'Kandang S kucing muat max 2 kucing','produk/01KP5QEWDKN67FHF3PV8B77Z37.png','2026-04-11 11:47:37','2026-10-06 21:01:09',1),(68,4,'Kandang XL kucing',150000.00,20,'kandang XL kucing maksimal 5 kucing','produk/01KP5QH5Y2SS1SS9SBFJSW60WS.png','2026-04-11 11:47:37','2026-04-14 03:10:29',2),(69,4,'PS Tofu Lifecat',25000.00,19,'Tofu pasir kucing lifecat','produk/01KP5QJRVF78JEV6PSB84FFX3S.png','2026-04-11 11:47:37','2026-11-19 13:56:08',3),(70,4,'PS Tofu Markotop Matcha',30000.00,13,'Tofu Markotop aroma matcha','produk/01KP5QNJBSGZFHH5DW16E2GN27.png','2026-04-11 11:47:37','2026-11-19 13:56:33',2),(72,3,'Mainan rumah kucing',500000.00,3,'mainan rumah kucing untuk tidak stress','produk/01M7QHXZ5ETE97XEV83N98QQN3.jpeg','2026-08-12 05:27:14','2026-11-18 21:45:47',0),(60073,2,'Obat  petumbuhan bulu kucing',20000.00,10,'obat pertumbuhan bulu kucing 15 ml','produk/01M7QHN8RE92KNQ11CSSY0JBFR.jpeg','2026-10-06 19:49:25','2026-11-19 13:41:27',0),(90073,1,'Universal world pet',10000.00,2,'makanan universal kucing','produk/01M7QHEMX267RBW3H6MHJAXE12.jpeg','2026-10-08 13:22:43','2026-11-19 20:37:03',0);
/*!40000 ALTER TABLE `produk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `google_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'customer',
  `pelanggan_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_pelanggan_id_foreign` (`pelanggan_id`),
  CONSTRAINT `users_pelanggan_id_foreign` FOREIGN KEY (`pelanggan_id`) REFERENCES `pelanggan` (`id_pelanggan`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=180001;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'dani','dani@gmail.com',NULL,NULL,'$2y$12$3lwCr6XzVE96pNu8/mpoUuDx.QU28AicV1E10O4LS9tC2ixsmJVwi',NULL,'2026-08-20 23:53:05','2026-08-20 23:53:05','customer',NULL),(2,'Rudi','rudi_customer@gmail.com',NULL,NULL,'$2y$12$EUewwX3hhZkOUTHjMJ8xLuH4JsfZmpxtPXoNpQKgmhcuF9LJryseq',NULL,'2026-03-07 00:21:02','2026-03-07 00:21:02','customer',NULL),(3,'abid','abidyo@gmail.com',NULL,NULL,'$2y$12$9YntQD17Ci/LRpPMu2YeMOm75UdnWsBXTTbu8ZM6UiDW.xT13pdPe',NULL,'2026-03-07 00:41:25','2026-03-07 00:41:25','customer',NULL),(5,'Samuel sudusin argo','samuel@gmail.com',NULL,NULL,'$2y$12$Xaz.ByXiEeolZR9Br1RQ5e3SE9RP8.8kOpHRel6ParskWTqy1VO7q',NULL,'2026-04-09 07:34:03','2026-04-09 07:34:03','customer',NULL),(6,'roland','roland@gmail.com',NULL,NULL,'$2y$12$bKc6oR13PV.KQ5pT9AN/j.h0q3Li1Il5CUaJUV0OmCy0EI9VfXDR2',NULL,'2026-04-13 03:12:00','2026-04-13 03:12:00','customer',NULL),(7,'Sutirno','sutirno@gmail.com',NULL,NULL,'$2y$12$rBNhtFa7yrgf3wNpnLsq7.82H3K6pGxiiJ1610ulkliD4qzDT0wRW',NULL,'2026-04-14 03:43:59','2026-04-14 03:43:59','customer',NULL),(8,'ajibu','ajib@gmail.com',NULL,NULL,'$2y$12$478vKwQbHXwqjgMghsdf5ey85xxXOfAn9WpKrxXfi2Kha7rQ28UVe',NULL,'2026-04-14 04:02:51','2026-04-14 04:02:51','customer',NULL),(9,'rambo rxking','rambo@gmail.com',NULL,NULL,'$2y$12$QtvTlclOQCZlWwe57D/5hOFxvu.E7.4OgOxVchS/ipPWByOzqYX3u',NULL,'2026-04-15 03:05:57','2026-04-15 03:05:57','customer',NULL),(10,'ayana','ayana@gmail.com',NULL,NULL,'$2y$12$XSlcp.k2GpeNIpeFyyrm9e25E18HnOPDd6GbzlTYTerNxMV.IHGu.',NULL,'2026-04-15 03:14:11','2026-04-15 03:14:11','customer',NULL),(11,'sakhi ardra','ardrasakhi390@gmail.com','101070601062846456840',NULL,'$2y$12$rrMDKfNAyAihgHxZuMm/O.SkB4N4s.2JGsud4J65yW4PXv6eUnuy6',NULL,'2026-04-16 21:21:54','2026-10-06 20:36:13','customer',1425001),(12,'Joko subianto','joko@gmail.com',NULL,NULL,'$2y$12$mQBLWCP3Xde/XsRsDIKd4OQtmRGzaxvH4OlMmUMWqkUL7G0O1/gzm',NULL,'2026-04-22 02:28:47','2026-04-22 02:28:47','customer',NULL),(13,'Sakhi ardra','ardrasakhi@gmail.com','104417136260505752957',NULL,'$2y$12$/tpUL7ugQR8RdfGtISqcWe2Vrp8jVZIJihlQi7rgEazc0WnmYn1tK',NULL,'2026-08-12 02:32:01','2026-10-30 15:47:08','customer',1515001),(14,'dobleh hans','skhiadr@student.polindra.ac.id','115137488076678344881',NULL,'$2y$12$d.vD1wT8L8gpQJXVj9ODJ.6RaHBG0uzGaNHoNELNHxWG5zJn8G.hm',NULL,'2026-08-12 03:08:54','2026-10-06 20:52:08','customer',1455001),(30001,'Superadmin','admin@gmail.com',NULL,NULL,'$2y$12$CaXcVSw3ll3EkTE/gtYJR.FLOxD/OaSNnsPE4AXibNYTRs1tiZGRa','0Xud1npkSrcUzPyjcfEHOfUOy4UVxE4Idhv37h2gYTWMojMJ0BmMlU53F7Yr','2026-08-20 17:27:11','2026-08-21 00:28:35','admin',NULL),(60001,'skirdrax Corporation','skirdraxcorporation@gmail.com','102872948247969803537',NULL,'$2y$12$12KpaA9LSCrIqnGz0fXxWupBJwynH7GPsfA8fq3TH9gwcQXA.BFr2',NULL,'2026-10-05 12:38:06','2026-10-06 20:36:39','customer',1425002),(90001,'TEAM KDR','rayenyen7@gmail.com','100479870625753653401',NULL,'$2y$12$hbeQ1KPoig7dsAkVVJ287OReRQir6xVSNmJANhiH7O.yCCLmTrFD.',NULL,'2026-10-06 20:57:36','2026-10-06 20:57:36','customer',1455002),(90002,'Rayen','Rayen@gmail.com',NULL,NULL,'$2y$12$QWDrl0wgj/ORQVmuNy7r5O/DzwB79v4dvEKk1xlH6enJ8Bpmw5e02',NULL,'2026-10-06 21:08:23','2026-10-06 21:08:23','customer',1455003),(120001,'Rendy Caninghem','rendycaninghem@gmail.com','103536505235496825610',NULL,'$2y$12$HniQEIaTxlwBlfiy1SY2vuVx3ymq3mrbAxaeocHpCsZBa9G8hE2Re',NULL,'2026-10-29 22:29:45','2026-10-29 22:29:45','customer',1485001),(150001,'ardi','ardi@gmail.com',NULL,NULL,'$2y$12$LcUIsj1fCpp9FaE75WRHBOP3l7NnAzgA.32Njp9edEfe.S.U7g1uu',NULL,'2026-11-17 12:47:32','2026-11-17 12:47:32','customer',3515001);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'test'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-22 23:05:50
