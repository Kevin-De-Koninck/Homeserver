-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 29, 2016 at 05:54 PM
-- Server version: 5.5.44-0+deb8u1
-- PHP Version: 5.6.17-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `animal`
--
CREATE DATABASE IF NOT EXISTS `diablo` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `diablo`;

-- --------------------------------------------------------

--
-- Table structure for table `food`
--

CREATE TABLE IF NOT EXISTS `food` (
`ID` int(11) NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `What` text NOT NULL,
  `Dead` text NOT NULL,
  `Refused` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `food`
--

INSERT INTO `food` (`ID`, `Timestamp`, `What`, `Dead`, `Refused`) VALUES
(8, '2015-07-20 10:00:00', 'Grote rat', 'Yes', 'No'),
(9, '2015-07-31 10:00:00', 'Grote rat', 'Yes', 'No'),
(10, '2015-08-15 10:00:00', 'Grote rat', 'Yes', 'No'),
(11, '2015-09-02 10:00:00', 'Grote rat', 'Yes', 'No'),
(12, '2015-09-11 10:00:00', 'Medium rat', 'Yes', 'No'),
(13, '2015-09-21 10:00:00', 'Grote rat', 'Yes', 'No'),
(21, '2015-10-11 10:00:00', 'Grote rat', 'Yes', 'No'),
(22, '2015-10-24 10:00:00', 'Grote rat', 'Yes', 'No'),
(23, '2015-11-06 11:00:00', 'Medium rat', 'Yes', 'Yes'),
(24, '2015-11-16 20:07:44', 'Medium rat', 'Yes', 'No'),
(25, '2015-11-26 11:00:00', 'Kleine rat', 'Yes', 'No'),
(26, '2015-12-07 11:00:00', 'Medium rat', 'Yes', 'No'),
(27, '2015-12-19 19:09:10', 'Medium rat', 'Yes', 'No'),
(28, '2015-12-30 11:00:00', 'Medium rat', 'Yes', 'No'),
(29, '2016-01-11 20:00:12', 'Medium rat', 'Yes', 'No'),
(30, '2016-02-02 11:00:00', 'Medium rat', 'Yes', 'No'),
(31, '2016-02-25 18:59:18', 'Medium rat', 'Yes', 'No'),
(32, '2016-03-14 11:00:00', 'Medium rat', 'Yes', 'No'),
(33, '2016-04-10 10:00:00', 'Medium rat', 'Yes', 'No'),
(34, '2016-05-03 10:00:00', 'Volwassen rat', 'Yes', 'No'),
(35, '2016-06-01 10:00:00', 'Medium rat', 'Yes', 'No'),
(36, '2016-06-11 10:00:00', 'Volwassen rat', 'Yes', 'No'),
(37, '2016-07-10 10:00:00', 'Volwassen rat', 'Yes', 'No'),
(38, '2016-08-04 10:00:00', 'Volwassen rat', 'Yes', 'No'),
(41, '2016-08-21 10:00:00', 'Volwassen rar', 'Yes', 'No'),
(42, '2016-09-22 10:00:00', 'Volwassen rat', 'Yes', 'No');

-- --------------------------------------------------------

--
-- Table structure for table `length`
--

CREATE TABLE IF NOT EXISTS `length` (
`ID` int(11) NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Value` float NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `length`
--

INSERT INTO `length` (`ID`, `Timestamp`, `Value`) VALUES
(11, '2013-03-04 11:00:00', 55),
(12, '2013-04-01 10:00:00', 57),
(13, '2013-05-03 10:00:00', 60),
(14, '2013-06-01 10:00:00', 62),
(15, '2013-08-13 10:00:00', 66),
(16, '2013-09-11 10:00:00', 72),
(17, '2013-11-27 11:00:00', 80),
(18, '2014-03-26 11:00:00', 90),
(19, '2014-06-29 10:00:00', 110),
(20, '2014-08-02 10:00:00', 120),
(21, '2014-12-30 11:00:00', 150),
(22, '2015-03-28 11:00:00', 163),
(23, '2015-07-16 17:14:51', 178),
(24, '2015-10-24 10:00:00', 188),
(25, '2016-01-11 11:00:00', 195),
(26, '2016-05-22 10:00:00', 208),
(27, '2016-07-27 10:00:00', 208);

-- --------------------------------------------------------

--
-- Table structure for table `others`
--

CREATE TABLE IF NOT EXISTS `others` (
`ID` int(11) NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `What` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `others`
--

INSERT INTO `others` (`ID`, `Timestamp`, `What`) VALUES
(48, '2013-04-13 10:00:00', 'Check-up dierenparadijs'),
(49, '2013-04-27 10:00:00', 'Opendeurdag KHK'),
(50, '2013-06-07 10:00:00', 'Bloedmijten ontdekt in het terrarium en op Diablo'),
(51, '2013-06-09 10:00:00', 'Terrarium met anti-insecten behandeld en Diablo op keukenrol gezet. Diablo ook een lauw bad gegeven en ingesmeerd met olie tegen mijten.'),
(52, '2013-06-12 10:00:00', 'Terrarium behandeld tegen bloedmijten'),
(53, '2013-06-18 10:00:00', 'Terrarium behandeld tegen bloedmijten'),
(54, '2013-06-25 10:00:00', 'Terrarium heringericht, geen bloedmijten meer gevonden'),
(55, '2013-08-27 10:00:00', 'Succesvol overgeschakeld op diepvriesvoedsel'),
(56, '2013-09-11 10:00:00', 'Enorm slechte vervelling, meer dan 1 uur moeten helpen van kop tot staart was niet verveld'),
(57, '2014-01-26 11:00:00', 'Naar dierenparadijs geweest voor geslachtsbepaling -&gt; Vrouw'),
(58, '2014-09-11 10:00:00', 'Naar dierenarts gegaan voor bloed onder de schubben. &lt;br&gt;Minimum 10 dagen lang behandelen met ontsmetting'),
(59, '2016-08-09 10:00:00', 'Verhuist naar het nieuwe terrarium (1.80m x 1m x 0.55m)'),
(62, '2016-09-01 10:00:00', 'Naar dierenarts gegaan voor algemene controle. &lt;br&gt; Verticale strepen op huid komt door opgerold te liggen. &lt;br&gt; Meer pipi doen kan hormonaal zijn. &lt;br&gt; Gewicht was goed, lengte ook, temperaturen ook. &lt;br&gt; Note: Diablo was agressief.');

-- --------------------------------------------------------

--
-- Table structure for table `shedding`
--

CREATE TABLE IF NOT EXISTS `shedding` (
`ID` int(11) NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Result` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shedding`
--

INSERT INTO `shedding` (`ID`, `Timestamp`, `Result`) VALUES
(2, '2015-06-19 10:00:00', 'ok'),
(3, '2015-08-31 10:00:00', 'Volledig zelfstandig'),
(4, '2015-11-10 11:00:00', 'Volledig zelfstandig'),
(5, '2016-02-23 11:00:00', 'Volledig zelfstandig'),
(6, '2016-05-22 12:44:59', 'Volledig zelfstandig'),
(7, '2016-07-27 10:00:00', 'Volledig zelfstandig'),
(8, '2016-10-21 10:00:00', 'Volledig zelfstandig');

-- --------------------------------------------------------

--
-- Table structure for table `stats`
--

CREATE TABLE IF NOT EXISTS `stats` (
`ID` int(11) NOT NULL,
  `Info` text NOT NULL,
  `Value` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `stats`
--

INSERT INTO `stats` (`ID`, `Info`, `Value`) VALUES
(1, 'Name', 'Diablo'),
(2, 'Species', 'Boa Constrictor Imperator'),
(3, 'Morph', 'Wildkleur'),
(4, 'Gender', 'Vrouw'),
(5, 'Date of birth', '1/12/2012'),
(6, 'Ideal day temperature', '31°C'),
(7, 'Ideal night temperature', '25°C'),
(8, 'Ideal humidity', '60%');

-- --------------------------------------------------------

--
-- Table structure for table `weight`
--

CREATE TABLE IF NOT EXISTS `weight` (
`ID` int(11) NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Value` float NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `weight`
--

INSERT INTO `weight` (`ID`, `Timestamp`, `Value`) VALUES
(1, '2015-07-12 20:31:32', 3750),
(4, '2013-04-01 10:00:00', 115),
(5, '2013-06-01 10:00:00', 110),
(6, '2013-05-03 10:00:00', 127),
(7, '2013-03-04 11:00:00', 95),
(8, '2013-08-13 10:00:00', 179),
(9, '2014-03-26 11:00:00', 592),
(10, '2013-10-26 10:00:00', 260),
(11, '2013-11-27 11:00:00', 320),
(12, '2014-06-29 10:00:00', 1072),
(13, '2014-08-02 10:00:00', 1400),
(14, '2014-11-14 11:00:00', 2040),
(15, '2014-11-14 11:00:00', 2040),
(16, '2015-01-24 11:00:00', 2600),
(17, '2015-03-28 11:00:00', 2900),
(18, '2015-09-11 10:00:00', 4400),
(19, '2016-01-11 11:00:00', 6300),
(22, '2016-09-01 10:00:00', 6400);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `food`
--
ALTER TABLE `food`
 ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `length`
--
ALTER TABLE `length`
 ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `ID` (`ID`);

--
-- Indexes for table `others`
--
ALTER TABLE `others`
 ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `shedding`
--
ALTER TABLE `shedding`
 ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `stats`
--
ALTER TABLE `stats`
 ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `weight`
--
ALTER TABLE `weight`
 ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `food`
--
ALTER TABLE `food`
MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=43;
--
-- AUTO_INCREMENT for table `length`
--
ALTER TABLE `length`
MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=28;
--
-- AUTO_INCREMENT for table `others`
--
ALTER TABLE `others`
MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=63;
--
-- AUTO_INCREMENT for table `shedding`
--
ALTER TABLE `shedding`
MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `stats`
--
ALTER TABLE `stats`
MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `weight`
--
ALTER TABLE `weight`
MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=23;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
