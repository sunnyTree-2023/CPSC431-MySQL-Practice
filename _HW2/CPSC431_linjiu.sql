-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 03, 2023 at 08:59 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- 2023/03/03
-- Database: `cpsc431_linjiu`
--
CREATE DATABASE IF NOT EXISTS `cpsc431_linjiu` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `cpsc431_linjiu`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `create_pet`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_pet` (IN `p_name` VARCHAR(255), IN `p_species` VARCHAR(255), IN `p_pet_owner_idx` INT(11), IN `p_color_idx` INT(11))   BEGIN

INSERT INTO pet(`name`, `species`,`pet_owner_idx`,`color_idx`) 
VALUES (p_name, p_species, p_pet_owner_idx, p_color_idx); 

SELECT `id`,`name`,`species` FROM `pet`
WHERE `idx`=LAST_INSERT_ID();

END$$

DROP PROCEDURE IF EXISTS `delete_pet`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_pet` (IN `p_idx` INT(11))   BEGIN
DELETE FROM pet 
WHERE idx= p_idx;
SELECT "success" as `status`;
END$$

DROP PROCEDURE IF EXISTS `find_reminder_pets`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `find_reminder_pets` ()   SELECT p.name AS "pet_name", 
CONCAT(o.first_name, " ", o.last_name) AS "owner_name",
o.last_visit AS "last_visit"
FROM pet AS p
JOIN pet_owner AS o
ON p.pet_owner_idx = o.idx    
WHERE o.last_visit < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)$$

DROP PROCEDURE IF EXISTS `read_owners_pets`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `read_owners_pets` (IN `p_idx` INT(11))   BEGIN

SELECT p.name AS pet_name, p.species, c.name AS color
FROM pet AS p
JOIN color AS c
JOIN pet_owner AS o
ON p.pet_owner_idx = o.idx AND p.color_idx = c.idx

WHERE o.idx = p_idx;

END$$

DROP PROCEDURE IF EXISTS `read_pet`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `read_pet` (IN `p_idx` INT(11))   BEGIN 

SELECT p.id, p.name, p.species, c.name AS color, 
CONCAT(o.first_name," ", o.last_name) AS `owner` 
FROM `pet` AS p 
JOIN `pet_owner` AS o 
JOIN `color` AS c 
ON p.pet_owner_idx = o.idx AND p.color_idx = c.idx 
WHERE p.idx = p_idx;

END$$

DROP PROCEDURE IF EXISTS `update_pet`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_pet` (IN `p_idx` INT(11), IN `p_name` VARCHAR(255), IN `p_species` VARCHAR(255), IN `p_pet_owner_idx` INT(11), IN `p_color_idx` INT(11))   BEGIN

UPDATE pet
SET `name` = p_name, `species` = p_species, 
`pet_owner_idx` = p_pet_owner_idx, `color_idx` = p_color_idx
WHERE pet.idx = p_idx;


SELECT p.id, p.name, p.species
#, c.name AS color, CONCAT(o.first_name," ", o.last_name) AS `owner` 
FROM `pet` AS p 
#JOIN `pet_owner` AS o 
#JOIN `color` AS c 
#ON p.pet_owner_idx = o.idx AND p.color_idx = c.idx 
WHERE p.idx = p_idx;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `color`
--

DROP TABLE IF EXISTS `color`;
CREATE TABLE `color` (
  `idx` int(11) NOT NULL,
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `color`
--

INSERT INTO `color` (`idx`, `id`, `name`) VALUES
(1, 'cbc9da5e-b956-11ed-b638-dc1ba144d2c9', 'Brown'),
(2, 'cbd17871-b956-11ed-b638-dc1ba144d2c9', 'Black'),
(3, 'cbd5c4cf-b956-11ed-b638-dc1ba144d2c9', 'White'),
(4, 'cbd98b56-b956-11ed-b638-dc1ba144d2c9', 'Orange'),
(5, 'cbdced7c-b956-11ed-b638-dc1ba144d2c9', 'Yellow'),
(6, 'cbe03281-b956-11ed-b638-dc1ba144d2c9', 'Gray');

--
-- Triggers `color`
--
DROP TRIGGER IF EXISTS `tr_color_id`;
DELIMITER $$
CREATE TRIGGER `tr_color_id` BEFORE INSERT ON `color` FOR EACH ROW BEGIN

SET NEW.id = UUID();

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pet`
--

DROP TABLE IF EXISTS `pet`;
CREATE TABLE `pet` (
  `idx` int(11) NOT NULL,
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `species` varchar(255) NOT NULL,
  `pet_owner_idx` int(11) NOT NULL,
  `color_idx` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pet`
--

INSERT INTO `pet` (`idx`, `id`, `name`, `species`, `pet_owner_idx`, `color_idx`) VALUES
(1, '5d856ff4-b957-11ed-b638-dc1ba144d2c9', 'Fluffy', 'Dog', 2, 1),
(2, '5d85952c-b957-11ed-b638-dc1ba144d2c9', 'Sparky', 'Cat', 1, 3),
(3, '836bb93b-b957-11ed-b638-dc1ba144d2c9', 'Jeremy', 'Ferret', 3, 6),
(4, '836be31e-b957-11ed-b638-dc1ba144d2c9', 'Diego.151', 'Cat', 3, 2),
(5, '0b0f7252-b958-11ed-b638-dc1ba144d2c9', 'kk', 'doggie', 1, 1),
(7, '627b6a83-b958-11ed-b638-dc1ba144d2c9', 'ooo', 'o', 1, 1),
(16, '4b31d813-b9f7-11ed-b638-dc1ba144d2c9', 'updatedPet', 'cat', 3, 2);

--
-- Triggers `pet`
--
DROP TRIGGER IF EXISTS `tr_pet_id`;
DELIMITER $$
CREATE TRIGGER `tr_pet_id` BEFORE INSERT ON `pet` FOR EACH ROW BEGIN

SET NEW.id = UUID();

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pet_owner`
--

DROP TABLE IF EXISTS `pet_owner`;
CREATE TABLE `pet_owner` (
  `idx` int(11) NOT NULL,
  `id` varchar(36) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `last_visit` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pet_owner`
--

INSERT INTO `pet_owner` (`idx`, `id`, `first_name`, `last_name`, `last_visit`) VALUES
(1, '059d5ba1-b957-11ed-b638-dc1ba144d2c9', 'Jiu', 'Lin', '2020-02-02'),
(2, '059d79c2-b957-11ed-b638-dc1ba144d2c9', 'Bob', 'McTesterson', '2023-01-01'),
(3, '10d14476-b957-11ed-b638-dc1ba144d2c9', 'Jiu', 'Test', '2020-05-10');

--
-- Triggers `pet_owner`
--
DROP TRIGGER IF EXISTS `tr_pet_owner_id`;
DELIMITER $$
CREATE TRIGGER `tr_pet_owner_id` BEFORE INSERT ON `pet_owner` FOR EACH ROW BEGIN

SET NEW.id = UUID();

END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `color`
--
ALTER TABLE `color`
  ADD PRIMARY KEY (`idx`);

--
-- Indexes for table `pet`
--
ALTER TABLE `pet`
  ADD PRIMARY KEY (`idx`),
  ADD KEY `fk_color_idx` (`color_idx`),
  ADD KEY `fk_pet_owner_idx` (`pet_owner_idx`);

--
-- Indexes for table `pet_owner`
--
ALTER TABLE `pet_owner`
  ADD PRIMARY KEY (`idx`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `color`
--
ALTER TABLE `color`
  MODIFY `idx` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `pet`
--
ALTER TABLE `pet`
  MODIFY `idx` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `pet_owner`
--
ALTER TABLE `pet_owner`
  MODIFY `idx` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `pet`
--
ALTER TABLE `pet`
  ADD CONSTRAINT `fk_color_idx` FOREIGN KEY (`color_idx`) REFERENCES `color` (`idx`),
  ADD CONSTRAINT `fk_pet_owner_idx` FOREIGN KEY (`pet_owner_idx`) REFERENCES `pet_owner` (`idx`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
