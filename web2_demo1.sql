-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 15, 2025 at 09:49 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `web2_demo1`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `CategoryName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `CategoryName`) VALUES
(1, 'Ice Coffee'),
(3, 'Mga Pan'),
(4, 'Juice'),
(5, 'Pasta'),
(7, 'Coffee');

-- --------------------------------------------------------

--
-- Table structure for table `inventoryproduct`
--

CREATE TABLE `inventoryproduct` (
  `id` int(11) NOT NULL,
  `ProductName` varchar(100) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `UnitPrice` decimal(10,2) DEFAULT NULL,
  `CategoryID (FK)` int(11) DEFAULT NULL,
  `SupplierID (FK)` int(11) DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventoryproduct`
--

INSERT INTO `inventoryproduct` (`id`, `ProductName`, `Quantity`, `UnitPrice`, `CategoryID (FK)`, `SupplierID (FK)`, `Status`) VALUES
(1, 'Cafe Latte', 19, 100.00, 2, 2, 'In Stock'),
(4, 'Matcha Latte', 20, 160.00, 2, 2, 'In Stock'),
(5, 'Crossiant', 11, 25.00, 4, 5, 'In Stock'),
(6, 'Spanish Latte', 10, 120.00, 2, 1, 'In Stock'),
(7, 'Cafe Americano', 20, 70.00, 2, 1, 'In Stock'),
(8, 'Cafe Mocha', 15, 120.00, 1, 2, 'In Stock'),
(9, 'Cafe Americano', 20, 125.00, 1, 1, 'In Stock'),
(15, 'Caramel Macchiato', 20, 100.00, 2, 2, 'In Stock'),
(23, 'Cafe Americano', 1, 11.00, 1, 1, 'In Stock'),
(24, 'zackkkk', 1, 1000.00, 1, 1, 'In Stock'),
(26, 'yuchi', 1, 1.00, 4, 2, 'Low Stock');

-- --------------------------------------------------------

--
-- Table structure for table `menu_items`
--

CREATE TABLE `menu_items` (
  `MenuItemID` int(11) NOT NULL,
  `MenuName` varchar(255) NOT NULL,
  `MenuPrice` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orderhistory`
--

CREATE TABLE `orderhistory` (
  `OrderHistoryID` int(11) NOT NULL,
  `OrderID` int(11) NOT NULL,
  `CustomerName` varchar(255) NOT NULL,
  `TableNumber` int(11) NOT NULL,
  `MenuItemID` int(11) NOT NULL,
  `OrderDate` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `OrderID` int(11) NOT NULL,
  `CustomerName` varchar(255) NOT NULL,
  `TableNumber` int(11) NOT NULL,
  `MenuItemID` int(11) NOT NULL,
  `OrderDate` datetime DEFAULT current_timestamp(),
  `TotalAmount` decimal(10,2) NOT NULL,
  `OrderStatus` enum('Pending','Completed','Cancelled') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

CREATE TABLE `order_details` (
  `OrderDetailID` int(11) NOT NULL,
  `OrderID` int(11) NOT NULL,
  `TotalAmount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `ReportID` int(11) NOT NULL,
  `ReportType` enum('Daily','Weekly','Monthly','Yearly') NOT NULL,
  `ReportName` varchar(255) NOT NULL,
  `ReportDate` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stocks`
--

CREATE TABLE `stocks` (
  `StockID` int(11) NOT NULL,
  `StockName` varchar(255) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `CostPrice` decimal(10,2) NOT NULL,
  `CategoryID` int(11) DEFAULT NULL,
  `SupplierID` int(11) DEFAULT NULL,
  `Status` enum('active','inactive') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL,
  `suppliername` varchar(100) NOT NULL,
  `contactinfo` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `suppliername`, `contactinfo`, `email`) VALUES
(1, 'Smith', '0123456789', 'jsmith@gmail.com'),
(2, 'Orent', '12345', 'qwert@gmail.com'),
(6, 'admin', '1234134', 'admin@admi');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`) VALUES
(1, 'admin', '$2b$12$jPOuklCv1iyyqG3BY8K3y.ekEbCfp6zDP600ogepIpFTZunMq85zS'),
(3, 'sms', '$2b$12$NFIy7oSeNCNsaYzQzjRz9usPab.jQFMEp1q2MgeOfepK7FAioGzga'),
(4, 'orent', '$2b$12$A0AfoUPSYCP.Je227Crr6uNyncWhG3N2RXyymfpMNGGzQkgkoP/2e'),
(5, 'ims', '$2b$12$AN7Ibuw.ln6qm4rLwN7dtuhX6nohThg44VXjIHnZTPxyTe6z8NaMK'),
(6, 'ADSA', '$2b$12$1bOjCzoyV3ronEgJhGd0m.X.9UuYEmJNgDIDU313h/V2PfBUdqMe2'),
(7, 'BEATAAA', '$2b$12$7FWLSnmn1JlDssc3xZzMhuP8kQUf4QYjWsToWqK.7HB5TmR5Pecxy'),
(8, 'HAHAHHA', '$2b$12$DFzCFIAaX0XUyn0enuDwVeKnaezxPZxKNPR5FQf22aInuS28GvTEC'),
(10, 'LASSTTTT', '$2b$12$Z3v1CHSPVozbQTP75HhSGeGy6IG63tUkSVyGaZSbBzqdbWzKHbZ9m');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `inventoryproduct`
--
ALTER TABLE `inventoryproduct`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`MenuItemID`);

--
-- Indexes for table `orderhistory`
--
ALTER TABLE `orderhistory`
  ADD PRIMARY KEY (`OrderHistoryID`),
  ADD KEY `OrderID` (`OrderID`),
  ADD KEY `MenuItemID` (`MenuItemID`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`OrderID`),
  ADD KEY `MenuItemID` (`MenuItemID`);

--
-- Indexes for table `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`OrderDetailID`),
  ADD KEY `OrderID` (`OrderID`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`ReportID`);

--
-- Indexes for table `stocks`
--
ALTER TABLE `stocks`
  ADD PRIMARY KEY (`StockID`),
  ADD KEY `CategoryID` (`CategoryID`),
  ADD KEY `SupplierID` (`SupplierID`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `inventoryproduct`
--
ALTER TABLE `inventoryproduct`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `MenuItemID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orderhistory`
--
ALTER TABLE `orderhistory`
  MODIFY `OrderHistoryID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_details`
--
ALTER TABLE `order_details`
  MODIFY `OrderDetailID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `ReportID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stocks`
--
ALTER TABLE `stocks`
  MODIFY `StockID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orderhistory`
--
ALTER TABLE `orderhistory`
  ADD CONSTRAINT `orderhistory_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`) ON DELETE CASCADE,
  ADD CONSTRAINT `orderhistory_ibfk_2` FOREIGN KEY (`MenuItemID`) REFERENCES `menu_items` (`MenuItemID`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`MenuItemID`) REFERENCES `menu_items` (`MenuItemID`) ON DELETE CASCADE;

--
-- Constraints for table `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`) ON DELETE CASCADE;

--
-- Constraints for table `stocks`
--
ALTER TABLE `stocks`
  ADD CONSTRAINT `stocks_ibfk_1` FOREIGN KEY (`CategoryID`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `stocks_ibfk_2` FOREIGN KEY (`SupplierID`) REFERENCES `suppliers` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
