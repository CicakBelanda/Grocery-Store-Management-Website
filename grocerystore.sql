-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 03, 2025 at 06:21 PM
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
-- Database: `grocerystore`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddCustomer` (IN `p_CustomerID` CHAR(5), IN `p_CustomerName` VARCHAR(50), IN `p_CustomerAddress` VARCHAR(50), IN `p_CustomerAge` INT, IN `p_CustomerPhone` VARCHAR(20), IN `p_CustomerEmail` VARCHAR(50), IN `p_CustomerDOB` DATE, IN `p_CustomerGender` VARCHAR(20), IN `p_CustomerCity` VARCHAR(20))   BEGIN
    IF p_CustomerEmail NOT LIKE '%@gmail.com' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email harus berakhir dengan @gmail.com';
    END IF;

    INSERT INTO Customer (
        CustomerID, CustomerName, CustomerAddress, CustomerAge, 
        CustomerPhone, CustomerEmail, CustomerDOB, CustomerGender, CustomerCity
    )
    VALUES (
        p_CustomerID, p_CustomerName, p_CustomerAddress, p_CustomerAge, 
        p_CustomerPhone, p_CustomerEmail, p_CustomerDOB, p_CustomerGender, p_CustomerCity
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddEmployee` (IN `p_EmployeeID` CHAR(5), IN `p_EmployeeName` VARCHAR(50), IN `p_EmployeeAddress` VARCHAR(50), IN `p_EmployeeAge` INT, IN `p_EmployeePhone` VARCHAR(20), IN `p_EmployeeEmail` VARCHAR(50), IN `p_EmployeeGender` VARCHAR(20), IN `p_PositionID` CHAR(5), IN `p_EmploymentDate` DATE, IN `p_EmployeeCity` VARCHAR(20))   BEGIN
    IF p_EmployeeEmail NOT LIKE '%@gmail.com' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email harus berakhir dengan @gmail.com';
    END IF;

    INSERT INTO Employee (
        EmployeeID, EmployeeName, EmployeeAddress, EmployeeAge, 
        EmployeePhone, EmployeeEmail, EmployeeGender, PositionID, 
        EmploymentDate, EmployeeCity
    )
    VALUES (
        p_EmployeeID, p_EmployeeName, p_EmployeeAddress, p_EmployeeAge, 
        p_EmployeePhone, p_EmployeeEmail, p_EmployeeGender, p_PositionID, 
        p_EmploymentDate, p_EmployeeCity
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddNewProduct` (IN `p_ProductID` CHAR(5), IN `p_ProductName` VARCHAR(50), IN `p_CategoryID` CHAR(5), IN `p_Price` INT, IN `p_Stock` INT, IN `p_WarehouseID` CHAR(5))   BEGIN
    INSERT INTO Product (ProductID, ProductName, CategoryID, Price, Stock, WarehouseID)
    VALUES (p_ProductID, p_ProductName, p_CategoryID, p_Price, p_Stock, p_WarehouseID);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddTransaction` (IN `p_TransactionID` CHAR(5), IN `p_EmployeeID` CHAR(5), IN `p_CustomerID` CHAR(5), IN `p_TransactionDate` DATETIME)   BEGIN
    INSERT INTO TransactionHeader (TransactionID, EmployeeID, CustomerID, TransactionDate)
    VALUES (p_TransactionID, p_EmployeeID, p_CustomerID, p_TransactionDate);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddTransactionDetails` (IN `p_TransactionID` CHAR(5), IN `p_ProductID` CHAR(5), IN `p_Quantity` INT)   BEGIN
    DECLARE v_PricePerUnit INT;
    SELECT Price INTO v_PricePerUnit
    FROM Product
    WHERE ProductID = p_ProductID;
    INSERT INTO TransactionDetails (TransactionID, ProductID, Quantity, PricePerUnit)
    VALUES (p_TransactionID, p_ProductID, p_Quantity, v_PricePerUnit);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerTransactionHistory` (IN `p_CustomerID` CHAR(5))   BEGIN
    SELECT 
        th.TransactionID, 
        th.TransactionDate, 
        td.ProductID, 
        p.ProductName, 
        td.Quantity, 
        CONCAT('Rp. ', FORMAT(td.PricePerUnit, 0), ',-') AS 'Price per Unit',
        CONCAT('Rp. ', FORMAT((td.Quantity * td.PricePerUnit), 0), ',-') AS 'Total Price'
    FROM TransactionHeader th
    JOIN TransactionDetails td ON th.TransactionID = td.TransactionID
    JOIN Product p ON td.ProductID = p.ProductID
    WHERE th.CustomerID = p_CustomerID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetEmployeeDetailsByPosition` (IN `p_PositionID` CHAR(5))   BEGIN
    SELECT 
        e.EmployeeID, 
        e.EmployeeName, 
        e.EmployeeEmail, 
        e.EmployeePhone
    FROM Employee e
    WHERE e.PositionID = p_PositionID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateStock` (IN `p_ProductID` CHAR(5), IN `p_NewStock` INT)   BEGIN
    UPDATE Product 
    SET Stock = p_NewStock 
    WHERE ProductID = p_ProductID;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `CategoryID` char(5) NOT NULL,
  `CategoryName` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`CategoryID`, `CategoryName`) VALUES
('CT001', 'Minuman'),
('CT002', 'Makanan Ringan'),
('CT003', 'Sembako'),
('CT004', 'Produk Kebersihan'),
('CT005', 'Daging dan Unggas'),
('CT006', 'Seafood'),
('CT007', 'Buah-buahan'),
('CT008', 'Sayuran'),
('CT009', 'Produk Susu'),
('CT010', 'Roti dan Kue'),
('CT011', 'Makanan Beku'),
('CT012', 'Produk Kesehatan'),
('CT013', 'Makanan Bayi'),
('CT014', 'Snack Kesehatan');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `CustomerID` char(5) NOT NULL,
  `CustomerName` varchar(50) DEFAULT NULL,
  `CustomerAddress` varchar(50) DEFAULT NULL,
  `CustomerAge` int(11) DEFAULT NULL,
  `CustomerPhone` varchar(20) DEFAULT NULL,
  `CustomerEmail` varchar(50) DEFAULT NULL,
  `CustomerDOB` date DEFAULT NULL,
  `CustomerGender` varchar(20) DEFAULT NULL,
  `CustomerCity` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`CustomerID`, `CustomerName`, `CustomerAddress`, `CustomerAge`, `CustomerPhone`, `CustomerEmail`, `CustomerDOB`, `CustomerGender`, `CustomerCity`) VALUES
('CU001', 'Rina', 'Jl. Melati No. 3, Yogyakarta', 25, '081556677889', 'rina@gmail.com', '1998-06-15', 'Perempuan', 'Yogyakarta'),
('CU002', 'Ahmad', 'Jl. Mawar No. 10, Semarang', 40, '081667788990', 'ahmad@gmail.com', '1983-09-23', 'Laki-laki', 'Semarang'),
('CU003', 'Siti', 'Jl. Anggrek No. 5, Bandung', 30, '081234567890', 'siti@gmail.com', '1993-01-20', 'Perempuan', 'Bandung'),
('CU004', 'Budi', 'Jl. Kenanga No. 12, Surabaya', 35, '081345678901', 'budi@gmail.com', '1988-03-15', 'Laki-laki', 'Surabaya'),
('CU005', 'Aisyah', 'Jl. Dahlia No. 9, Medan', 28, '081456789012', 'aisyah@gmail.com', '1995-07-10', 'Perempuan', 'Medan'),
('CU006', 'Faisal', 'Jl. Merpati No. 8, Makassar', 42, '081567890123', 'faisal@gmail.com', '1981-11-25', 'Laki-laki', 'Makassar'),
('CU007', 'Dewi', 'Jl. Cemara No. 14, Bali', 26, '081678901234', 'dewi@gmail.com', '1997-04-05', 'Perempuan', 'Bali'),
('CU008', 'Joko', 'Jl. Melati No. 7, Jakarta', 50, '081789012345', 'joko@gmail.com', '1973-06-12', 'Laki-laki', 'Jakarta'),
('CU009', 'Rani', 'Jl. Flamboyan No. 3, Yogyakarta', 22, '081890123456', 'rani@gmail.com', '2001-08-19', 'Perempuan', 'Yogyakarta'),
('CU010', 'Andi', 'Jl. Angsana No. 11, Semarang', 38, '081901234567', 'andi@gmail.com', '1985-12-02', 'Laki-laki', 'Semarang'),
('CU011', 'Tio Edipurtta', 'Jl. Kediri No. 12, Malang', 20, '087888762187', 'edipurtta@gmail.com', '2005-02-03', 'Laki-laki', 'Malang');

-- --------------------------------------------------------

--
-- Stand-in structure for view `customertransactionhistoryview`
-- (See below for the actual view)
--
CREATE TABLE `customertransactionhistoryview` (
`CustomerID` char(5)
,`CustomerName` varchar(50)
,`TransactionID` char(5)
,`TransactionDate` datetime
,`ProductID` char(5)
,`ProductName` varchar(50)
,`Quantity` int(11)
,`Price per Unit` varchar(20)
,`Total Price` varchar(32)
);

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `EmployeeID` char(5) NOT NULL,
  `EmployeeName` varchar(50) DEFAULT NULL,
  `EmployeeAddress` varchar(50) DEFAULT NULL,
  `EmployeeAge` int(11) DEFAULT NULL,
  `EmployeePhone` varchar(20) DEFAULT NULL,
  `EmployeeEmail` varchar(50) DEFAULT NULL,
  `EmployeeGender` varchar(20) DEFAULT NULL,
  `PositionID` char(5) DEFAULT NULL,
  `EmploymentDate` date DEFAULT NULL,
  `EmployeeCity` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`EmployeeID`, `EmployeeName`, `EmployeeAddress`, `EmployeeAge`, `EmployeePhone`, `EmployeeEmail`, `EmployeeGender`, `PositionID`, `EmploymentDate`, `EmployeeCity`) VALUES
('EM001', 'Budi', 'Jl. Merdeka No. 5, Jakarta', 30, '081223344556', 'budi@gmail.com', 'Laki-laki', 'PS002', '2020-01-15', 'Jakarta'),
('EM002', 'Siti', 'Jl. Kebangsaan No. 7, Surabaya', 27, '081334455667', 'siti@gmail.com', 'Perempuan', 'PS002', '2021-03-20', 'Surabaya'),
('EM003', 'Andi', 'Jl. Pemuda No. 9, Bandung', 35, '081445566778', 'andi@gmail.com', 'Laki-laki', 'PS003', '2018-07-10', 'Bandung'),
('EM004', 'Dewi', 'Jl. Mawar No. 12, Yogyakarta', 28, '081556677889', 'dewi@gmail.com', 'Perempuan', 'PS003', '2019-05-01', 'Yogyakarta'),
('EM005', 'Rian', 'Jl. Cempaka No. 8, Medan', 32, '081677889900', 'rian@gmail.com', 'Laki-laki', 'PS004', '2020-09-15', 'Medan'),
('EM006', 'Lina', 'Jl. Anggrek No. 3, Bandung', 25, '081788990011', 'lina@gmail.com', 'Perempuan', 'PS001', '2021-11-20', 'Bandung'),
('EM007', 'Arif', 'Jl. Sakura No. 6, Malang', 29, '081899001122', 'arif@gmail.com', 'Laki-laki', 'PS002', '2019-03-10', 'Malang'),
('EM008', 'Nina', 'Jl. Melati No. 10, Surabaya', 26, '081900112233', 'nina@gmail.com', 'Perempuan', 'PS003', '2022-01-05', 'Surabaya'),
('EM009', 'Fajar', 'Jl. Kenanga No. 4, Jakarta', 34, '081122334455', 'fajar@gmail.com', 'Laki-laki', 'PS004', '2018-12-25', 'Jakarta'),
('EM010', 'Susi', 'Jl. Teratai No. 2, Bali', 31, '081233445566', 'susi@gmail.com', 'Perempuan', 'PS001', '2020-07-18', 'Bali'),
('EM011', 'Adi Bunga', 'Jl. Kursi No. 1, Palembang', 20, '081277234610', 'adibunga@gmail.com', 'Laki-laki', 'PS002', '2025-01-03', 'Palembang'),
('EM012', 'Wijaya', 'Jl. Makmur No. 2, Kediri', 28, '087654321567', 'wijaya@gmail.com', 'Laki-laki', 'PS002', '1996-08-14', 'Kediri');

-- --------------------------------------------------------

--
-- Stand-in structure for view `employeedetailsview`
-- (See below for the actual view)
--
CREATE TABLE `employeedetailsview` (
`EmployeeID` char(5)
,`EmployeeName` varchar(50)
,`EmployeeEmail` varchar(50)
,`EmployeePhone` varchar(20)
,`EmployeeCity` varchar(20)
,`PositionName` varchar(50)
,`Salary` varchar(20)
);

-- --------------------------------------------------------

--
-- Table structure for table `pos`
--

CREATE TABLE `pos` (
  `PositionID` char(5) NOT NULL,
  `PositionName` varchar(50) DEFAULT NULL,
  `Salary` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pos`
--

INSERT INTO `pos` (`PositionID`, `PositionName`, `Salary`) VALUES
('PS001', 'Office Boy', 2500000),
('PS002', 'Kasir', 3000000),
('PS003', 'Staff Gudang', 3500000),
('PS004', 'Manager', 7000000);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `ProductID` char(5) NOT NULL,
  `ProductName` varchar(50) DEFAULT NULL,
  `CategoryID` char(5) DEFAULT NULL,
  `Price` int(11) DEFAULT NULL,
  `Stock` int(11) DEFAULT NULL,
  `WarehouseID` char(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`ProductID`, `ProductName`, `CategoryID`, `Price`, `Stock`, `WarehouseID`) VALUES
('PR001', 'Air Mineral', 'CT001', 3000, 100, 'WH001'),
('PR002', 'Teh Botol', 'CT001', 5000, 50, 'WH001'),
('PR003', 'Keripik Singkong', 'CT002', 7000, 30, 'WH002'),
('PR004', 'Beras 5kg', 'CT003', 60000, 20, 'WH001'),
('PR005', 'Sabun Cuci Piring', 'CT004', 8000, 75, 'WH002'),
('PR006', 'Sabun Lifebuoy', 'CT004', 5000, 10, 'WH001'),
('PR007', 'Roti', 'CT002', 10000, 15, 'WH002'),
('PR008', 'Galon Air', 'CT001', 25000, 17, 'WH002'),
('PR009', 'Soda Can', 'CT001', 6000, 50, 'WH003'),
('PR010', 'Tepung Terigu 1kg', 'CT003', 12000, 20, 'WH006'),
('PR011', 'Keju Cheddar 200g', 'CT009', 25000, 20, 'WH004'),
('PR012', 'Keripik Kentang', 'CT002', 12000, 40, 'WH006'),
('PR013', 'Daging Sapi 1kg', 'CT005', 120000, 10, 'WH005'),
('PR014', 'Apel Fuji 1kg', 'CT007', 30000, 20, 'WH006'),
('PR015', 'Detergen Bubuk', 'CT004', 25000, 30, 'WH003'),
('PR016', 'Yogurt Cup', 'CT009', 10000, 50, 'WH003'),
('PR017', 'Telur Ayam 1kg', 'CT005', 25000, 30, 'WH007'),
('PR018', 'Brownies Coklat', 'CT010', 50000, 10, 'WH005'),
('PR019', 'Cumi 1kg', 'CT006', 75000, 12, 'WH005'),
('PR020', 'Jeruk Mandarin 1kg', 'CT007', 35000, 15, 'WH007'),
('PR021', 'Pasta Gigi', 'CT004', 10000, 60, 'WH007'),
('PR022', 'Wortel 1kg', 'CT008', 15000, 20, 'WH004'),
('PR023', 'Roti Tawar', 'CT010', 15000, 25, 'WH007'),
('PR024', 'Bayam 1kg', 'CT008', 10000, 40, 'WH006'),
('PR025', 'Ikan Salmon 1kg', 'CT006', 150000, 5, 'WH004'),
('PR026', 'Pisang Cavendish 1kg', 'CT007', 20000, 30, 'WH003'),
('PR027', 'Daging Ayam 1kg', 'CT005', 40000, 25, 'WH006'),
('PR028', 'Minyak Goreng 2L', 'CT003', 30000, 15, 'WH004'),
('PR029', 'Susu UHT 1L', 'CT009', 18000, 30, 'WH007'),
('PR030', 'Donat Kentang', 'CT010', 30000, 15, 'WH006'),
('PR031', 'Gula Pasir 1kg', 'CT003', 14000, 50, 'WH005'),
('PR032', 'Permen Mint', 'CT002', 5000, 60, 'WH003'),
('PR033', 'Udang 1kg', 'CT006', 85000, 10, 'WH003'),
('PR034', 'Sabun Cair', 'CT004', 15000, 40, 'WH004'),
('PR035', 'Kentang 1kg', 'CT008', 12000, 25, 'WH005'),
('PR036', 'Cokelat Batang', 'CT002', 15000, 25, 'WH007'),
('PR037', 'Jus Mangga', 'CT001', 10000, 30, 'WH004'),
('PR038', 'Keripik Singkong', 'CT002', 7000, 30, 'WH002'),
('PR039', 'Produk Baru', 'CT006', 12000, 100, 'WH004'),
('PR040', 'Bantal', 'CT012', 25000, 30, 'WH006');

-- --------------------------------------------------------

--
-- Stand-in structure for view `productdetailsview`
-- (See below for the actual view)
--
CREATE TABLE `productdetailsview` (
`ProductID` char(5)
,`ProductName` varchar(50)
,`CategoryName` varchar(50)
,`Price` varchar(20)
,`Stock` int(11)
,`WarehouseName` varchar(50)
,`WarehouseAddress` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `transactiondetails`
--

CREATE TABLE `transactiondetails` (
  `TransactionID` char(5) NOT NULL,
  `ProductID` char(5) NOT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `PricePerUnit` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactiondetails`
--

INSERT INTO `transactiondetails` (`TransactionID`, `ProductID`, `Quantity`, `PricePerUnit`) VALUES
('TR001', 'PR001', 2, 3000),
('TR001', 'PR003', 1, 7000),
('TR002', 'PR004', 1, 60000),
('TR002', 'PR005', 3, 8000),
('TR003', 'PR001', 10, 3000),
('TR003', 'PR002', 5, 5000),
('TR003', 'PR016', 3, 10000),
('TR004', 'PR007', 2, 10000),
('TR004', 'PR012', 1, 12000),
('TR004', 'PR014', 4, 30000),
('TR005', 'PR008', 1, 25000),
('TR005', 'PR011', 2, 25000),
('TR005', 'PR017', 5, 25000),
('TR006', 'PR005', 2, 8000),
('TR006', 'PR019', 3, 75000),
('TR006', 'PR025', 1, 150000),
('TR007', 'PR020', 4, 35000),
('TR007', 'PR022', 3, 15000),
('TR007', 'PR023', 6, 15000),
('TR008', 'PR004', 2, 60000),
('TR008', 'PR006', 1, 5000),
('TR008', 'PR009', 7, 6000),
('TR009', 'PR013', 2, 120000),
('TR009', 'PR018', 1, 50000),
('TR009', 'PR021', 3, 10000),
('TR010', 'PR010', 3, 12000),
('TR010', 'PR015', 1, 25000),
('TR010', 'PR017', 2, 25000),
('TR011', 'PR003', 5, 7000),
('TR011', 'PR022', 2, 15000),
('TR011', 'PR024', 4, 10000),
('TR012', 'PR002', 6, 5000),
('TR012', 'PR014', 2, 30000),
('TR012', 'PR025', 1, 150000),
('TR013', 'PR001', 3, 3000),
('TR013', 'PR004', 2, 60000),
('TR013', 'PR009', 7, 6000);

-- --------------------------------------------------------

--
-- Table structure for table `transactionheader`
--

CREATE TABLE `transactionheader` (
  `TransactionID` char(5) NOT NULL,
  `EmployeeID` char(5) DEFAULT NULL,
  `CustomerID` char(5) DEFAULT NULL,
  `TransactionDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactionheader`
--

INSERT INTO `transactionheader` (`TransactionID`, `EmployeeID`, `CustomerID`, `TransactionDate`) VALUES
('TR001', 'EM001', 'CU001', '2023-12-01 10:30:00'),
('TR002', 'EM002', 'CU002', '2023-12-03 14:45:00'),
('TR003', 'EM004', 'CU007', '2024-01-12 06:28:20'),
('TR004', 'EM002', 'CU003', '2024-02-15 12:35:29'),
('TR005', 'EM001', 'CU005', '2024-03-20 16:18:46'),
('TR006', 'EM005', 'CU002', '2024-04-05 09:39:22'),
('TR007', 'EM007', 'CU010', '2024-05-25 07:43:25'),
('TR008', 'EM003', 'CU001', '2024-06-10 11:34:42'),
('TR009', 'EM008', 'CU004', '2024-07-18 12:41:20'),
('TR010', 'EM006', 'CU006', '2024-08-22 18:15:14'),
('TR011', 'EM009', 'CU008', '2024-09-03 11:45:59'),
('TR012', 'EM010', 'CU009', '2024-10-11 06:36:28'),
('TR013', 'EM002', 'CU003', '2025-01-01 14:30:12');

-- --------------------------------------------------------

--
-- Stand-in structure for view `transactionsummaryview`
-- (See below for the actual view)
--
CREATE TABLE `transactionsummaryview` (
`TransactionID` char(5)
,`TransactionDate` datetime
,`CustomerName` varchar(50)
,`CustomerEmail` varchar(50)
,`EmployeeName` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `warehouse`
--

CREATE TABLE `warehouse` (
  `WarehouseID` char(5) NOT NULL,
  `WarehouseName` varchar(50) DEFAULT NULL,
  `WarehouseAddress` varchar(50) DEFAULT NULL,
  `WarehousePhone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `warehouse`
--

INSERT INTO `warehouse` (`WarehouseID`, `WarehouseName`, `WarehouseAddress`, `WarehousePhone`) VALUES
('WH001', 'Gudang Utama', 'Jl. Raya No. 1, Jakarta', '081234567890'),
('WH002', 'Gudang Cabang', 'Jl. Pemuda No. 10, Bandung', '081987654321'),
('WH003', 'Gudang Surabaya', 'Jl. Ahmad Yani No. 20, Surabaya', '081234512345'),
('WH004', 'Gudang Medan', 'Jl. Gatot Subroto No. 15, Medan', '081345678901'),
('WH005', 'Gudang Makassar', 'Jl. Pettarani No. 7, Makassar', '081567890123'),
('WH006', 'Gudang Semarang', 'Jl. Pahlawan No. 25, Semarang', '081789012345'),
('WH007', 'Gudang Bali', 'Jl. Sunset Road No. 10, Bali', '081901234567');

-- --------------------------------------------------------

--
-- Stand-in structure for view `warehousestockview`
-- (See below for the actual view)
--
CREATE TABLE `warehousestockview` (
`WarehouseID` char(5)
,`WarehouseName` varchar(50)
,`ProductName` varchar(50)
,`Stock` int(11)
);

-- --------------------------------------------------------

--
-- Structure for view `customertransactionhistoryview`
--
DROP TABLE IF EXISTS `customertransactionhistoryview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `customertransactionhistoryview`  AS SELECT `c`.`CustomerID` AS `CustomerID`, `c`.`CustomerName` AS `CustomerName`, `th`.`TransactionID` AS `TransactionID`, `th`.`TransactionDate` AS `TransactionDate`, `td`.`ProductID` AS `ProductID`, `p`.`ProductName` AS `ProductName`, `td`.`Quantity` AS `Quantity`, concat('Rp. ',format(`td`.`PricePerUnit`,0),',-') AS `Price per Unit`, concat('Rp. ',format(`td`.`Quantity` * `td`.`PricePerUnit`,0),',-') AS `Total Price` FROM (((`customer` `c` join `transactionheader` `th` on(`c`.`CustomerID` = `th`.`CustomerID`)) join `transactiondetails` `td` on(`th`.`TransactionID` = `td`.`TransactionID`)) join `product` `p` on(`td`.`ProductID` = `p`.`ProductID`)) ORDER BY `c`.`CustomerID` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `employeedetailsview`
--
DROP TABLE IF EXISTS `employeedetailsview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `employeedetailsview`  AS SELECT `e`.`EmployeeID` AS `EmployeeID`, `e`.`EmployeeName` AS `EmployeeName`, `e`.`EmployeeEmail` AS `EmployeeEmail`, `e`.`EmployeePhone` AS `EmployeePhone`, `e`.`EmployeeCity` AS `EmployeeCity`, `p`.`PositionName` AS `PositionName`, concat('Rp. ',format(`p`.`Salary`,0),',-') AS `Salary` FROM (`employee` `e` join `pos` `p` on(`e`.`PositionID` = `p`.`PositionID`)) ORDER BY `e`.`EmployeeID` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `productdetailsview`
--
DROP TABLE IF EXISTS `productdetailsview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `productdetailsview`  AS SELECT `p`.`ProductID` AS `ProductID`, `p`.`ProductName` AS `ProductName`, `c`.`CategoryName` AS `CategoryName`, concat('Rp. ',format(`p`.`Price`,0),',-') AS `Price`, `p`.`Stock` AS `Stock`, `w`.`WarehouseName` AS `WarehouseName`, `w`.`WarehouseAddress` AS `WarehouseAddress` FROM ((`product` `p` join `category` `c` on(`p`.`CategoryID` = `c`.`CategoryID`)) join `warehouse` `w` on(`p`.`WarehouseID` = `w`.`WarehouseID`)) ORDER BY `p`.`ProductID` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `transactionsummaryview`
--
DROP TABLE IF EXISTS `transactionsummaryview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `transactionsummaryview`  AS SELECT `th`.`TransactionID` AS `TransactionID`, `th`.`TransactionDate` AS `TransactionDate`, `c`.`CustomerName` AS `CustomerName`, `c`.`CustomerEmail` AS `CustomerEmail`, `e`.`EmployeeName` AS `EmployeeName` FROM ((`transactionheader` `th` join `customer` `c` on(`th`.`CustomerID` = `c`.`CustomerID`)) join `employee` `e` on(`th`.`EmployeeID` = `e`.`EmployeeID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `warehousestockview`
--
DROP TABLE IF EXISTS `warehousestockview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `warehousestockview`  AS SELECT `w`.`WarehouseID` AS `WarehouseID`, `w`.`WarehouseName` AS `WarehouseName`, `p`.`ProductName` AS `ProductName`, `p`.`Stock` AS `Stock` FROM (`product` `p` join `warehouse` `w` on(`p`.`WarehouseID` = `w`.`WarehouseID`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`CategoryID`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`CustomerID`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`EmployeeID`),
  ADD KEY `PositionID` (`PositionID`);

--
-- Indexes for table `pos`
--
ALTER TABLE `pos`
  ADD PRIMARY KEY (`PositionID`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`ProductID`),
  ADD KEY `CategoryID` (`CategoryID`),
  ADD KEY `WarehouseID` (`WarehouseID`);

--
-- Indexes for table `transactiondetails`
--
ALTER TABLE `transactiondetails`
  ADD PRIMARY KEY (`TransactionID`,`ProductID`),
  ADD KEY `TransactionID` (`TransactionID`),
  ADD KEY `ProductID` (`ProductID`);

--
-- Indexes for table `transactionheader`
--
ALTER TABLE `transactionheader`
  ADD PRIMARY KEY (`TransactionID`),
  ADD KEY `EmployeeID` (`EmployeeID`),
  ADD KEY `CustomerID` (`CustomerID`);

--
-- Indexes for table `warehouse`
--
ALTER TABLE `warehouse`
  ADD PRIMARY KEY (`WarehouseID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`PositionID`) REFERENCES `pos` (`PositionID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`CategoryID`) REFERENCES `category` (`CategoryID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `product_ibfk_2` FOREIGN KEY (`WarehouseID`) REFERENCES `warehouse` (`WarehouseID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transactiondetails`
--
ALTER TABLE `transactiondetails`
  ADD CONSTRAINT `transactiondetails_ibfk_1` FOREIGN KEY (`TransactionID`) REFERENCES `transactionheader` (`TransactionID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transactiondetails_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transactionheader`
--
ALTER TABLE `transactionheader`
  ADD CONSTRAINT `transactionheader_ibfk_1` FOREIGN KEY (`EmployeeID`) REFERENCES `employee` (`EmployeeID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transactionheader_ibfk_2` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
