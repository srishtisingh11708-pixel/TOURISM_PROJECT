-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3308
-- Generation Time: Jul 15, 2026 at 02:13 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tourism_2026`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `name` varchar(100) NOT NULL,
  `mob` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `destination` varchar(100) NOT NULL,
  `dep_date` varchar(50) NOT NULL,
  `ret_date` varchar(50) DEFAULT NULL,
  `adults` varchar(11) NOT NULL DEFAULT '1',
  `children` varchar(11) NOT NULL DEFAULT '0',
  `transport_mode` varchar(20) NOT NULL,
  `carrier` varchar(100) NOT NULL,
  `travel_class` varchar(50) NOT NULL,
  `hotel` varchar(20) NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `total_amount` varchar(50) NOT NULL,
  `booking_date` varchar(50) NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contact`
--

CREATE TABLE `contact` (
  `name` varchar(20) DEFAULT NULL,
  `mob` varchar(30) DEFAULT NULL,
  `email` varchar(70) DEFAULT NULL,
  `des` varchar(50) NOT NULL,
  `trav` varchar(90) DEFAULT NULL,
  `month` varchar(50) NOT NULL,
  `msg` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact`
--

INSERT INTO `contact` (`name`, `mob`, `email`, `des`, `trav`, `month`, `msg`) VALUES
('72-Srishti Singh', '6565767868', 'srishtisingh11708@gmail.com', 'Ladakh', '4', 'March', 'best trip');

-- --------------------------------------------------------

--
-- Table structure for table `enquiry`
--

CREATE TABLE `enquiry` (
  `name` varchar(50) NOT NULL,
  `mob` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `des` varchar(50) NOT NULL,
  `mon` varchar(50) NOT NULL,
  `adu` varchar(50) NOT NULL,
  `child` varchar(50) NOT NULL,
  `tour` varchar(50) NOT NULL,
  `budg` varchar(50) NOT NULL,
  `hotel` varchar(50) NOT NULL,
  `trans` varchar(50) NOT NULL,
  `requir` varchar(200) NOT NULL,
  `con` varchar(50) NOT NULL,
  `cr` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enquiry`
--

INSERT INTO `enquiry` (`name`, `mob`, `email`, `des`, `mon`, `adu`, `child`, `tour`, `budg`, `hotel`, `trans`, `requir`, `con`, `cr`) VALUES
('72-Srishti Singh', '8009811671', 'srishtisingh708@gmail.com', 'goa', 'September', '2', '0', 'Group', 'premium', '5???', 'Flight', 'gcvbjnjnk', 'Afternoon (12 PM ??? 4 PM)', 'null');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `full_name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `destination` varchar(15) NOT NULL,
  `travel_date` varchar(50) NOT NULL,
  `rating` varchar(50) NOT NULL,
  `feedback_title` varchar(100) NOT NULL,
  `feedback_message` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`full_name`, `email`, `destination`, `travel_date`, `rating`, `feedback_title`, `feedback_message`) VALUES
('72-Srishti Singh', 'srishtisingh11708@gmail.com', 'Shimla', '2007-08-07', '4', 'amazing', 'ghjnbmnm'),
('srh', 'sh123@gmail.com', 'Rishikesh', '2009-08-01', '5', 'best', 'best trip'),
('72-Srishti Singh', 'srishtisingh11708@gmail.com', 'Manali', '0008-02-12', '5', 'best', 'b  bnb '),
('shreya', 'srishtisingh@gmail.com', 'Goa', '2004-08-06', '5', 'amazing', 'amazing');

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `email` varchar(50) NOT NULL,
  `pass` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`email`, `pass`) VALUES
('admin@gmail.com', 'abcd'),
('sri@gmail.com', 'sri123');

-- --------------------------------------------------------

--
-- Table structure for table `reg`
--

CREATE TABLE `reg` (
  `name` varchar(50) NOT NULL,
  `fname` varchar(70) NOT NULL,
  `mname` varchar(50) NOT NULL,
  `gender` varchar(50) NOT NULL,
  `quali` varchar(50) NOT NULL,
  `mob` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `profile` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `regdt` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reg`
--

INSERT INTO `reg` (`name`, `fname`, `mname`, `gender`, `quali`, `mob`, `city`, `email`, `profile`, `state`, `regdt`) VALUES
('Singh', '72-Srishti', 'rani', 'Female', 'MCA', '9648354867', 'gvhbjhk', 'srishtisingh11708@gmail.com', 'srishtisingh11708@gmail.comkalpana.jpeg', 'up', 'Tue Jul 14 17:56:54 IST 2026');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
