-- MySQL dump 10.13  Distrib 5.7.20, for Win32 (AMD64)
--
-- Host: localhost    Database: finalproject
-- ------------------------------------------------------
-- Server version	5.7.20-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `finalproject`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `finalproject` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `finalproject`;

--
-- Table structure for table `alert`
--

DROP TABLE IF EXISTS `alert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert` (
  `idalert` int(11) NOT NULL AUTO_INCREMENT,
  `billid` int(11) DEFAULT NULL,
  `factoryName` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `body` varchar(100) DEFAULT NULL,
  `fromEmail` varchar(45) DEFAULT 'bshah267@gmail.com',
  PRIMARY KEY (`idalert`),
  KEY `fk_billalert_idx` (`billid`),
  CONSTRAINT `FK_ALERTBILL` FOREIGN KEY (`billid`) REFERENCES `bill` (`billId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert`
--

LOCK TABLES `alert` WRITE;
/*!40000 ALTER TABLE `alert` DISABLE KEYS */;
INSERT INTO `alert` VALUES (1,3,'SC Enviro','bhavik_23_10@yahoo.com','Payment due by 15 days from now','bshah267@gmail.com');
/*!40000 ALTER TABLE `alert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill`
--

DROP TABLE IF EXISTS `bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bill` (
  `billId` int(11) NOT NULL AUTO_INCREMENT,
  `salesorderid` int(11) DEFAULT NULL,
  `PriceWithTax` float DEFAULT NULL,
  `GeneratedDate` date DEFAULT NULL,
  PRIMARY KEY (`billId`),
  KEY `fk_salesorder_idx` (`salesorderid`),
  CONSTRAINT `fk_sales` FOREIGN KEY (`salesorderid`) REFERENCES `salesorder` (`salesOrderId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill`
--

LOCK TABLES `bill` WRITE;
/*!40000 ALTER TABLE `bill` DISABLE KEYS */;
INSERT INTO `bill` VALUES (1,1,1290.24,'2017-12-13'),(2,2,1008,'2017-12-13'),(3,3,2056.32,'2017-08-28');
/*!40000 ALTER TABLE `bill` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 Trigger PaymentInsert
after insert on Bill
for each row
begin
insert into payment(billid) values(new.billid);
call sp_billinsertfactory(new.billid);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `factory`
--

DROP TABLE IF EXISTS `factory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `factory` (
  `factoryId` int(11) NOT NULL AUTO_INCREMENT,
  `FactoryName` varchar(45) DEFAULT NULL,
  `Location` varchar(45) DEFAULT NULL,
  `emailid` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`factoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factory`
--

LOCK TABLES `factory` WRITE;
/*!40000 ALTER TABLE `factory` DISABLE KEYS */;
INSERT INTO `factory` VALUES (1,'NEU',NULL,'bhavik_23_10@yahoo.com'),(2,'JP Pharma',NULL,'bhavik_23_10@yahoo.com'),(3,'SC Enviro',NULL,'bhavik_23_10@yahoo.com'),(4,'Cipla',NULL,'bhavik_23_10@yahoo.com'),(5,'Sun Pharma',NULL,'bhavik_23_10@yahoo.com'),(6,'Endurance',NULL,'bhavik_23_10@yahoo.com');
/*!40000 ALTER TABLE `factory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factory_bill`
--

DROP TABLE IF EXISTS `factory_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `factory_bill` (
  `factoryid` int(11) DEFAULT NULL,
  `billid` int(11) DEFAULT NULL,
  KEY `fk_fctoryid_idx` (`factoryid`),
  KEY `fk_bill_billid_idx` (`billid`),
  CONSTRAINT `fk_bill_billid` FOREIGN KEY (`billid`) REFERENCES `bill` (`billId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_fctoryid` FOREIGN KEY (`factoryid`) REFERENCES `factory` (`factoryId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factory_bill`
--

LOCK TABLES `factory_bill` WRITE;
/*!40000 ALTER TABLE `factory_bill` DISABLE KEYS */;
INSERT INTO `factory_bill` VALUES (1,1),(2,2),(3,3);
/*!40000 ALTER TABLE `factory_bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factorystockinventory`
--

DROP TABLE IF EXISTS `factorystockinventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `factorystockinventory` (
  `factoryId` int(11) DEFAULT NULL,
  `factoryProductId` int(11) DEFAULT NULL,
  `quantity` int(11) unsigned DEFAULT NULL,
  KEY `fk_factoryid_idx` (`factoryId`),
  KEY `fk_factoryProductid_idx` (`factoryProductId`),
  CONSTRAINT `fk_factoryProductid` FOREIGN KEY (`factoryProductId`) REFERENCES `products` (`productsId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_factoryid` FOREIGN KEY (`factoryId`) REFERENCES `factory` (`factoryId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factorystockinventory`
--

LOCK TABLES `factorystockinventory` WRITE;
/*!40000 ALTER TABLE `factorystockinventory` DISABLE KEYS */;
INSERT INTO `factorystockinventory` VALUES (1,1,14),(1,2,7),(1,3,14),(1,4,14),(1,5,7),(1,6,14),(1,7,7),(1,8,14),(1,9,14),(1,10,14),(2,1,14),(2,2,7),(2,3,14),(2,4,14),(2,5,14),(2,6,7),(2,7,14),(2,8,7),(2,9,14),(2,10,14),(3,1,7),(3,2,14),(3,3,14),(3,4,14),(3,5,7),(3,6,14),(3,7,14),(3,8,7),(3,9,14),(3,10,14),(4,1,14),(4,2,14),(4,3,4),(4,4,4),(4,5,14),(4,6,14),(4,7,14),(4,8,14),(4,9,14),(4,10,4),(5,1,4),(5,2,14),(5,3,14),(5,4,14),(5,5,14),(5,6,14),(5,7,4),(5,8,14),(5,9,4),(5,10,14),(6,1,14),(6,2,14),(6,3,14),(6,4,14),(6,5,14),(6,6,4),(6,7,4),(6,8,14),(6,9,14),(6,10,4);
/*!40000 ALTER TABLE `factorystockinventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment` (
  `idPayment` int(11) NOT NULL AUTO_INCREMENT,
  `billId` int(11) DEFAULT NULL,
  `paymentReceived` char(1) DEFAULT 'N',
  `receivedDate` date DEFAULT NULL,
  `PaymentMethod` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idPayment`),
  KEY `fk_bill_idx` (`billId`),
  CONSTRAINT `fk_bill` FOREIGN KEY (`billId`) REFERENCES `bill` (`billId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (1,1,'Y','2017-12-13','Cheque Transaction'),(2,2,'Y','2017-12-13','Cheque Transaction'),(3,3,'N',NULL,NULL);
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `productsId` int(11) NOT NULL AUTO_INCREMENT,
  `ProductsName` varchar(45) DEFAULT NULL,
  `price` float DEFAULT NULL,
  PRIMARY KEY (`productsId`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Valves',400),(2,'MOtors',200),(3,'Pipes',50),(4,'Rubber',20),(5,'Safety Stciker',90),(6,'Wires',30),(7,'Gears',30),(8,'Switched',20),(9,'Tapes',80),(10,'BallBearing',150);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchaseorder`
--

DROP TABLE IF EXISTS `purchaseorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `purchaseorder` (
  `purchaseOrderId` int(11) NOT NULL AUTO_INCREMENT,
  `QuantityRequired` int(11) DEFAULT NULL,
  PRIMARY KEY (`purchaseOrderId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchaseorder`
--

LOCK TABLES `purchaseorder` WRITE;
/*!40000 ALTER TABLE `purchaseorder` DISABLE KEYS */;
INSERT INTO `purchaseorder` VALUES (1,3),(2,3),(3,3);
/*!40000 ALTER TABLE `purchaseorder` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger afterPOtoSO after
Insert on purchaseorder
for each row
begin
declare quant int;

insert into purchaseorderandfactory(purchaseorderid,factoryid,productsName)
(select (select purchaseorderid from purchaseorder order by 1 desc limit 1 ),
@factoryid,
products.Productsname 
from products, 
factorystockinventory fs,factory fi
where productsId = factoryProductId
and fs.factoryId = fi.factoryId
and fi.factoryId = @factoryid and fs.quantity < 5);

set quant = @quantity;
set @sumforsales = (select (sum((price*1.20)) * quant) from products where 
productsName in (select productsName from purchaseorderandfactory where 
purchaseorderid = (select purchaseorderid from purchaseorder order by 1 desc limit 1)));

insert into salesorder(purchaseOrderID,costwithoutTax) values(new.purchaseOrderID,(@sumforsales));
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `purchaseorderandfactory`
--

DROP TABLE IF EXISTS `purchaseorderandfactory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `purchaseorderandfactory` (
  `purchaseorderid` int(11) DEFAULT NULL,
  `factoryid` int(11) DEFAULT NULL,
  `productsName` varchar(45) DEFAULT NULL,
  KEY `fkfactoryid_idx` (`factoryid`),
  KEY `fkpurchasrOrder_idx` (`purchaseorderid`),
  CONSTRAINT `fk` FOREIGN KEY (`factoryid`) REFERENCES `factory` (`factoryId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fkp` FOREIGN KEY (`purchaseorderid`) REFERENCES `purchaseorder` (`purchaseOrderId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchaseorderandfactory`
--

LOCK TABLES `purchaseorderandfactory` WRITE;
/*!40000 ALTER TABLE `purchaseorderandfactory` DISABLE KEYS */;
INSERT INTO `purchaseorderandfactory` VALUES (1,1,'MOtors'),(1,1,'Safety Stciker'),(1,1,'Gears'),(2,2,'MOtors'),(2,2,'Wires'),(2,2,'Switched'),(3,3,'Valves'),(3,3,'Safety Stciker'),(3,3,'Switched');
/*!40000 ALTER TABLE `purchaseorderandfactory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `retailer`
--

DROP TABLE IF EXISTS `retailer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `retailer` (
  `RetailerId` int(11) NOT NULL AUTO_INCREMENT,
  `RetailerName` varchar(45) DEFAULT NULL,
  `RetailerLocation` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`RetailerId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `retailer`
--

LOCK TABLES `retailer` WRITE;
/*!40000 ALTER TABLE `retailer` DISABLE KEYS */;
INSERT INTO `retailer` VALUES (1,'dhawal',NULL),(2,'Infosys',NULL),(3,'Mehal',NULL),(4,'Bhavik',NULL),(5,'J & K enterprise',NULL);
/*!40000 ALTER TABLE `retailer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salesorder`
--

DROP TABLE IF EXISTS `salesorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `salesorder` (
  `salesOrderId` int(11) NOT NULL AUTO_INCREMENT,
  `purchaseOrderId` int(11) NOT NULL,
  `IsServiced` varchar(45) NOT NULL DEFAULT 'N',
  `Approved` char(1) DEFAULT NULL,
  `CostWithoutTax` float DEFAULT NULL,
  PRIMARY KEY (`salesOrderId`,`purchaseOrderId`),
  KEY `fk_purchaseorderid_idx` (`purchaseOrderId`),
  CONSTRAINT `fk_purchaseorderid` FOREIGN KEY (`purchaseOrderId`) REFERENCES `purchaseorder` (`purchaseOrderId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salesorder`
--

LOCK TABLES `salesorder` WRITE;
/*!40000 ALTER TABLE `salesorder` DISABLE KEYS */;
INSERT INTO `salesorder` VALUES (1,1,'Y','Y',1152),(2,2,'Y','Y',900),(3,3,'Y','Y',1836);
/*!40000 ALTER TABLE `salesorder` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`bhavik`@`%`*/ /*!50003 TRIGGER `finalproject`.`billGeneration`
AFTER UPDATE ON `finalproject`.`salesorder`
FOR EACH ROW
begin
if New.isServiced = 'Y'
then
insert into bill(salesOrderid,pricewithTax,generatedDate)
values(new.salesorderid,
(select (CostWithoutTax*1.12) from salesorder 
where salesorderid = new.salesorderid),curdate());
end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `shipping`
--

DROP TABLE IF EXISTS `shipping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipping` (
  `idshipping` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Address` varchar(45) DEFAULT NULL,
  `shippingcol` varchar(45) DEFAULT NULL,
  `ContactNo` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idshipping`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipping`
--

LOCK TABLES `shipping` WRITE;
/*!40000 ALTER TABLE `shipping` DISABLE KEYS */;
INSERT INTO `shipping` VALUES (1,'ABC','Mumbai',NULL,'98599666');
/*!40000 ALTER TABLE `shipping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipping_trader`
--

DROP TABLE IF EXISTS `shipping_trader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipping_trader` (
  `shippingid` int(11) DEFAULT NULL,
  `Receipt` int(11) NOT NULL AUTO_INCREMENT,
  `QuantityDespatched` varchar(45) DEFAULT NULL,
  `OrderDelivered` char(1) DEFAULT NULL,
  PRIMARY KEY (`Receipt`),
  UNIQUE KEY `Receipt_UNIQUE` (`Receipt`),
  KEY `fk_ship_idx` (`shippingid`),
  CONSTRAINT `fk_ship` FOREIGN KEY (`shippingid`) REFERENCES `shipping` (`idshipping`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipping_trader`
--

LOCK TABLES `shipping_trader` WRITE;
/*!40000 ALTER TABLE `shipping_trader` DISABLE KEYS */;
INSERT INTO `shipping_trader` VALUES (1,1,'3','Y'),(1,2,'3','Y'),(1,3,'3','Y');
/*!40000 ALTER TABLE `shipping_trader` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stockinventory`
--

DROP TABLE IF EXISTS `stockinventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stockinventory` (
  `productsId` int(11) NOT NULL,
  `Quantity` int(10) unsigned DEFAULT NULL,
  KEY `fk_productsID_idx` (`productsId`),
  CONSTRAINT `fk_productsID` FOREIGN KEY (`productsId`) REFERENCES `products` (`productsId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stockinventory`
--

LOCK TABLES `stockinventory` WRITE;
/*!40000 ALTER TABLE `stockinventory` DISABLE KEYS */;
INSERT INTO `stockinventory` VALUES (1,7),(2,1),(3,4),(4,10),(5,4),(6,10),(7,4),(8,10),(9,10),(10,10);
/*!40000 ALTER TABLE `stockinventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trader`
--

DROP TABLE IF EXISTS `trader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trader` (
  `RetailerId` int(11) DEFAULT NULL,
  `purchaseOrderId` int(11) NOT NULL,
  `stockInventoryId` char(1) DEFAULT NULL,
  `salesOrderId` int(11) DEFAULT NULL,
  `LorryReceipt` int(11) DEFAULT NULL,
  `Despatched` char(1) DEFAULT NULL,
  `retailerSalesOrder` int(11) DEFAULT NULL,
  UNIQUE KEY `unique_index` (`RetailerId`,`retailerSalesOrder`),
  KEY `fk_retailerid_idx` (`RetailerId`),
  KEY `fk_purchaseOrder_idx` (`purchaseOrderId`),
  KEY `fk_SalesOrder_idx` (`salesOrderId`),
  KEY `fk_shipping_idx` (`LorryReceipt`),
  CONSTRAINT `fk_SalesOrder` FOREIGN KEY (`salesOrderId`) REFERENCES `salesorder` (`salesOrderId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_purchaseOrder` FOREIGN KEY (`purchaseOrderId`) REFERENCES `purchaseorder` (`purchaseOrderId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_retailerid` FOREIGN KEY (`RetailerId`) REFERENCES `retailer` (`RetailerId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipping` FOREIGN KEY (`LorryReceipt`) REFERENCES `shipping_trader` (`Receipt`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trader`
--

LOCK TABLES `trader` WRITE;
/*!40000 ALTER TABLE `trader` DISABLE KEYS */;
INSERT INTO `trader` VALUES (NULL,1,'Y',1,1,'Y',NULL),(1,2,'Y',2,2,'Y',1),(1,3,'Y',3,3,'Y',2);
/*!40000 ALTER TABLE `trader` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `v_payment_alert`
--

DROP TABLE IF EXISTS `v_payment_alert`;
/*!50001 DROP VIEW IF EXISTS `v_payment_alert`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_payment_alert` AS SELECT 
 1 AS `billid`*/;
SET character_set_client = @saved_cs_client;

--
-- Current Database: `finalproject`
--

USE `finalproject`;

--
-- Final view structure for view `v_payment_alert`
--

/*!50001 DROP VIEW IF EXISTS `v_payment_alert`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`bhavik`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_payment_alert` AS select `p`.`billId` AS `billid` from (`payment` `p` join `bill` `b`) where ((`p`.`paymentReceived` = 'N') and ((to_days(curdate()) - to_days(cast(`b`.`GeneratedDate` as char charset utf8))) > 75)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-12-13 13:32:21
