-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.0.22-community-nt


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema qrparking
--

CREATE DATABASE IF NOT EXISTS qrparking;
USE qrparking;

--
-- Definition of table `parking_cost`
--

DROP TABLE IF EXISTS `parking_cost`;
CREATE TABLE `parking_cost` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `hour` int(10) unsigned NOT NULL,
  `cost` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `parking_cost`
--

/*!40000 ALTER TABLE `parking_cost` DISABLE KEYS */;
INSERT INTO `parking_cost` (`id`,`hour`,`cost`) VALUES 
 (1,1,40);
/*!40000 ALTER TABLE `parking_cost` ENABLE KEYS */;


--
-- Definition of table `parking_details`
--

DROP TABLE IF EXISTS `parking_details`;
CREATE TABLE `parking_details` (
  `id` int(11) NOT NULL auto_increment,
  `vnumber` varchar(255) NOT NULL,
  `codeval` varchar(255) default NULL,
  `uid` varchar(255) default NULL,
  `uname` varchar(255) default NULL,
  `slot_name` varchar(255) default NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `parking_details`
--

/*!40000 ALTER TABLE `parking_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `parking_details` ENABLE KEYS */;


--
-- Definition of table `slot_booking`
--

DROP TABLE IF EXISTS `slot_booking`;
CREATE TABLE `slot_booking` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `uname` varchar(45) NOT NULL,
  `uid` varchar(45) NOT NULL,
  `pdate` varchar(45) NOT NULL,
  `stime` varchar(45) NOT NULL,
  `phrs` varchar(45) NOT NULL,
  `umail` varchar(45) character set latin1 collate latin1_bin NOT NULL,
  `slot_name` varchar(45) NOT NULL,
  `time` varchar(45) NOT NULL,
  `endtime` varchar(45) NOT NULL,
  `pcost` varchar(45) NOT NULL,
  `image_data` longblob,
  `codeval` varchar(45) default NULL,
  `ustatus` varchar(45) NOT NULL default 'No',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `slot_booking`
--

/*!40000 ALTER TABLE `slot_booking` DISABLE KEYS */;
/*!40000 ALTER TABLE `slot_booking` ENABLE KEYS */;


--
-- Definition of table `user_reg`
--

DROP TABLE IF EXISTS `user_reg`;
CREATE TABLE `user_reg` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `dob` varchar(45) NOT NULL,
  `gender` varchar(45) NOT NULL,
  `phone` varchar(45) NOT NULL,
  `address` varchar(300) NOT NULL,
  `password` varchar(45) NOT NULL,
  `ustatus` varchar(45) default 'No',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_reg`
--

/*!40000 ALTER TABLE `user_reg` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_reg` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
