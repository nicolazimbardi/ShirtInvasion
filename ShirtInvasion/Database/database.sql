-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: shirtinvasion
-- ------------------------------------------------------
-- Server version	8.4.9

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
-- Table structure for table `dettagli_ordine`
--

DROP TABLE IF EXISTS `dettagli_ordine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dettagli_ordine` (
  `id_dettaglio` int NOT NULL AUTO_INCREMENT,
  `id_ordine` int NOT NULL,
  `id_prodotto` int DEFAULT NULL,
  `nome_prodotto` varchar(100) NOT NULL,
  `prezzo_unitario` decimal(8,2) NOT NULL,
  `quantita` int NOT NULL,
  PRIMARY KEY (`id_dettaglio`),
  KEY `id_ordine` (`id_ordine`),
  CONSTRAINT `dettagli_ordine_ibfk_1` FOREIGN KEY (`id_ordine`) REFERENCES `ordini` (`id_ordine`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dettagli_ordine`
--

LOCK TABLES `dettagli_ordine` WRITE;
/*!40000 ALTER TABLE `dettagli_ordine` DISABLE KEYS */;
/*!40000 ALTER TABLE `dettagli_ordine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordini`
--

DROP TABLE IF EXISTS `ordini`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordini` (
  `id_ordine` int NOT NULL AUTO_INCREMENT,
  `id_utente` int NOT NULL,
  `data_ordine` datetime DEFAULT CURRENT_TIMESTAMP,
  `totale` decimal(10,2) NOT NULL,
  `stato` enum('IN_LAVORAZIONE','SPEDITO','CONSEGNATO') DEFAULT 'IN_LAVORAZIONE',
  PRIMARY KEY (`id_ordine`),
  KEY `id_utente` (`id_utente`),
  CONSTRAINT `ordini_ibfk_1` FOREIGN KEY (`id_utente`) REFERENCES `utenti` (`id_utente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordini`
--

LOCK TABLES `ordini` WRITE;
/*!40000 ALTER TABLE `ordini` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordini` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prodotti`
--

DROP TABLE IF EXISTS `prodotti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prodotti` (
  `id_prodotto` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `squadra` varchar(100) NOT NULL,
  `stagione` varchar(20) DEFAULT NULL,
  `marca` varchar(50) DEFAULT NULL,
  `taglia` varchar(10) DEFAULT NULL,
  `prezzo` decimal(8,2) NOT NULL,
  `quantita` int NOT NULL,
  `descrizione` text,
  `immagine` varchar(255) DEFAULT NULL,
  `attivo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_prodotto`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prodotti`
--

LOCK TABLES `prodotti` WRITE;
/*!40000 ALTER TABLE `prodotti` DISABLE KEYS */;
INSERT INTO `prodotti` VALUES (1,'Manchester United Home','Manchester United','2020/21','Adidas','L',79.99,10,'Maglia Bruno Fernandes',NULL,1);
/*!40000 ALTER TABLE `prodotti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utenti`
--

DROP TABLE IF EXISTS `utenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utenti` (
  `id_utente` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `cognome` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `indirizzo` varchar(255) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `ruolo` enum('CLIENTE','ADMIN') DEFAULT 'CLIENTE',
  PRIMARY KEY (`id_utente`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utenti`
--

LOCK TABLES `utenti` WRITE;
/*!40000 ALTER TABLE `utenti` DISABLE KEYS */;
INSERT INTO `utenti` VALUES (1,'Nicola','Zimbardi','nicolazim@gmail.it','admin123',NULL,NULL,'ADMIN'),(2,'Lorenzo','Scariati','lolloscariati@gmail.it','admin123',NULL,NULL,'ADMIN');
/*!40000 ALTER TABLE `utenti` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-18 11:19:28
