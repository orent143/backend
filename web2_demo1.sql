-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 17, 2025 at 01:33 PM
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
  `Status` varchar(20) DEFAULT NULL,
  `StockID` int(11) DEFAULT NULL,
  `StockQuantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventoryproduct`
--

INSERT INTO `inventoryproduct` (`id`, `ProductName`, `Quantity`, `UnitPrice`, `CategoryID (FK)`, `SupplierID (FK)`, `Status`, `StockID`, `StockQuantity`) VALUES
(4, 'Matcha Latte', 15, 160.00, 2, 2, 'In Stock', NULL, NULL),
(5, 'Crossiant', 3, 25.00, 4, 5, 'In Stock', NULL, NULL),
(6, 'Spanish Latte', 5, 120.00, 2, 1, 'In Stock', NULL, NULL),
(7, 'Cafe Americano', 14, 70.00, 2, 1, 'In Stock', NULL, NULL),
(8, 'Cafe Mocha', 13, 120.00, 1, 2, 'In Stock', NULL, NULL),
(9, 'Cafe Americano', 20, 125.00, 1, 1, 'In Stock', NULL, NULL),
(15, 'Caramel Macchiato', 15, 100.00, 2, 2, 'In Stock', NULL, NULL),
(23, 'Cafe Americano', 9, 11.00, 1, 1, 'In Stock', NULL, NULL),
(24, 'zackkkk', 8, 1000.00, 1, 1, 'Low Stock', NULL, NULL),
(28, 'Vanilla Latte', 14, 120.00, 1, NULL, 'In Stock', NULL, NULL),
(29, 'Cafe Mocha', 6, 40.00, 1, NULL, 'Low Stock', NULL, NULL),
(30, 'TEST', 0, 120.00, 1, NULL, NULL, 1, NULL),
(40, 'Nescafe', 2, 40.00, 7, NULL, NULL, NULL, NULL),
(41, 'Kopiko', 11, 50.00, 7, NULL, 'In Stock', NULL, NULL),
(42, '3in1', 7, 20.00, 7, NULL, 'Low Stock', NULL, NULL),
(43, 'Wintermelon', 10, 80.00, 4, NULL, NULL, NULL, NULL);

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
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `OrderID` int(11) NOT NULL,
  `CustomerName` varchar(255) NOT NULL,
  `TableNumber` int(11) NOT NULL,
  `OrderDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `TotalAmount` decimal(10,2) NOT NULL,
  `OrderStatus` varchar(50) DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`OrderID`, `CustomerName`, `TableNumber`, `OrderDate`, `TotalAmount`, `OrderStatus`) VALUES
(1, 'HAHAHHAH', 1, '2025-02-17 11:03:34', 375.00, 'Completed'),
(2, 'Orent', 2, '2025-02-17 11:09:18', 375.00, 'Completed'),
(3, 'Lalalal', 3, '2025-02-17 11:15:58', 121.00, 'Completed'),
(4, 'HI', 4, '2025-02-17 11:20:13', 181.00, 'Completed'),
(5, 'abdc', 5, '2025-02-17 11:20:54', 80.00, 'Completed'),
(6, 'asasa', 6, '2025-02-17 11:21:20', 280.00, 'Completed'),
(7, 'grgrw', 7, '2025-02-17 11:21:39', 1131.00, 'Completed'),
(8, 'qwerty', 9, '2025-02-17 11:35:15', 335.00, 'Completed'),
(9, 'ZXCVBN', 10, '2025-02-17 11:44:46', 165.00, 'Completed'),
(10, 'Gi', 11, '2025-02-17 11:46:54', 302.00, 'Completed');

-- --------------------------------------------------------

--
-- Table structure for table `order_history`
--

CREATE TABLE `order_history` (
  `history_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `table_number` int(11) DEFAULT NULL,
  `order_date` datetime DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `order_status` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_history`
--

INSERT INTO `order_history` (`history_id`, `order_id`, `customer_name`, `table_number`, `order_date`, `total_amount`, `order_status`, `created_at`) VALUES
(1, 4, 'HI', 4, '2025-02-16 23:20:13', 181.00, 'Completed', '2025-02-17 11:20:19'),
(2, 5, 'abdc', 5, '2025-02-16 23:20:54', 80.00, 'Completed', '2025-02-17 11:21:03'),
(3, 7, 'grgrw', 7, '2025-02-16 23:21:39', 1131.00, 'Completed', '2025-02-17 11:21:54'),
(4, 6, 'asasa', 6, '2025-02-16 23:21:20', 280.00, 'Completed', '2025-02-17 11:21:55'),
(5, 8, 'qwerty', 9, '2025-02-16 23:35:15', 335.00, 'Completed', '2025-02-17 11:35:23'),
(6, 9, 'ZXCVBN', 10, '2025-02-16 23:44:46', 165.00, 'Completed', '2025-02-17 11:45:04'),
(7, 10, 'Gi', 11, '2025-02-16 23:46:54', 302.00, 'Completed', '2025-02-17 11:47:40');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `OrderItemID` int(11) NOT NULL,
  `OrderID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`OrderItemID`, `OrderID`, `ProductID`, `Quantity`) VALUES
(1, 2, 4, 1),
(2, 2, 5, 1),
(3, 3, 6, 2),
(4, 3, 5, 3),
(5, 4, 4, 1),
(6, 4, 7, 1),
(7, 4, 23, 1),
(8, 4, 15, 1),
(9, 1, 4, 1),
(10, 1, 5, 1),
(11, 1, 6, 1),
(12, 1, 7, 1),
(13, 2, 4, 1),
(14, 2, 5, 1),
(15, 2, 6, 1),
(16, 2, 7, 1),
(17, 3, 7, 1),
(18, 3, 23, 1),
(19, 3, 40, 1),
(20, 4, 7, 1),
(21, 4, 23, 1),
(22, 4, 15, 1),
(23, 5, 40, 1),
(24, 5, 29, 1),
(25, 6, 4, 1),
(26, 6, 8, 1),
(27, 7, 23, 1),
(28, 7, 28, 1),
(29, 7, 24, 1),
(30, 8, 6, 1),
(31, 8, 7, 1),
(32, 8, 5, 1),
(33, 8, 8, 1),
(34, 9, 40, 1),
(35, 9, 15, 1),
(36, 9, 5, 1),
(37, 10, 40, 2),
(38, 10, 15, 2),
(39, 10, 23, 2);

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
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity_sold` int(11) NOT NULL DEFAULT 0,
  `unit_price` decimal(10,2) NOT NULL,
  `total_revenue` decimal(10,2) GENERATED ALWAYS AS (`quantity_sold` * `unit_price`) STORED,
  `remitted` decimal(10,2) NOT NULL DEFAULT 0.00,
  `sale_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`id`, `product_id`, `product_name`, `quantity_sold`, `unit_price`, `remitted`, `sale_date`) VALUES
(1, 40, '', 1, 0.00, 40.00, '2025-02-17 11:44:46'),
(2, 15, '', 1, 0.00, 100.00, '2025-02-17 11:44:46'),
(3, 5, '', 1, 0.00, 25.00, '2025-02-17 11:44:46'),
(4, 40, '', 2, 0.00, 80.00, '2025-02-17 11:46:54'),
(5, 15, '', 2, 0.00, 200.00, '2025-02-17 11:46:54'),
(6, 23, '', 2, 0.00, 22.00, '2025-02-17 11:46:54');

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

--
-- Dumping data for table `stocks`
--

INSERT INTO `stocks` (`StockID`, `StockName`, `Quantity`, `CostPrice`, `CategoryID`, `SupplierID`, `Status`) VALUES
(1, 'Coffee Beans', 2, 50.00, NULL, 1, ''),
(2, 'Caramel Syrup', 0, 45.00, NULL, 2, ''),
(3, 'Sugar', 4, 20.00, NULL, 1, ''),
(4, 'Ice Cubes', 11, 15.00, NULL, 2, ''),
(5, 'Cup', 20, 30.00, NULL, 1, ''),
(6, 'Milk', 7, 80.00, NULL, 2, '');

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
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`OrderID`);

--
-- Indexes for table `order_history`
--
ALTER TABLE `order_history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`OrderItemID`),
  ADD KEY `OrderID` (`OrderID`),
  ADD KEY `ProductID` (`ProductID`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`ReportID`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `MenuItemID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `order_history`
--
ALTER TABLE `order_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `OrderItemID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `ReportID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `stocks`
--
ALTER TABLE `stocks`
  MODIFY `StockID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
-- Constraints for table `order_history`
--
ALTER TABLE `order_history`
  ADD CONSTRAINT `order_history_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`OrderID`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `inventoryproduct` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `inventoryproduct` (`id`) ON DELETE CASCADE;

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
