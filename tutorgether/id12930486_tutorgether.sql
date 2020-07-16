-- phpMyAdmin SQL Dump
-- version 4.9.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 15, 2020 at 10:47 AM
-- Server version: 10.3.18-MariaDB
-- PHP Version: 7.3.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `id12930486_tutorgether`
--

-- --------------------------------------------------------

--
-- Table structure for table `BOOK`
--

CREATE TABLE `BOOK` (
  `ID` varchar(30) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `PRICE` varchar(10) NOT NULL,
  `QUANTITY` varchar(10) NOT NULL,
  `TYPE` varchar(20) NOT NULL,
  `DATE` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `CART`
--

CREATE TABLE `CART` (
  `EMAIL` varchar(50) CHARACTER SET latin1 NOT NULL,
  `BKID` varchar(20) CHARACTER SET latin1 NOT NULL,
  `CQUANTITY` varchar(10) CHARACTER SET latin1 NOT NULL,
  `STATUS` varchar(10) CHARACTER SET latin1 DEFAULT 'notpaid'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `CARTHISTORY`
--

CREATE TABLE `CARTHISTORY` (
  `EMAIL` varchar(50) NOT NULL,
  `ORDERID` varchar(100) NOT NULL,
  `BILLID` varchar(20) NOT NULL,
  `BKID` varchar(30) NOT NULL,
  `CQUANTITY` varchar(10) NOT NULL,
  `DATE` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `PAYMENT`
--

CREATE TABLE `PAYMENT` (
  `ORDERID` varchar(100) CHARACTER SET latin1 NOT NULL,
  `BILLID` varchar(10) CHARACTER SET latin1 NOT NULL,
  `TOTAL` varchar(10) CHARACTER SET latin1 NOT NULL,
  `USERID` varchar(100) CHARACTER SET latin1 NOT NULL,
  `DATE` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `USER`
--

CREATE TABLE `USER` (
  `NAME` varchar(50) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `PHONE` varchar(12) NOT NULL,
  `PASSWORD` varchar(60) NOT NULL,
  `CREDIT` varchar(5) NOT NULL,
  `VERIFY` varchar(1) NOT NULL,
  `DATAREG` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `USER`
--

INSERT INTO `USER` (`NAME`, `EMAIL`, `PHONE`, `PASSWORD`, `CREDIT`, `VERIFY`, `DATAREG`) VALUES
('unregistered', 'unregistered@tutorgether.com', '0111111111', '123456789', '0', '1', '2012-02-20');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
