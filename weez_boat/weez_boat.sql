INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('society_boat', 'Concess Bateau', 1);

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('society_boat', 'Concess Bateau', 1);

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('boat', 'Concess Bateau', 1);

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('boat', 0, 'novice', 'Novice', 100, '', ''),
('boat', 1, 'experimente', 'Experimenté', 100, '', ''),
('boat', 2, 'boss', 'Patron', 100, '', '');

CREATE TABLE IF NOT EXISTS `boat` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `boat` (`name`, `model`, `price`, `category`) VALUES
('Dinghy 4Seat', 'dinghy', 150000, 'boat'),
('Dinghy 2Seat', 'dinghy2', 170000, 'boat'),
('Dinghy Yacht', 'dinghy4', 200000, 'boat'),
('Jetmax', 'jetmax', 120000, 'boat'),
('Marquis', 'marquis', 95000, 'boat'),
('Seashark', 'seashark', 50000, 'boat'),
('Seashark Yacht', 'seashark3', 75000, 'boat'),
('Speeder', 'speeder', 150000, 'boat'),
('Squalo', 'squalo', 80000, 'boat'),
('Submarine', 'submersible', 250000, 'subs'),
('Kraken', 'submersible2', 350000, 'subs'),
('Suntrap', 'suntrap', 80000, 'boat'),
('Toro', 'toro', 145000, 'boat'),
('Toro Yacht', 'toro2', 150000, 'boat'),
('Tropic', 'tropic', 125000, 'boat'),
('Tropic Yacht', 'tropic2', 140000, 'boat');


CREATE TABLE IF NOT EXISTS `boat_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `boat_categories` (`name`, `label`) VALUES
('boat', 'Bateaux'),
('subs', 'Sous-Marins');

CREATE TABLE IF NOT EXISTS `owned_vehicles` (
	`owner` varchar(40) NOT NULL,
	`plate` varchar(12) NOT NULL,
	`vehicle` longtext,
	`type` VARCHAR(20) NOT NULL DEFAULT 'car',
	`job` VARCHAR(20) NULL DEFAULT NULL,
	`stored` TINYINT(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`plate`)
);

ALTER TABLE `boat`
  ADD PRIMARY KEY (`model`);

ALTER TABLE `boat_categories`
  ADD PRIMARY KEY (`name`);
