-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 29, 2016 at 06:07 PM
-- Server version: 5.5.44-0+deb8u1
-- PHP Version: 5.6.17-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `sensors`
--
CREATE DATABASE IF NOT EXISTS `sensors` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `sensors`;

-- --------------------------------------------------------

--
-- Table structure for table `rvsensor`
--

DROP TABLE IF EXISTS `rvsensor`;
CREATE TABLE IF NOT EXISTS `rvsensor` (
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Value` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
CREATE TABLE IF NOT EXISTS `settings` (
  `Variable` text NOT NULL,
  `Value` float NOT NULL,
`ID` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`Variable`, `Value`, `ID`) VALUES
('DAY_TEMP_HOT', 30, 1),
('DAY_TEMP_COLD', 27, 2),
('NIGHT_TEMP_HOT', 25, 3),
('NIGHT_TEMP_COLD', 23, 4),
('DELTA_TEMP', 0.1, 5),
('RV_MIN', 1, 6),
('HEATER_TEMP_MAX', 80, 8),
('HOTSPOT_TEMP', 33, 9);

-- --------------------------------------------------------

--
-- Table structure for table `tempcoldside`
--

DROP TABLE IF EXISTS `tempcoldside`;
CREATE TABLE IF NOT EXISTS `tempcoldside` (
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Value` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tempcoldside`
--

INSERT INTO `tempcoldside` (`Timestamp`, `Value`) VALUES
('2016-10-29 16:05:51', 27),
('2016-10-29 16:05:57', 27),
('2016-10-29 16:06:02', 27),
('2016-10-29 16:06:10', 27),
('2016-10-29 16:06:16', 26.9),
('2016-10-29 16:06:20', 26.9),
('2016-10-29 16:06:26', 26.9),
('2016-10-29 16:06:32', 26.9),
('2016-10-29 16:06:37', 26.9),
('2016-10-29 16:06:42', 26.9),
('2016-10-29 16:06:47', 26.9),
('2016-10-29 16:06:53', 26.9),
('2016-10-29 16:06:58', 26.9),
('2016-10-29 16:07:04', 27),
('2016-10-29 16:07:08', 27),
('2016-10-29 16:07:15', 27),
('2016-10-29 16:07:20', 27),
('2016-10-29 16:07:24', 27),
('2016-10-29 16:07:29', 27.1),
('2016-10-29 16:07:35', 27.1),
('2016-10-29 16:07:39', 27.1),
('2016-10-29 16:07:44', 27.1);

-- --------------------------------------------------------

--
-- Table structure for table `temphideplace`
--

DROP TABLE IF EXISTS `temphideplace`;
CREATE TABLE IF NOT EXISTS `temphideplace` (
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Value` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `temphideplace`
--

INSERT INTO `temphideplace` (`Timestamp`, `Value`) VALUES
('2016-10-29 16:06:10', 26.9),
('2016-10-29 16:06:16', 26.9),
('2016-10-29 16:06:20', 26.9),
('2016-10-29 16:06:26', 26.9),
('2016-10-29 16:06:32', 26.9),
('2016-10-29 16:06:37', 26.9),
('2016-10-29 16:06:42', 26.9),
('2016-10-29 16:06:47', 26.9),
('2016-10-29 16:06:53', 26.9),
('2016-10-29 16:06:58', 26.9),
('2016-10-29 16:07:04', 26.9),
('2016-10-29 16:07:08', 26.8),
('2016-10-29 16:07:15', 26.9),
('2016-10-29 16:07:20', 26.9),
('2016-10-29 16:07:24', 26.9),
('2016-10-29 16:07:29', 26.9),
('2016-10-29 16:07:35', 26.9),
('2016-10-29 16:07:39', 26.9),
('2016-10-29 16:07:44', 26.9);

-- --------------------------------------------------------

--
-- Table structure for table `temphotside`
--

DROP TABLE IF EXISTS `temphotside`;
CREATE TABLE IF NOT EXISTS `temphotside` (
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Value` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `temphotside`
--

INSERT INTO `temphotside` (`Timestamp`, `Value`) VALUES
('2016-10-29 16:06:16', 29.9),
('2016-10-29 16:06:20', 29.9),
('2016-10-29 16:06:26', 29.9),
('2016-10-29 16:06:32', 29.8),
('2016-10-29 16:06:37', 29.8),
('2016-10-29 16:06:42', 29.8),
('2016-10-29 16:06:47', 29.8),
('2016-10-29 16:06:53', 29.8),
('2016-10-29 16:06:58', 29.8),
('2016-10-29 16:07:04', 29.8),
('2016-10-29 16:07:08', 29.8),
('2016-10-29 16:07:15', 29.9),
('2016-10-29 16:07:20', 29.9),
('2016-10-29 16:07:24', 29.9),
('2016-10-29 16:07:29', 29.9),
('2016-10-29 16:07:35', 29.9),
('2016-10-29 16:07:39', 29.9),
('2016-10-29 16:07:44', 30);

-- --------------------------------------------------------

--
-- Table structure for table `temphotspot`
--

DROP TABLE IF EXISTS `temphotspot`;
CREATE TABLE IF NOT EXISTS `temphotspot` (
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Value` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `temphotspot`
--

INSERT INTO `temphotspot` (`Timestamp`, `Value`) VALUES
('2016-10-29 16:06:20', 30.3),
('2016-10-29 16:06:25', 30.3),
('2016-10-29 16:06:32', 30.3),
('2016-10-29 16:06:37', 30.3),
('2016-10-29 16:06:42', 30.3),
('2016-10-29 16:06:47', 30.3),
('2016-10-29 16:06:53', 30.3),
('2016-10-29 16:06:57', 30.3),
('2016-10-29 16:07:03', 30.3),
('2016-10-29 16:07:08', 30.3),
('2016-10-29 16:07:14', 30.3),
('2016-10-29 16:07:20', 30.3),
('2016-10-29 16:07:24', 30.3),
('2016-10-29 16:07:29', 30.3),
('2016-10-29 16:07:34', 30.3),
('2016-10-29 16:07:39', 30.4),
('2016-10-29 16:07:44', 30.4);

-- --------------------------------------------------------

--
-- Table structure for table `temprvsensor`
--

DROP TABLE IF EXISTS `temprvsensor`;
CREATE TABLE IF NOT EXISTS `temprvsensor` (
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Value` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
 ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=10;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
