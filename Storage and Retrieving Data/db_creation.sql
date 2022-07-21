-- -----------------------------------------------------
-- ONLINE BOOKSTORE
--
-- READ ME
--
-- GROUP 03
-- Ana Luís - 20210671
-- Carolina Machado - 20210676
-- Francisco Calha - 20210673
-- Luís Santos - 20210694
-- Sara Arana - 20210672
--
-- Table creation starts at line 48
-- Triggers creation starts at line 332
-- Data insertion starts at line 428
-- Views creation starts at line 1380
--
-- We strongly advise running this scrip WITHOUT safe update mode turned on,
-- to disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect,
-- or use SET SQL_SAFE_UPDATES = 0;
-- -----------------------------------------------------
SET SQL_SAFE_UPDATES = 0;

-- DROP DATABASE `srd`;

CREATE SCHEMA IF NOT EXISTS `srd` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `srd` ;

DROP VIEW IF EXISTS `srd`.`invoice1`;
DROP VIEW IF EXISTS `srd`.`invoice2`;
-- SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `srd`.`has`;
DROP TABLE IF EXISTS `srd`.`writes`;
DROP TABLE IF EXISTS `srd`.`supplies`;
DROP TABLE IF EXISTS `srd`.`supplier`;
DROP TABLE IF EXISTS `srd`.`publishes`;
DROP TABLE IF EXISTS `srd`.`publisher`;
DROP TABLE IF EXISTS `srd`.`order_itens`;
DROP TABLE IF EXISTS `srd`.`orders`;
DROP TABLE IF EXISTS `srd`.`log`;
DROP TABLE IF EXISTS `srd`.`commentary`;
DROP TABLE IF EXISTS `srd`.`client`;
DROP TABLE IF EXISTS `srd`.`location`;
DROP TABLE IF EXISTS `srd`.`category`;
DROP TABLE IF EXISTS `srd`.`book`;
DROP TABLE IF EXISTS `srd`.`author`;



-- -----------------------------------------------------
-- Table `srd`.`author`
-- -----------------------------------------------------

CREATE TABLE `srd`.`author` (
  `author_id` INT NOT NULL,
  `author_name` VARCHAR(64) NOT NULL,
  `nationality` VARCHAR(30) NULL DEFAULT NULL,
  `date_birth` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`author_id`));


-- -----------------------------------------------------
-- Table `srd`.`book`
-- -----------------------------------------------------
CREATE TABLE `srd`.`book` (
  `ISBN` INT NOT NULL,
  `title` VARCHAR(150) NOT NULL,
  `book_resume` MEDIUMTEXT NULL DEFAULT NULL,
  `date_publishment` DATETIME NULL DEFAULT NULL,
  `stock` INT UNSIGNED NULL DEFAULT 0,
  `book_language` VARCHAR(20) NULL DEFAULT NULL,
  `price` DECIMAL(10,2) NULL DEFAULT NULL,
  `discount` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`ISBN`));


-- -----------------------------------------------------
-- Table `srd`.`category`
-- -----------------------------------------------------
CREATE TABLE `srd`.`category` (
  `category_id` INT NOT NULL,
  `category_name` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`category_id`));


-- -----------------------------------------------------
-- Table `srd`.`location`
-- -----------------------------------------------------
CREATE TABLE `srd`.`location` (
  `zipcode` VARCHAR(30) NOT NULL,
  `country` VARCHAR(30) NOT NULL,
  `city` VARCHAR(30) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`zipcode`));


-- -----------------------------------------------------
-- Table `srd`.`client`
-- -----------------------------------------------------
CREATE TABLE `srd`.`client` (
  `account_id` INT NOT NULL,
  `client_name` VARCHAR(64) NOT NULL,
  `date_birth` DATETIME NOT NULL,
  `VAT` INT NULL DEFAULT NULL,
  `email` VARCHAR(128) NOT NULL,
  `phone_number` VARCHAR(45) NOT NULL,
  `premium` ENUM('Extra-Premium', 'Normal-Premium', 'Default') NOT NULL,
  `extra_discount` DECIMAL(3,3) NULL DEFAULT NULL,
  `zipcode` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`account_id`, `zipcode`),
  INDEX `fk_client_from1_idx` (`zipcode` ASC) VISIBLE,
  CONSTRAINT `fk_client_from1`
    FOREIGN KEY (`zipcode`)
    REFERENCES `srd`.`location` (`zipcode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `srd`.`comentary`
-- -----------------------------------------------------
CREATE TABLE `srd`.`commentary` (
  `rating` ENUM('1', '2', '3', '4', '5') NOT NULL,
  `commentary_description` VARCHAR(64) NULL DEFAULT NULL,
  `account_id` INT NOT NULL,
  `book_ISBN` INT NOT NULL,
  PRIMARY KEY (`account_id`, `book_ISBN`),
  INDEX `fk_commentary_client1_idx` (`account_id` ASC) VISIBLE,
  INDEX `fk_commentary_book1_idx` (`book_ISBN` ASC) VISIBLE,
  CONSTRAINT `fk_commentary_book1`
    FOREIGN KEY (`book_ISBN`)
    REFERENCES `srd`.`book` (`ISBN`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_commentary_client1`
    FOREIGN KEY (`account_id`)
    REFERENCES `srd`.`client` (`account_id`));


-- -----------------------------------------------------
-- Table `srd`.`log`
-- -----------------------------------------------------
CREATE TABLE `srd`.`log` (
  `logID` INT NOT NULL AUTO_INCREMENT,
  `TS` DATETIME NULL DEFAULT NULL,
  `USR` VARCHAR(128) NULL DEFAULT NULL,
  `EV` VARCHAR(128) NULL DEFAULT NULL,
  `MSG` VARCHAR(250) NULL DEFAULT NULL,
  PRIMARY KEY (`logID`))
AUTO_INCREMENT = 13;


-- -----------------------------------------------------
-- Table `srd`.`orders`
-- -----------------------------------------------------
CREATE TABLE `srd`.`orders` (
  `order_id` INT NOT NULL,
  `date_order` DATETIME NOT NULL,
  `date_shipment` DATETIME NOT NULL,
  `estimate_arrival` DATETIME NULL DEFAULT NULL,
  `account_id` INT NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `fk_orders_client2_idx` (`account_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_client2`
    FOREIGN KEY (`account_id`)
    REFERENCES `srd`.`client` (`account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `srd`.`order_itens`
-- -----------------------------------------------------
CREATE TABLE `srd`.`order_itens` (
  `ISBN` INT NOT NULL,
  `quantity` INT NOT NULL,
  `order_id` INT NOT NULL,
  PRIMARY KEY (`ISBN`, `order_id`),
  INDEX `fk_order_itens_book1_idx` (`ISBN` ASC) VISIBLE,
  INDEX `fk_order_itens_orders1_idx` (`order_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_itens_book1`
    FOREIGN KEY (`ISBN`)
    REFERENCES `srd`.`book` (`ISBN`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_itens_orders1`
    FOREIGN KEY (`order_id`)
    REFERENCES `srd`.`orders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table `srd`.`publisher`
-- -----------------------------------------------------
CREATE TABLE `srd`.`publisher` (
  `VAT` INT NOT NULL,
  `company_name` VARCHAR(64) NOT NULL,
  `email` VARCHAR(128) NULL DEFAULT NULL,
  `phone_number` VARCHAR(128) NULL DEFAULT NULL,
  PRIMARY KEY (`VAT`));


-- -----------------------------------------------------
-- Table `srd`.`publishes`
-- -----------------------------------------------------
CREATE TABLE `srd`.`publishes` (
  `publisher_VAT` INT NOT NULL,
  `book_ISBN` INT NOT NULL,
  PRIMARY KEY (`publisher_VAT`, `book_ISBN`),
  INDEX `fk_publisher_has_book_book1_idx` (`book_ISBN` ASC) VISIBLE,
  INDEX `fk_publisher_has_book_publisher1_idx` (`publisher_VAT` ASC) VISIBLE,
  CONSTRAINT `fk_publisher_has_book_book1`
    FOREIGN KEY (`book_ISBN`)
    REFERENCES `srd`.`book` (`ISBN`),
  CONSTRAINT `fk_publisher_has_book_publisher1`
    FOREIGN KEY (`publisher_VAT`)
    REFERENCES `srd`.`publisher` (`VAT`));


-- -----------------------------------------------------
-- Table `srd`.`supplier`
-- -----------------------------------------------------
CREATE TABLE `srd`.`supplier` (
  `VAT` INT NOT NULL,
  `company_name` VARCHAR(64) NOT NULL,
  `email` VARCHAR(128) NULL DEFAULT NULL,
  `phone_number` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`VAT`));


-- -----------------------------------------------------
-- Table `srd`.`supplies`
-- -----------------------------------------------------
CREATE TABLE `srd`.`supplies` (
  `supplier_VAT` INT NOT NULL,
  `book_ISBN` INT NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`supplier_VAT`, `book_ISBN`),
  INDEX `fk_supplier_has_book_book1_idx` (`book_ISBN` ASC) VISIBLE,
  INDEX `fk_supplier_has_book_supplier1_idx` (`supplier_VAT` ASC) VISIBLE,
  CONSTRAINT `fk_supplier_has_book_book1`
    FOREIGN KEY (`book_ISBN`)
    REFERENCES `srd`.`book` (`ISBN`),
  CONSTRAINT `fk_supplier_has_book_supplier1`
    FOREIGN KEY (`supplier_VAT`)
    REFERENCES `srd`.`supplier` (`VAT`));

-- -----------------------------------------------------
-- Table `srd`.`writes`
-- -----------------------------------------------------
CREATE TABLE `srd`.`writes` (
  `book_ISBN` INT NOT NULL,
  `author_id` INT NOT NULL,
  PRIMARY KEY (`book_ISBN`, `author_id`),
  INDEX `fk_book_has_author_author1_idx` (`author_id` ASC) VISIBLE,
  INDEX `fk_book_has_author_book1_idx` (`book_ISBN` ASC) VISIBLE,
  CONSTRAINT `fk_book_has_author_author1`
    FOREIGN KEY (`author_id`)
    REFERENCES `srd`.`author` (`author_id`),
  CONSTRAINT `fk_book_has_author_book1`
    FOREIGN KEY (`book_ISBN`)
    REFERENCES `srd`.`book` (`ISBN`));

-- -----------------------------------------------------
-- Table `srd`.`has`
-- -----------------------------------------------------

CREATE TABLE `srd`.`has` (
  `book_ISBN` INT NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`book_ISBN`, `category_id`),
  INDEX `fk_book_has_category_category1_idx` (`category_id` ASC) VISIBLE,
  INDEX `fk_book_has_category_book1_idx` (`book_ISBN` ASC) VISIBLE,
  CONSTRAINT `fk_book_has_category_book1`
    FOREIGN KEY (`book_ISBN`)
    REFERENCES `srd`.`book` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_has_category_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `srd`.`category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Triggers
-- -----------------------------------------------------

-- If a client is Extra-Premium, he will receive an extra discount of 7 per cent in each book he buys!!!
-- However, if he is only Normal-Premium, he will receive an extra discount of 5 per cent in each book he buys!!!
-- About the clients who are not premium obviously they have no extra discount applied to their books.
-- Note that, this extra discount is not the same of the discount in book's table. That one is a normal discount
-- wich everyone have access to it (only if the book is in sales) while this extra discount is private only for 
-- the premium clients. 
 
DELIMITER $$
CREATE TRIGGER `srd`.`extra_discount_update_after_client`
BEFORE INSERT ON `srd`.`client`
FOR EACH ROW
BEGIN
IF new.premium LIKE 'Extra-Premium' THEN
    SET NEW.extra_discount = 0.07;
ELSEIF new.premium LIKE 'Normal-Premium' THEN
    SET NEW.extra_discount = 0.05;
ELSE
    SET NEW.extra_discount = 0;
END IF; 
END$$


-- After each supply we need to update the stock of each book supplied!

CREATE TRIGGER `srd`.`stock_update_after_supplier`
AFTER INSERT 
ON `srd`.`supplies`
FOR EACH ROW
BEGIN
    UPDATE `srd`.`book`
    SET stock = stock + new.quantity
    WHERE ISBN = new.book_ISBN;
END$$


-- After each order we need to update the stock of each book bought!

CREATE TRIGGER `srd`.`stock_update_after_order`
AFTER INSERT 
ON `srd`.`order_itens`
FOR EACH ROW
BEGIN
    UPDATE `srd`.`book`
    SET stock = stock - new.quantity
    WHERE ISBN = new.ISBN;
END$$


-- Triggers Log table

CREATE TRIGGER `srd`.`client_log_insert`
AFTER INSERT ON `srd`.`client`
FOR EACH ROW
BEGIN
INSERT INTO log(TS, USR, EV, MSG) VALUES
(NOW(), USER(), "NEW CLIENT ADDED", new.client_name);
END$$

CREATE TRIGGER `srd`.`premium_status_log_update`
AFTER UPDATE ON `srd`.`client`
FOR EACH ROW
BEGIN
IF new.premium != old.premium THEN
	IF new.premium = 'Normal-Premium' THEN
		INSERT INTO log(TS, USR, EV, MSG) VALUES
		(NOW(), USER(), "CLIENT UPGRADED TO NORMAL-PREMIUM", new.client_name);
	ELSEIF new.premium = 'Extra-Premium' THEN
		INSERT INTO log(TS, USR, EV, MSG) VALUES
		(NOW(), USER(), "CLIENT UPGRADED TO EXTRA-PREMIUM", new.client_name);
	ELSE
		INSERT INTO log(TS, USR, EV, MSG) VALUES
		(NOW(), USER(), "CLIENT DOWNGRADED FROM PREMIUM", new.client_name);
	END IF;
ELSE
	INSERT INTO log(TS, USR, EV, MSG) VALUE
	(NOW(), USER(), "CLIENT UPDATED", new.client_name);
END IF;
END$$


CREATE TRIGGER `srd`.`client_log_delete`
AFTER DELETE ON `srd`.`client`
FOR EACH ROW
BEGIN
INSERT INTO log(TS, USR, EV, MSG) VALUE
(NOW(), USER(), "CLIENT REMOVED", old.client_name);
END$$


DELIMITER ;


-- -----------------------------------------------------
-- Inserts
-- -----------------------------------------------------

INSERT INTO `publisher` (`VAT`, `company_name`, `email`, `phone_number`) VALUES
(131824190, 'Scholastic', 'TradeCustomerService@Scholastic.com', '646-330-5288'),
(204214153, 'Bloomsbury Publishing', 'contact@bloomsbury.com', '910-401-4957'),
(462905685, 'Penguin Books', 'customersupport@penguinrandomhouse.co.uk', '800-733-3000'),
(202572391, 'HarperCollins Publishers', 'orders@harpercollins.com', '800-242-7737'),
(113764438, 'Alfred A. Knopf', 'toknopfwebmaster@randomhouse.com', '212-782-9000'),
(133922175, 'Hachette Book Group', 'customerservice@hachette-service.com', '800-759-0190'),
(131174569, 'Simon & Schuster', 'ScribnerPublicity@simonandschuster.com', '866-506-1949'),
(593788600, 'Macmillan Publishers', 'academic@macmillan.com', '808-239-9397'),
(239814525, 'Orion Books', 'o_books@hotmail.com', '808-250-9134'),
(131467512, 'Arbor House', 'arbor_houset@bgmail.com', '800-402-4325'),
(279189158, 'Greenery Press', 'greenery_press@hotmail.com', '808-270-1234'),
(472591395, 'Harlequin', 'harlequin_company@gmail.com', '202-555-4752'),
(450578874, 'Lee & Low Books', 'l&lbooks@hotmail.com', '320-123-4518'),
(368949668, 'Orchard Books', 'orchard_b@gmail.com', '910-200-6352'),
(569235717, 'Ruby Publishing', 'ruby_publsh@gmail.com', '808-274-9147'),
(481860125, 'Sanoma', 'sanoma@bloomsbury.com', '212-852-9513'),
(139209910, 'Simon & Schuster Inc', 'simon_shuster_inc@hotmail.com', '212-287-4568'),
(892422336, 'The Open Book Press', 'open_book_press@hotmail.com', '910-312-7412'),
(511008736, 'The Publish Hut', 'publish_hut@gmail.com', '212-852-2587'),
(521023736, 'Norma Editor', 'norma_official@gmail.com', '222-851-2367'),
(325271324, 'Windy City Publishing', 'windy_city_pub@gmail.com', '320-741-8956'),
(773425698, 'ABAX', 'sales@abax.co.jp', '044-813-2909 '),
(954084929, 'Cideb Black Cat', 'info@cidebblackcat.com', ' 39 0185 1874300'),
(729416184, 'Burlington Books', 'editorial@burlingtonbooks.com', '91 628 24 58'),
(794676222, 'Cambridge University Press', 'information@cambridge.org', '44 (0)1223 358331 '),
(385763031, 'Cengage', ' asia.info@cengage.com', '82-2-3698-90'),
(663570830, 'Compass Publishing', 'info@compasspub.com', '82-2-3471-96'),
(437503609, 'Delta Publishing', 'info@deltapublishing.com', '44 (0) 1306 731770'),
(815630395, 'Egmont UK', 'info@egmont.co.uk', '8445768113'),
(539584147, 'Express Publishing (UK)', 'inquiries@expresspublishing.co.uk', ' (0044) 1635 817 363'),
(336962799, 'Falcon Press', 'info@summertown.co.uk', '603-7781 2303'),
(225449756, 'Helbling Languages', 'info@richmondelt.com', '071.7108258'),
(758417221, 'Macmillan', 'info@ricpublishers.com', '44 (0)1865 405700'),
(544564384, 'Oxford University Press', 'info@summertown.co.uk', '1865353567'),
(312653044, 'Richmond ELT', 'info@richmondelt.com', '5699255222'),
(979446079, 'R.I.C. Publishers', 'info@ricpublishers.com', ' 61 8 9240 9888'),
(353613732, 'Summertown Publishing', 'info@summertown.co.uk', '44 (0) 1264342799'),
(443796965, 'Viking Press', 'info@vikingpress.com', '222-456-2526'),
(963025429, 'Voyager Books', 'info@voyagerbooks.com', '204-666-225'),
(465526926, 'Wiley', 'info@wiley.com', '300-456-253'),
(253325600, 'Windy City Publishing', 'info@windycitypublishing.com', '452-666-226'),
(972820206, 'Wisdom Publications', 'info@wisdompublications.com', '639-456-254'),
(373797153, 'Workman Publishing', 'info@workmanpublishing.com', '445-666-227'),
(219169462, 'Zed Books', 'info@zedbooks.com', '8963-456-255'),
(436855866, 'Morgan James Publishing', 'info@morganjamespublishing.com', ' 61 8 9240 9889'),
(425085797, 'Mother Tongue Publishing', 'info@mothertonguepublishing.com', '44 (0) 1264342799'),
(413315729, 'New Beacon Books', 'info@newbeaconbooks.com', '222-456-3327'),
(401545660, 'New Directions Publishing Corporation', 'info@newdirectionspublishingcorporation.com', '204-666-226'),
(389775592, 'No Starch Press', 'info@nostarchpress.com', '303-456-254'),
(378005523, 'Orchard Books', 'info@orchardbooks.com', '254-666-227');


INSERT INTO `supplier` (`VAT`, `company_name`, `email`, `phone_number`) VALUES
(208332175, 'American West Books', 'MRutherford@AmericanWestBooks.com', '559-876-2170'),
(841970825, 'Bella Distribution', 'Orders@BellaDist.com', '800-702-4992'),
(599215354, 'The Local Supply Depot', 'local_depot@gmail.com', '212-456-8795'),
(230279357, 'Oxbow Books', 'oxbow_books@gmail.com', '320-852-1475'),
(185390566, 'Send the Light', 'send_light@hotmail.com', '704-471-256'),
(208262155, 'Small Press Distribution', 'small_press_dist@gmail.com', '559-524-6354'),
(629103205, 'TAN Books', 'T.A.N_books@gmail.com', '800-702-4992'),
(271746484, 'Fitzhenry & Whiteside', 'fitz_white@btol.com', '320-485-1235'),
(655113568, 'Manda Group', 'manda_group@hotmail.com', '800-582-8526'),
(581950919, 'Raincoast Books', 'raincoast@gmail.com', '320-458-7415'),
(204582175, 'Sandhill Books', 'sandhill@hotmail.com', '559-814-2745'),
(342053585, 'Thomas Allen & Son', 'tomas_son@gmail.com', '800-502-1258'),
(553064730, 'Casemate', 'casemate@sapo.pt', '315-458-8526'),
(208332176, 'Ingram Content Group', 'ingram_group@gmail.com', '559-412-5698'),
(451202745, 'Last Gasp', 'last_gasp@hotmail.com', '800-741-7852'),
(119235900, 'Midpoint Trade Books', 'midpoint@gmail.com', '785-741-4562'),
(207856875, 'Perseus Books Group', 'perseus_b_g@gmail.com', '559-887-8526'),
(199022019, 'Rowman & Littlefield', 'rowman&litfold@hotmail.com', '808-741-4569'),
(818393168, 'Follett Corporation', 'folllet@gmail.com', '704-741-2584'),
(473179974, 'Baker & Taylor', 'btinfo@btol.com', '704-998-3190'),
('767292237', 'Dropshipper.com', 'dropshipper.com@gmail.com', '175-857-6488'),
('765312339', 'Alibaba', 'alibaba@gmail.com', '138-9683-789'),
('218350281', 'Oberlo', 'oberlo@gmail.com', '668-508-191'),
('547653776', 'Dropship Direct', 'dropshipdirect@gmail.com', '217-526-772'),
('516561620', 'Sunrise Wholesale', 'sunrisewholesale@gmail.com', '994-903-8161'),
('456536393', 'eBay Business Supply', 'ebaybusinesssupply@gmail.com', '327-649-8566'),
('827277285', 'Doba', 'doba@gmail.com', '847-678-5556'),
('332622483', 'SaleHoo', 'salehoo@gmail.com', '801-426-2886'),
('113169013', 'Wholesale 2B', 'wholesale 2b@gmail.com', '600-228-3867'),
('855445482', 'AliExpress', 'aliexpress@gmail.com', '925-587-4995'),
('880922897', 'Printify', 'printify@gmail.com', '775-093-7194'),
('937621245', 'Redbubble', 'redbubble@hotmail.com', '402-047-4977'),
('926587991', 'Worldwide Brands', 'worldwidebrands@hotmail.com', '332-246-5603'),
('966126398', 'National Dropshippers', 'nationaldropshippers@gmail.com', '249-97-17326'),
('761984538', 'Wholesale Central', 'wholesalecentral@gmail.com', '66-930-76408'),
('757647427', 'The Thomas Network', 'thethomasnetwork@gmail.com', '75-328-4395'),
('638489223', 'National Supplier', 'nationalsupp@yahoo.com', '4788-156-671'),
('770087958', 'Megagoods', 'megagoods@gmail.com', '848-756-4711'),
('863533815', 'Investory Source', 'investory source@outlook.com', '625-216-5173'),
('698812881', 'Maker’s Row', 'maker’s row@sapo.pt', '148-0300-608'),
('970767278', 'ChinaBrands', 'chinabrands@sapo.pt', '181-041-7230'),
('367929899', 'Made-In-China', 'made-in-china@outlook.com', '543-7087-131'),
('907705512', 'Modalyst', 'modalyst@yahoo.com', '5988-272-240'),
('52257210', 'Spocket', 'spocket@yahoo.com', '561-728-4486'),
('982329149', 'Dropified', 'dropified@gmail.com', '749-9246-045'),
('417973978', 'DHGate', 'dhgate@gmail.com', '266-850-4600'),
('762033455', 'Kole Imports', 'kole imports@gmail.com', '509-285-1952'),
('835473831', 'Yakkyofy', 'yakkyofy@gmail.com', '896-343-299'),
('912682306', 'Uniqbe Limited', 'uniqbelimited@gmail.com', '557-3885-529'),
('853471934', 'ASI Partners', 'asipartners@gmail.com', '347-5730-132');


INSERT INTO `book` (`ISBN`,`title`, `book_resume`, `date_publishment`, `book_language`, `price`, `discount`) VALUES
(0141032009, 'The Diary of a Young Girl', 'The Diary of a Young Girl, also known as The Diary of Anne Frank, 
is a book of the writings from the Dutch-language diary kept by Anne Frank while she was in hiding for two years with her family during the Nazi occupation of the Netherlands.', 
'1947-06-25', 'English', 10.80, 0.2),
(0499106354, 'Lolita', 'The novel is notable for its controversial subject: the protagonist and unreliable narrator, 
a French middle-aged literature professor under the pseudonym Humbert Humbert, is obsessed with an American 12-year-old girl, Dolores Haze', 
'1955-09-15', 'English', 5.99, 0.0),
(0420635491, 'The Gambler', 'The Gambler is a short novel by Fyodor Dostoevsky about a young tutor in the employment of a formerly wealthy Russian general.', 
'1866-06-15', 'English', 7.99, 0.0),
(0141183411, 'To the Lighthouse', 'The novel centres on the Ramsay family and their visits to the Isle of Skye in Scotland between 1910 and 1920.', 
'1927-05-05', 'English', 8.99, 0.2),
(0781405072, 'Dracula', 'An epistolary novel, the narrative is related through letters, diary entries, and newspaper articles.', 
'1897-05-26', 'English', 7.50, 0.0),
(0780439420, 'Harry Potter and the Chamber of Secrets', 'A mysterious elf tells Harry to expect trouble during his second year at Hogwarts, but nothing can 
prepare him for trees that fight back, flying cars, spiders that talk and deadly warnings written in blood on the walls of the school.', 
'1998-07-02', 'English', 8.90, 0.0),
(0780316066, 'Infinite Jest', 'The novel largely eschews plot and focuses on the emotional and philosophical valence of scenes both remarkable and quotidian', 
'1996-02-01', 'English', 13.50, 0.1),
(0780192823, 'Crime and Punishment', 'Raskolnikov, an impoverished student, conceives of himself as being an extraordinary young man and then 
formulates a theory whereby the extraordinary men of the world have a right to commit any crime if they have something of worth to offer humanity.', 
'1866-01-01', 'English', 5.99, 0.0),
(0788467503, 'Flowers for Algernon', 'Flowers for Algernon is the title of a science fiction short story and a novel by American writer Daniel Keyes', 
'1959-04-15', 'English', 11.99, 0.0),
(0780192833, 'War and Peace', 'War and Peace is a literary work mixed with chapters on history and philosophy by the Russian author Leo Tolstoy', 
'1867-01-01', 'English', 4.99, 0.0),
(0780425027, 'Dune', 'Dune is set in the distant future amidst a feudal interstellar society in 
which various noble houses control planetary fiefs.', 
'1965-08-15', 'English', 15.00, 0.3),
(0345391802, 'Hitchhikers Guide to the Galaxy', 'The saga mocks modern society with humour and cynicism and has as its hero a hapless, 
deeply ordinary Englishman (Arthur Dent) who unexpectedly finds himself adrift in a universe characterized by randomness and absurdity', 
'1979-10-12', 'English', 21.99, 0.0),
(0441569595, 'Neuromancer', 'Set in the future, the novel follows Henry Case, a washed-up hacker hired for one last job, 
which brings him up against a powerful artificial intelligence.',
'1984-07-01', 'English', 12.99, 0.0),
(0439708184, 'Harry Potter and the Sorcerers Stone',  'On his 11th birthday Harry discovers that his parents were
 a witch and a wizard and that he, a wizard himself, has been invited to attend Hogwarts School of Witchcraft and Wizardry.',
'1997-06-26','English', 10.99, 0.2),
(0780062316, 'Sapiens: A Brief History of Humankind', 'Yuval Noah Hararis book, Sapiens, traces the origins, mechanisms, 
and effects of what we think of as “human progress” from small bands of hunter gatherers 100,000 years ago to the present-day global network through 
which our species has come to dominate the entire Earth', '2014-06-15', 'English', 9.99, 0.0),
(0997530699, 'White Noise', 'Winner of the 1985 National Book Award, White Noise tells the
 story of Jack Gladney, his fourth wife, Babette, and their four ultramodern offspring, as they navigate the 
 rocky passages of family life to the background babble of brand-name consumerism.', '1985-08-02', 'English', 10.99, 0.15),
(855031844, 'The Color Purple', 'A powerful cultural touchstone of modern American literature, The Color Purple depicts the 
lives of African American women in early twentieth-century rural Georgia. Separated as girls, sisters Celie and Nettie sustain 
their loyalty to and hope in each other across time, distance and silence. Through a series of letters spanning twenty years, 
first from Celie to God, then the sisters to each other despite the unknown, the novel draws readers into its rich and memorable 
portrayals of Celie, Nettie, Shug Avery and Sofia and their experience. The Color Purple broke the silence around domestic and 
sexual abuse, narrating the lives of women through their pain and struggle, companionship and growth, resilience and bravery. 
Deeply compassionate and beautifully imagined, Alice Walker\'s epic carries readers on a spirit-affirming journey towards
 redemption and love.', '1988-07-06', 'German', '15.99', '0.00'),
(165428512, 'The Little Prince', 'The Little Prince became Saint-Exupéry\'s most successful work, selling an estimated 
140 million copies worldwide, which makes it one of the best-selling and most translated books ever published.
It has been translated into 301 languages and dialects.', '1943-04-04', 'French', '14.99', '0.00'),
(530219278, '1984', 'A love story, a mystery, a fantasy, a novel of self-discovery, a dystopia to rival 
George Orwell’s — 1984 is Haruki Murakami’s most ambitious undertaking yet: an instant best seller in 
his native Japan, and a tremendous feat of imagination from one of our most revered contemporary writers.', 
'2011-10-25', 'Japonese', '29.99', '0.00'),
(610424485, 'The Three-Body Problem', 'The series portrays a future where, in the first book, Earth is awaiting 
an invasion from the closest star system, which, in this universe, consists of three solar-type stars orbiting 
each other in an unstable three-body system. Within the system, its single Earth-like planet is being unhappily 
passed among them and suffers from extremes of heat and cold, as well as the repeated destruction of its intelligent
 civilizations.', '2008-09-26', 'Chinese', '18.99', '0.25'),
(369993113, 'One Hundred Years of Solitude', 'Since it was first published in May 1967 in Buenos Aires by Editorial 
Sudamericana, One Hundred Years of Solitude has been translated into 46 languages and sold more than 50 million copies.
The novel, considered García Márquez\'s magnum opus, remains widely acclaimed and is recognized as one of the most 
significant works both in the Hispanic literary canon[10] and in world literature.', '1967-02-12', 'Spanish', '17.99', '0.15'),
(989622630, 'The House of the Spirits', 'The House of the Spirits is an enthralling saga that spans decades and lives, 
twining the personal and the political into an epic novel of love, magic, and fate', '1982-04-05', 'Spanish', '16.99', '0.05'),
(211468684, 'The Woman in Black', 'What real reader does not yearn, somewhere in the recesses of his or her heart, for a 
really literate, first-class thriller--one that chills the body, but warms the soul with plot, perception, and language 
at once astute and vivid? In other words, a ghost', '2001-12-01', 'German', '14.95', '0.00'),
(194029918, 'Calvin and Hobbes (Volume 1)', 'Most people who write comic dialogue for minors demonstrate surprisingly 
little feel for—or faith in—the original source material, that is, childhood, in all its unfettered and winsome glory.',
 '1987-01-06', 'German', '15.99', '0.10'),
(667875142, 'The Night Watchman', 'It is 1953. Thomas Wazhushk is the night watchman at the first factory to open
 near the Turtle Mountain Reservation in rural North Dakota. He is also a prominent Chippewa Council member, trying 
 to understand a new bill that is soon to be put before Congress.', '2021-03-01', 'English', '11.34', '0.10'),
(824249970, 'President’s Lady', 'A true best seller.', '2018-06-05', 'English', '15.99', '0.20'),
(606311696, 'Republic of Caste: Thinking Equality in the Time of Neo-liberal Hindutva', 'A true best seller.', '2018-06-06', 'English', '15.99', '0.30'),
(358695941, 'Missing', 'A true best seller. Book of the year by New York Times', '2018-06-07', 'English', '15.99', '0.00'),
(727241842, 'God Save the Hon\'ble Supreme Court', 'A true best seller.', '2018-06-08', 'English', '16.99', '0.00'),
(463156434, 'Pakistan Adrift: Navigating Troubled Waters', 'A true best seller.', '2018-06-09', 'English', '15.99', '0.00'),
(959685244, 'Ten ldeologies: The Great Asymmetry Between Agrariansm and Industrialism', 'A true best seller.', '2018-06-10', 'English', '15.99', '0.00'),
(996061378, 'Mann Ki Baat – A Social Revolution on Radio', 'A true best seller.', '2018-06-11', 'English', '15.99', '0.00'),
(310299643, 'Undaunted: Saving the Idea of India', 'A true best seller.', '2019-01-01', 'English', '15.99', '0.00'),
(487931620, 'Politics of Jugaad: The Coalition Handbook', 'A true best seller.', '2019-01-02', 'English', '15.99', '0.00'),
(664840479, 'Game Changer', 'A true best seller.', '2019-01-03', 'English', '19.99', '0.00'),
(272109045, 'Kundan: Saigal’s Life & Music', 'A true best seller.', '2019-01-04', 'English', '15.99', '0.15'),
(733104735, 'Chandra Shekhar - The Last Icon of Ideological Politics', 'A true best seller.', '2019-01-05', 'English', '15.99', '0.15'),
(418209302, 'Defining India: Through Their Eyes', 'A true best seller.', '2019-01-06', 'English', '15.99', '0.00'),
(169370322, 'Function of Data Sovereignty - The Pursuit of Supremacy', 'A true best seller.', '2019-01-07', 'English', '15.99', '0.00'),
(553124961, 'Ayodhya: City of Faith, City of Discord', 'A true best seller.', '2019-01-08', 'English', '15.99', '0.00'),
(185829851, 'Os Maias', 'Os Maias: Episódios da Vida Romântica is a realist novel by Portuguese author Eça de Queiroz. 
Maia is the name of the fictional family the novel is about. As early as 1878, while serving in the Portuguese consulate
 at Newcastle upon Tyne, Eça had at least given a name to this book and had begun working on it.', '1988-07-07', 'Portuguese', '10.90', '0.15'),
(464211053, 'The Lusiad: Or, The Discovery of India: an Epic Poem (Os Lusíadas)', 'Os Lusíadas, usually translated as The 
Lusiads, is a Portuguese epic poem written by Luís Vaz de Camões and first published in 1572. It is widely regarded as 
the most important work of Portuguese-language literature and is frequently compared to Virgil\'s Aeneid.', '1572-01-01', 'Portuguese', '19.99', '0.00'),
(270680926, 'The Double (O Homem Duplicado)', 'The Double is a 2002 novel by Portuguese author José Saramago, 
who won the Nobel Prize in Literature in 1998. In Portuguese, the title is literally \"The Duplicated Man.\" 
It was translated into English and published as The Double in 2004.', '2002-01-03', 'Portuguese', '25.99', '0.10'),
(102495685, 'The Cave', 'The Cave is a novel by Portuguese author José Saramago who received the Nobel Prize in 1998.
 It was published in Portuguese in 2000 and in English in 2002.', '2000-03-04', 'Portuguese', '25.99', '0.25'),
(735987135, 'Dom Quixote', 'It was originally published in two parts, in 1605 and 1615. A founding work of 
Western literature, it is often labeled as the first modern novel and is considered one of the greatest works
 ever written. Don Quixote also holds the distinction of being one of the most-translated books in the world.', 
 '1904-05-23', 'Spanish', '14.90', '0.00'),
(578747125, 'Marvel Encyclopedia, New Edition', 'This is the \"book that mankind has been hungering for,\" says 
American comic book writer, editor, publisher, and producer, Stan Lee, \"a book that is-now and forever-a shining 
eacon of wonder, a titanic tribute to talent unleashed.\"', '2019-04-02', 'English', '22.04', '0.00'),
(436490324, 'The Malacca Conspiracy ', 'From beloved author Don Brown comes a bone-chilling tale 
of terrorism on the high seas. ', '2010-06-02', 'English', '11.65', '0.00'),
(993941595, 'Justifiable Homicide', 'This book, Justifiable Homicide, exams twenty actual criminal cases 
where a woman has been charged with the crime of murder as the result of a homicide where the victim is a man. 
What does the criminal justice system do with a woman who is on trial for murder? An interesting question. 
The answer may surprise any person who reads this book.', '2021-09-07', 'English', '8.99', '0.00'),
(368596427, 'Angels and Demons', 'The explosive Robert Langdon thriller from Dan Brown, the #1
 New York Times bestselling author of The Da Vinci Code and Inferno—now a major film directed by
 Ron Howard and starring Tom Hanks and Felicity Jones.', '2005-05-03', 'English', '19.99', '0.05'),
(165774859, 'I Know Why the Caged Bird Sings ', 'Here is a book as joyous and painful, as mysterious and 
memorable, as childhood itself. I Know Why the Caged Bird Sings captures the longing of lonely children, 
the brute insult of bigotry, and the wonder of words that can make the world right. Maya Angelou’s debut
 memoir is a modern American classic beloved worldwide.', '2009-04-15', 'English', '20.99', '0.00'),
(981457847, 'Letter to My Daughter', 'NEW YORK TIMES BESTSELLER • Maya Angelou shares her path to living 
well and with meaning in this absorbing book of personal essays.', '2008-09-23', 'English', '9.53', '0.00'),
(327593039, 'The Real Anthony Fauci: Bill Gates, Big Pharma, and the Global War on Democracy and Public Health 
(Children’s Health Defense)', 'The Real Anthony Fauci details how Fauci, Gates, and their cohorts use their
 control of media outlets, scientific journals, key government and quasi-governmental agencies, global 
 intelligence agencies, and influential scientists and physicians to flood the public with fearful 
 propaganda about COVID-19 virulence and pathogenesis, and to muzzle debate and ruthlessly censor dissent.', 
 '2021-11-16', 'English', '21.99', '0.10'),
(667311057, 'What We Talk About When We Talk About Love', 'What We Talk About When We Talk About Love is a 
1981 collection of short stories by American writer Raymond Carver, as well as the title of one of the
 stories in the collection.', '1981-02-01', 'English', '10.99', '0.00'),
(786299473, 'The Handmaid`s Tale' , 'The Handmaid`s Tale is a dystopian novel by Canadian author
 Margaret Atwood, published in 1985. It is set in a near-future New England, in a strongly patriarchal,
 totalitarian theonomic state, known as Republic of Gilead, that has overthrown the United States government. 
The central character and narrator is a woman named Offred, one of the group known as \"handmaids\", 
who are forcibly assigned to produce children for the \"commanders\" – the ruling class of men in Gilead.', 
'1985-05-05', 'English', '11.99', '0.1');



INSERT INTO `supplies` (`supplier_VAT`, `book_ISBN`, `quantity`) VALUES
(208332175, 0780439420, 170),
(841970825, 0780316066, 90),
(599215354, 0780192823, 60),
(599215354, 0788467503, 50),
(841970825, 0780192833, 70),
(230279357, 0780425027, 100),
(185390566, 0441569595, 80),
(208262155, 0439708184, 250),
(629103205, 0780062316, 120),
(581950919, 0345391802, 90),
(451202745, 0781405072, 60),
(473179974, 0141183411, 30),
(208332176, 0420635491, 40),
(119235900, 0499106354, 50),
(185390566, 0141032009, 80),
(52257210, 667311057, 50),
(113169013, 102495685, 80),
(119235900, 165428512, 80),
(185390566, 165774859, 250),
(199022019, 169370322, 130),
(204582175, 185829851, 170),
(207856875, 194029918, 40),
(208262155, 211468684, 100),
(208332175, 270680926, 60),
(208332176, 272109045, 30),
(218350281, 310299643, 90),
(230279357, 327593039, 60),
(271746484, 358695941, 50),
(332622483, 368596427, 120),
(342053585, 369993113, 70),
(367929899, 418209302, 90),
(417973978, 436490324, 50),
(451202745, 463156434, 80),
(456536393, 464211053, 80),
(473179974, 487931620, 250),
(516561620, 530219278, 130),
(547653776, 553124961, 170),
(553064730, 578747125, 40),
(581950919, 606311696, 100),
(599215354, 610424485, 60),
(629103205, 664840479, 30),
(638489223, 667875142, 90),
(655113568, 727241842, 60),
(698812881, 733104735, 50),
(757647427, 735987135, 120),
(761984538, 786299473, 70),
(762033455, 824249970, 90),
(765312339, 855031844, 80),
(767292237, 959685244, 80),
(770087958, 981457847, 79),
(818393168, 989622630, 80),
(827277285, 993941595, 77),
(835473831, 996061378, 77),
(841970825, 997530699, 100),
(853471934, 664840479, 90),
(855445482, 667875142, 60),
(863533815, 727241842, 50),
(880922897, 733104735, 120),
(907705512, 735987135, 70),
(912682306, 786299473, 80),
(926587991, 824249970, 80),
(937621245, 855031844, 80),
(966126398, 959685244, 70),
(970767278, 981457847, 70),
(982329149, 989622630, 70);



INSERT INTO `publishes` (`publisher_VAT`, `book_ISBN`) VALUES
(131824190, 0141183411),
(462905685, 0781405072),
(131824190, 0780439420),
(239814525, 0780316066),
(593788600, 0780192823),
(450578874, 0788467503),
(131174569, 0780192833),
(131467512, 0345391802),
(472591395, 0780425027),
(472591395, 0441569595),
(450578874, 0439708184),
(131824190, 0420635491),
(325271324, 0499106354),
(279189158, 0141032009),
(773425698, 667311057),
(954084929, 102495685),
(729416184, 165428512),
(794676222, 165774859),
(385763031, 169370322),
(663570830, 185829851),
(437503609, 194029918),
(815630395, 211468684),
(539584147, 270680926),
(336962799, 272109045),
(225449756, 310299643),
(758417221, 327593039),
(544564384, 358695941),
(312653044, 368596427),
(979446079, 369993113),
(353613732, 418209302),
(443796965, 436490324),
(963025429, 463156434),
(465526926, 464211053),
(253325600, 487931620),
(972820206, 530219278),
(373797153, 553124961),
(219169462, 578747125),
(436855866, 606311696),
(425085797, 610424485),
(413315729, 664840479),
(401545660, 667875142),
(389775592, 727241842),
(378005523, 733104735),
(219169462, 735987135),
(436855866, 786299473),
(425085797, 824249970),
(413315729, 855031844),
(401545660, 959685244),
(389775592, 981457847),
(378005523, 989622630),
(353613732, 993941595),
(443796965, 996061378),
(336962799, 997530699);




INSERT INTO `author` (`author_id`, `author_name`, `nationality`, `date_birth`) VALUES
(1, 'Douglas Adams', 'American', '1952-03-11'),
(2, 'William Gibson', 'American', '1948-03-17'),
(3, 'J. K. Rowling', 'American', '1965-07-31'),
(4, 'Yuval Noah Harari', 'Israeli', '1948-02-24'),
(5, 'Frank Herbert', 'American', '1920-10-08'),
(6, 'George Orwell', 'English', '1903-06-25'),
(7, 'Leo Tolstoy', 'Russian', '1828-09-09'),
(8, 'David Foster Wallace', 'American', '1962-02-21'),
(9, 'Daniel Keyes', 'American', '1927-08-09'),
(10, 'Fyodor Dostoevsky', 'Russian', '1821-11-11'),
(11, 'Bram Stoker', 'Irish', '1847-11-08'),
(12, 'Virigina Wolf', 'English', '1882-01-25'),
(13, 'Vladimir Nabokov', 'Russian', '1899-04-22'),
(14, 'Anne Frank', 'Russian', '1929-06-12'),
('15', 'Alice Walker', 'English', '1617-07-21'),
('16', 'Anand Teltumbde', 'Indian', '1630-05-17'),
('17', 'Antoine de Saint-Exupéry', 'French', '1663-07-24'),
('18', 'Asad Durrani', 'Indian', '1680-01-19'),
('19', 'Bill Waterson', 'English', '1692-03-17'),
('20', 'Dan Brown', 'American', '1712-09-03'),
('21', 'Devendra Fadnavis', 'German', '1722-09-08'),
('22', 'Don Brown', 'English', '1734-09-11'),
('23', 'Don DeLillo', 'Croatian', '1755-10-21'),
('24', 'Eça de Queirós', 'Portuguese', '1761-06-01'),
('25', 'Fali S Nariman', 'Croatian', '1762-08-01'),
('26', 'Gabriel García Márquez', 'Argentine', '1766-07-14'),
('27', 'Haruki Murakami', 'Japonese', '1786-09-03'),
('28', 'Isabel Allende', 'Chilean', '1803-01-24'),
('29', 'José Saramago', 'Portuguese', '1820-08-03'),
('30', 'Liu Cixin', 'Chinese', '1841-04-20'),
('31', 'Louise Erdrich ', 'German', '1850-09-12'),
('32', 'Luís de Camões', 'Portuguese', '1510-07-02'),
('33', 'Margaret Atwood', 'English', '1855-04-08'),
('34', 'Maya Angelou', 'American', '1910-09-18'),
('35', 'Miguel de Cervantes', 'Spanish', '1880-05-08'),
('36', 'Raymond Carver', 'English', '1896-07-11'),
('37', 'Robert F. Kennedy Jr.', 'American', '1980-10-03'),
('38', 'Ruchir Sharma', 'Norwegian', '1958-06-06'),
('39', 'S Jaipal Reddy', 'Norwegian', '1964-11-03'),
('40', 'Saba Naqvi', 'Norwegian', '1609-07-10'),
('41', 'Sangeeta Ghosh', 'Maltese', '1610-10-17'),
('42', 'Shahid Afridi', 'Maltese', '1610-12-04'),
('43', 'Sharad Dutt', 'Polish', '1613-01-21'),
('44', 'Shri Harivansh', 'Indian', '1648-02-25'),
('45', 'Sonia Singh', 'Russian', '1702-08-04'),
('46', 'Stephen Wiacek', 'Russian', '1723-10-08'),
('47', 'DK', 'American', '1725-11-01'),
('48', 'Adam Bray', 'American', '1732-02-10'),
('49', 'Stan Lee', 'American', '1734-01-06'),
('50', 'Sumana Roy', 'American', '1738-12-26'),
('51', 'Susan Hill', 'Australian', '1749-06-09'),
('52', 'Valay Singh', 'Belgian', '1771-07-18'),
('53', 'Vinit Goenka', 'Belgian', '1785-05-31'),
('54', 'Shri Ravi Dutt Bajpai', 'Indian', '1792-02-13');

 
INSERT INTO `writes` (`book_ISBN`, `author_id`) VALUES
(0780439420, 3),
(0780316066, 8),
(0780192823, 10),
(0788467503, 9),
(0780192833, 3),
(0780425027, 5),
(0345391802, 1),
(0441569595, 2),
(0439708184, 3),
(0780062316, 4),
(0781405072, 11),
(0141183411, 12),
(0420635491, 10),
(0499106354, 13),
(0141032009, 14),
('855031844', '15'),
('606311696', '16'),
('165428512', '17'),
('463156434', '18'),
('194029918', '19'),
('368596427', '20'),
('993941595', '20'),
('996061378', '21'),
('436490324', '22'),
('0997530699', '23'),
('185829851', '24'),
('727241842', '25'),
('369993113', '26'),
('530219278', '27'),
('989622630', '28'),
('102495685', '29'),
('270680926', '29'),
('610424485', '30'),
('667875142', '31'),
('464211053', '32'),
('786299473', '33'),
('165774859', '34'),
('981457847', '34'),
('735987135', '35'),
('667311057', '36'),
('327593039', '37'),
('310299643', '38'),
('959685244', '39'),
('487931620', '40'),
('824249970', '41'),
('664840479', '42'),
('272109045', '43'),
('733104735', '44'),
('418209302', '45'),
('578747125', '46'),
('578747125', '47'),
('578747125', '48'),
('578747125', '49'),
('358695941', '50'),
('211468684', '51'),
('553124961', '52'),
('169370322', '53'),
('733104735', '54');

INSERT INTO `category` (`category_id`, `category_name`) VALUES
(1, 'Science fiction'),
(2, 'Humor'),
(3, 'Fantasy fiction'),
(4, 'Non-fiction'),
(5, 'Adventure'),
(6, 'Contemporary Lit'),
(7, 'Horror'),
(8, 'Mystery'),
(9, 'Historical Fiction'),
(10, 'Manga'),
(11, 'Comic Books'),
(12, 'New Adult'),
(13, 'Diverse Lit'),
(14, 'Romance'),
(15, 'Thriller'),
(16, 'Children Literature'),
(17, 'Schoolbooks'),
(18, 'Religion'),
(19, 'Cookery Book'),
(20, 'Political Fiction'),
(21, 'Psychological fiction'),
(22, 'Crime fiction'),
(23, 'Poetry'),
(24, 'Novel'),
(25, 'Horror'),
(26, 'Gothic'),
(27, 'Diary'),
('28', 'Memoir'),
('29', 'Biography'),
('30', 'Christian'),
('31', 'Economics'),
('32', 'Fiction'),
('33', 'Graphic Novels'),
('34', 'History'),
('35', 'Law'),
('36', 'Math'),
('37', 'Music'),
('38', 'Politics'),
('39', 'Sience'),
('40', 'True crime'),
('41', 'Chemistry'),
('42', 'Literature'),
('43', 'Drama'),
('44', 'Culture'),
('45', 'Action'),
('46', 'Classics'),
('47', 'Romance'),
('48', 'Short Stories'),
('49', 'Autobiography'),
('50', 'Self-help');



INSERT INTO `has` (`book_ISBN`, `category_id`) VALUES
(0780439420, 24),
(0780439420, 3),
(0780316066, 24),
(0780316066, 2),
(0780316066, 1),
(0780192823, 24),
(0780192823, 22),
(0780192823, 21),
(0788467503, 24),
(0788467503, 1),
(0788467503, 21),
(0780192833, 24),
(0780192833, 9),
(0780192833, 21),
(0780425027, 24),
(0780425027, 1),
(0780425027, 3),
(0345391802, 24),
(0345391802, 1),
(0345391802, 2),
(0439708184, 24),
(0439708184, 3),
(0780062316, 4),
(0781405072, 25),
(0781405072, 26),
(0141183411, 24),
(0420635491, 24),
(0499106354, 27),
(0499106354, 24),
('358695941', '5'),
('368596427', '5'),
('664840479', '5'),
('272109045', '29'),
('436490324', '30'),
('194029918', '11'),
('578747125', '11'),
('993941595', '22'),
('959685244', '31'),
('530219278', '3'),
('211468684', '32'),
('368596427', '32'),
('436490324', '32'),
('553124961', '32'),
('610424485', '32'),
('664840479', '32'),
('667875142', '32'),
('786299473', '32'),
('989622630', '32'),
('993941595', '15'),
('997530699', '32'),
('194029918', '33'),
('578747125', '33'),
('310299643', '34'),
('418209302', '34'),
('824249970', '34'),
('855031844', '34'),
('996061378', '34'),
('211468684', '25'),
('667875142', '25'),
('989622630', '25'),
('727241842', '35'),
('327593039', '36'),
('272109045', '37'),
('667311057', '24'),
('102495685', '24'),
('165428512', '24'),
('185829851', '24'),
('194029918', '24'),
('270680926', '24'),
('369993113', '24'),
('436490324', '24'),
('530219278', '24'),
('610424485', '24'),
('735987135', '24'),
('786299473', '24'),
('855031844', '24'),
('997530699', '24'),
('165774859', '23'),
('464211053', '23'),
('981457847', '23'),
('169370322', '38'),
('463156434', '38'),
('487931620', '38'),
('606311696', '38'),
('733104735', '38'),
('327593039', '39'),
('165428512', '16'),
('194029918', '16');



INSERT INTO `location` (`zipcode`, `country`, `city`, `address`) VALUES
('54481', 'US', 'Cornucopia', 'Route of Margaritas, nº 23, 1st Left'),
('78609', 'US', 'Redmond', 'Route of Juanitas, nº 3, 4st Left' ),
('54281', 'US', 'Sandy Springs', 'Andersons Avenue, nº 25'),
('98217', 'US', 'Amana', '1 Benton Linn Road'),
('96981', 'US', 'Monterey Park', 'Wall Street Avenue, nº 1'),
('95661', 'US', 'Washington', '1 Batchelder Road'),
('96971', 'US', 'Layton', 'Lawrence Avenue, 23 E'),
('98211', 'US', 'La Crescent', '22 Secluded Road'),
('78709', 'US', 'Bristol', '12 Lakeview Drive'),
('78677', 'US', 'Castle Rock', '10 Chesterfield Road'),
('78577', 'US', 'Ellsworth', '24 N Mikel Street'),
('78352', 'US', 'Marshallville', '26 Star Drive'),
('38008', 'US', 'Bolivar', '28 State Route 15'),
('84380', 'US', 'Washington', '10 N Somerset Street'),
('81416', 'US', 'Delta', '22 Leon Street Delta'),
('23303', 'US', 'Portsmouth', '33 Westminster Drive'),
('55448', 'US', 'Minneapolis', '25 116th 1/2nd Avenue NW'),
('31053', 'US', 'Marshallville', '26 Star Drive'),
('49130', 'US', 'Union', '31 Claire Drive'),
('28394', 'US', 'Vass', '6 State Road 2013'),
('33604', 'US', 'Johnson City', '6 Meadowview Drive'),
('54474', 'PT', 'Lisboa', 'Rua de Entrecampos 46'),
('58942', 'ES', 'Valencia', 'Bellavista 75'),
('52591', 'US', 'New York', '1101 7th St NW'),
('85334', 'US', 'Texas', '165 Critter Hill Dr'),
('97164', 'US', 'New Orleans', '5907 Fisher Rd #13'),
('50938', 'FR', 'Paris', '75 avenue du Marechal Juin'),
('69393', 'FR', 'Paris', '58 rue Charles Corbeau'),
('37698', 'FR', 'Marseille', '78 Faubourg Saint Honoré'),
('19011', 'PT', 'Porto', 'R Armazéns 108'),
('77581', 'ES', 'Cádiz', 'Escuadro 78'),
('74137', 'ES', 'Cádiz', 'Ctra. Beas-Cortijos Nuevos 54'),
('61959', 'PT', 'Bragança', 'R Alto Cruz 46'),
('10032', 'CH', 'Beijing', 'Shing Hing Coml Bldg'),
('33567', 'PT', 'Coimbra', 'Rua de José Magalhães 89'),
('22124', 'ES', 'Barcelona', 'Avda. Enrique Peinador 40'),
('73043', 'US', 'Chicago', '162 Bell St'),
('63459', 'US', 'Boston', '17631 NW 3rd St'),
('49096', 'EN', 'Manchester', '53 Town Lane'),
('37303', 'FR', 'Marseille', '95 rue du Paillle en queue'),
('47617', 'FR', 'Lyon', '46 route de Lyon'),
('49652', 'FR', 'Lyon', '84 rue des Chaligny'),
('29554', 'PT', 'Leiria', 'Rua Direita 51'),
('97181', 'ES', 'Sevilla', 'C/ Andalucía 5'),
('78011', 'ES', 'Madrid', 'José matía 84'),
('84873', 'PT', 'Lisboa', 'Avenida EUA 48'),
('81198', 'EN', 'London', 'Baker Street 24'),
('20085', 'PT', 'Porto', 'Rua Caminho Cruz 105'),
('31521', 'CH', 'Hong Kong', 'Dormind Ind Bldg Fanling'),
('20648', 'CH', 'Hong Kong', ' Wing On Hse');


INSERT INTO `client` (`account_id`, `client_name`, `date_birth`, `VAT`, `email`, `phone_number`, `premium`, `zipcode`) VALUES
(1, 'Robert Bracey', '1959-09-08', '565132963', 'rpbbracey@gamil.com', '714-803-8258', 'Normal-Premium', '54481'),
(2, 'Maria Rowe', '1980-06-18', '558608959', 'MariaRo212@gamil.com', '818-645-8021', 'Default', '78609'),
(3, 'Amparo Carter', '1986-12-12', '264934433', 'AmpCarter86@gamil.com', '786-439-0142', 'Extra-Premium', '54281'),
(4, 'Sean Malloy', '1992-04-25', '425956969', 'Sean7malloy@gamil.com', '786-439-0142', 'Default', '98217'),
(5, 'Edith Means', '1970-03-10', '500809399', 'ediMeaning@gamil.com', '314-407-6232', 'Normal-Premium', '96981'),
(6, 'Anthony Heiman', '1956-04-11', '587331094', 'tonyHei56@gamil.com', '662-628-8342', 'Default', '95661'),
(7, 'Kurt Payne', '1994-04-05', '280982245', 'cobainaway@gamil.com', '440-442-2573', 'Normal-Premium', '96971'),
(8, 'William Hanson', '1986-08-12', '621683478', 'sampainaway@gamil.com', '415-861-4126', 'Default', '98211'),
(9, 'Glinda Engelhardt', '1966-07-26', '637300306', 'glindaEngel66@gamil.com', '903-841-6434', 'Extra-Premium', '78709'),
(10, 'Leonard Phillips', '1964-07-13', '322541707', 'leoPhil66@gamil.com', '630-493-8277','Default', '78677'),
(11, 'Clay Talton', '1963-09-25', '410815262', 'claytonman@gamil.com', '731-435-0122', 'Default', '78577'),
(12, 'Isaac Smith', '1968-11-12', '203624768', 'thebindingofisaacsmith@gamil.com', '508-474-1876', 'Default', '78352'),
(13, 'Roger F. Gorham', '1993-05-30', '401259221', 'RogerFGorham@dayrep.com', '808-421-5164', 'Normal-Premium', '38008'),
(14, 'Barbara K. Burns', '1942-09-10', '324899123', 'BarbaraKBurns@dayrep.com', '585-325-6266', 'Default', '84380'),
(15, 'Don A. Chadwick', '1961-08-09', '481217221', 'DonAChadwick@dayrep.com', '903-752-3310', 'Default', '81416'),
(16, 'Robert J. Rosario', '1992-05-30', '241259221', 'RobertJRosario@rhyta.com', '202-504-3693', 'Extra-Premium', '23303'),
(17, 'William B. Evans', '1963-05-30', '123456789', 'WilliamBEvans@rhyta.com', '618-947-5346', 'Normal-Premium', '55448'),
(18, 'Jesus P. Gamble', '2000-01-01', '983334321', 'JesusPGamble@teleworm.us', '860-290-7333', 'Default', '31053'),
(19, 'Lawrence M. Nicholson', '1945-02-20', '987654321', 'LawrenceMNicholson@rhyta.com', '646-964-5885', 'Normal-Premium', '49130'),
(20, 'Clarence K. Chiaramonte', '1973-07-08', '401529221', 'ClarenceKChiaramonte@rhyta.com', '706-579-3663', 'Extra-Premium', '28394'),
(21, 'Nancy C. Viola', '2003-09-20', '310251521', 'NancyCViola@rhyta.com', '978-863-1423', 'Default', '33604'),
('22', 'Caroline Smith', '1948-08-25', '127836042', 'carolinesmith@gmail.com', '59677390631', 'Normal-Premium', '54474'),
('23', 'Edgar Murphy', '1949-09-23', '884645441', 'edgarmurphy@gmail.com', '64367824575', 'Default', '58942'),
('24', 'Kristian Hill', '1950-05-04', '509675814', 'kristianhill@gmail.com', '44005015283', 'Extra-Premium', '52591'),
('25', 'Sienna Brown', '1951-03-24', '271657055', 'siennabrown@gmail.com', '67379776242', 'Normal-Premium', '85334'),
('26', 'Garry Adams', '1953-03-14', '819785364', 'garryadams@gmail.com', '58701900406', 'Default', '97164'),
('27', 'Garry Sullivan', '1955-10-13', '283114425', 'garrysullivan@gmail.com', '47190767104', 'Extra-Premium', '50938'),
('28', 'Lyndon Watson', '1957-12-26', '831709643', 'lyndonwatson@gmail.com', '99394111782', 'Normal-Premium', '69393'),
('29', 'Kirsten Bailey', '1962-05-13', '41646168', 'kirstenbailey@gmail.com', '40810088141', 'Default', '37698'),
('30', 'Ana Santos', '1962-09-29', '772838102', 'anasantos@gmail.com', '915286987', 'Extra-Premium', '19011'),
('31', 'Hernando Perez', '1962-11-27', '487455125', 'hernandoperez@gmail.com', '96824339118', 'Normal-Premium', '77581'),
('32', 'Javier Luís', '1964-05-06', '923526287', 'javierluís@gmail.com', '17184615413', 'Default', '74137'),
('33', 'Lucy Armstrong', '1965-06-02', '944856193', 'lucyarmstrong@gmail.com', '29051991341', 'Extra-Premium', '61959'),
('34', 'Miranda Ryan', '1968-11-14', '1753755', 'mirandaryan@gmail.com', '47335192551', 'Normal-Premium', '10032'),
('35', 'Agata Harris', '1975-01-20', '162450805', 'agataharris@gmail.com', '10067768217', 'Default', '33567'),
('36', 'Ravi Jida', '1977-07-25', '145867957', 'ravijida@gmail.com', '67254233025', 'Extra-Premium', '22124'),
('37', 'Ádan Óscar', '1977-08-13', '465989350', 'ádanóscar@gmail.com', '4206286757', 'Normal-Premium', '73043'),
('38', 'Albert Farrell', '1978-01-08', '721046146', 'albertfarrell@gmail.com', '15358511503', 'Default', '63459'),
('39', 'Oscar Edwards', '1979-04-20', '795551069', 'oscaredwards@gmail.com', '39299744165', 'Extra-Premium', '49096'),
('40', 'Thomas Douglas', '1979-05-08', '802817536', 'thomasdouglas@gmail.com', '88119881119', 'Normal-Premium', '37303'),
('41', 'Alan Morrison', '1989-01-21', '960338101', 'alanmorrison@gmail.com', '16238716215', 'Default', '47617'),
('42', 'Emma Stewart', '1989-08-16', '462168702', 'emmastewart@gmail.com', '25121523936', 'Extra-Premium', '49652'),
('43', 'Robert Holmes', '1990-12-22', '484770132', 'robertholmes@gmail.com', '72376480431', 'Normal-Premium', '29554'),
('44', 'Valter Castro', '1992-12-05', '846789284', 'valtercastro@gmail.com', '936852741', 'Default', '97181'),
('45', 'Lucia Fowler', '1999-04-28', '678650448', 'luciafowler@gmail.com', '47983838464', 'Extra-Premium', '78011'),
('46', 'Belinda Gomes', '1999-09-04', '651428746', 'belindagomes@gmail.com', '85183366745', 'Normal-Premium', '84873'),
('47', 'Alan Owens', '1993-07-20', '176472799', 'alanowens@gmail.com', '45971919014', 'Default', '81198'),
('48', 'Dexter Brooks', '1995-05-11', '530536021', 'dexterbrooks@gmail.com', '63248757993', 'Extra-Premium', '20085'),
('49', 'Melissa Walls', '1996-05-06', '963302782', 'melissawalls@gmail.com', '60813837221', 'Normal-Premium', '31521'),
('50', 'Wang Li', '1996-07-26', '986961855', 'wangli@gmail.com', '59051789365', 'Default', '31521');


INSERT INTO `commentary` (`rating`, `commentary_description`, `account_id`, `book_ISBN`) VALUES
(4, 'Brilliant and funny read!', 1, 0345391802),
(5, 'I wish I could read it for the first time again.', 2, 0345391802),
(3, 'Really difficult read, shouldve skipped this one...', 2, 0441569595),
(5, 'Youre a Wizard Harry!!!', 4, 0439708184),
(4, 'Very well thought out book.', 5, 0780062316),
(4, 'Hella scary...', 12, 0781405072),
(5, 'Out of this world!', 9, 0345391802),
(4, 'Would and will read again!', 12, 0780316066),
(1, 'Awful..', 17, 0780192823),
(3, 'Your average read.', 21, 0788467503),
(4, 'Dope!', 8, 0780192833),
(2, 'Meh..', 7, 0780425027),
(4, 'As good as it is confusing...', 10, 0441569595),
(3, 'Okayish...', 19, 0439708184),
(3, 'Readable', 20, 0441569595),
(5,' Brilliant! Im sad its over', 2, 102495685),
(1,' Waste of money and time', 2, 165428512),
(3,' I was expecting better..', 2, 165774859),
(2,' It made me sleepy', 2, 169370322),
(2,' A mess of a story.', 6, 185829851),
(3,' Not great..', 6, 194029918),
(1,' I read 5 pages of it and I was done.', 6, 211468684),
(1, 'Really bad', 9, 102495685),
(5, 'Wish I could read it for the first time again', 9, 165428512),
(5, 'Amazing', 12, 165774859),
(5, 'Really helpful', 12, 169370322),
(1, 'The worst book I have ever read.', 12, 185829851),
(3, 'Not bad, not good either', 17, 211468684),
(2, 'Story too big and not catchy at all', 18, 270680926),
(3, 'Could be worse, I guess..', 20, 194029918),
(5, 'I love this author', 20, 211468684),
(5, 'Incredible', 27, 667875142),
(5, 'No words, you have to read it!', 29, 733104735),
(5, 'Everyone should read this book once in a lifetime', 36, 989622630),
(5, 'WOW', 42, 727241842),
(5, 'My favourite book ever!!', 50, 824249970);

INSERT INTO `commentary` (`rating`, `account_id`, `book_ISBN`) VALUES
(4, 16, 194029918),
(4, 1, 667311057),
(2, 9, 270680926),
(4, 9, 667311057),
(2, 21, 270680926),
(3, 21, 194029918),
(1, 23, 211468684),
(1, 23, 270680926),
(3, 23, 610424485),
(4, 26, 664840479),
(2, 28, 727241842),
(1, 30, 735987135),
(2, 30, 786299473),
(1, 30, 824249970),
(4, 30, 855031844),
(3, 34, 959685244),
(1, 35, 981457847),
(2, 37, 993941595),
(4, 38, 996061378),
(3, 39, 997530699),
(1, 40, 664840479),
(1, 41, 667875142),
(3, 43, 733104735),
(1, 44, 735987135),
(3, 45, 786299473);

INSERT INTO `orders` (`order_id`, `date_order`, `date_shipment`, `estimate_arrival`, `account_id`) VALUES
(1, '2020-12-05', '2020-12-08', '2020-12-16', 1),
(2, '2021-07-01', '2021-07-03', '2021-07-09', 2),
(3, '2021-12-02', '2020-12-05', '2021-12-12', 3),
(4, '2021-12-12', '2021-12-15', '2021-12-18', 5),
(5, '2021-02-01', '2021-02-03', '2021-02-09', 9),
(6, '2021-04-20', '2021-04-23', '2021-04-26', 4),
(7, '2021-01-23', '2021-01-26', '2021-01-28', 8),
(8, '2021-08-01', '2021-08-03', '2021-08-09', 6),
(9, '2021-11-21', '2021-11-13', '2021-11-19', 12),
(10, '2020-06-12', '2020-06-16', '2020-06-19', 17),
(11, '2019-04-01', '2019-04-03', '2019-04-09', 21),
(12, '2019-02-01', '2019-02-03', '2019-02-09', 4),
(13, '2021-03-15', '2021-03-18', '2021-03-21', 1),
(14, '2018-02-01', '2018-02-03', '2018-02-09', 9),
(15, '2019-07-01', '2019-07-03', '2019-07-09', 13),
(16, '2021-03-15', '2021-03-18', '2021-03-21', 15),
(17, '2019-10-01', '2019-10-03', '2019-10-09', 18),
(18, '2020-10-01', '2020-10-03', '2020-10-09', 17),
(19, '2021-12-01', '2021-12-03', '2021-12-09', 7),
(20, '2021-07-06', '2021-07-09', '2021-07-12', 9),
(21, '2011-09-28', '2011-09-30', '2011-10-05', 22),
(22, '2011-11-03', '2011-11-05', '2011-11-10', 23),
(23, '2011-12-11', '2011-12-13', '2011-12-18', 24),
(24, '2012-09-11', '2012-09-13', '2012-09-18', 25),
(25, '2013-04-09', '2013-04-11', '2013-04-16', 26),
('26', '2013-07-19', '2013-07-21', '2013-07-26', '27'),
('27', '2013-11-07', '2013-11-09', '2013-11-14', '28'),
('28', '2014-04-09', '2014-04-11', '2014-04-16', '29'),
('29', '2014-09-11', '2014-09-13', '2014-09-18', '30'),
('30', '2015-02-25', '2015-02-27', '2015-03-04', '31'),
('31', '2015-03-15', '2015-03-17', '2015-03-22', '32'),
('32', '2015-09-21', '2015-09-23', '2015-09-28', '33'),
('33', '2016-03-11', '2016-03-13', '2016-03-18', '34'),
('34', '2016-08-10', '2016-08-12', '2016-08-17', '35'),
('35', '2016-09-03', '2016-09-05', '2016-09-10', '36'),
('36', '2016-10-14', '2016-10-16', '2016-10-21', '37'),
('37', '2016-10-31', '2016-11-02', '2016-11-07', '38'),
('38', '2016-11-21', '2016-11-23', '2016-11-28', '39'),
('39', '2017-04-24', '2017-04-26', '2017-05-01', '1'),
('40', '2018-10-29', '2018-10-31', '2018-11-05', '2'),
('41', '2019-06-29', '2019-07-01', '2019-07-06', '3'),
('42', '2020-01-10', '2020-01-12', '2020-01-17', '5'),
('43', '2020-04-25', '2020-04-27', '2020-05-02', '9'),
('44', '2020-12-24', '2020-12-26', '2020-12-31', '22'),
('45', '2021-04-08', '2021-04-10', '2021-04-15', '23'),
('46', '2019-09-29', '2019-10-01', '2019-10-06', '30'),
('47', '2020-06-09', '2020-06-11', '2020-06-16', '6'),
('48', '2020-11-20', '2020-11-22', '2020-11-27', '7'),
('49', '2020-12-18', '2020-12-20', '2020-12-25', '12'),
('50', '2021-07-12', '2021-07-14', '2021-07-19', '12');


INSERT INTO `order_itens` (`order_id`, `ISBN`, `quantity`) VALUES
(1, 0345391802, 2),
(2, 0780316066, 1),
(2, 0780192823, 1),
(3, 0788467503, 1),
(5, 0780192833, 2),
(5, 0780425027, 1),
(6, 0345391802, 1),
(7, 0441569595, 1),
(8, 0439708184, 1),
(9, 0780062316, 1),
(10, 0781405072, 1),
(10, 0141183411, 1),
(11, 0141183411, 1),
(12, 0781405072, 1),
(13, 0780062316, 1),
(14, 0439708184, 1),
(15, 0441569595, 1),
(16, 0345391802, 1),
(16, 0780425027, 1),
(17, 0780192833, 1),
(17, 0788467503, 1),
(18, 0780192823, 3),
(19, 0780316066, 1),
(20, 0345391802, 2),
('24', '102495685', '3'),
('25', '102495685', '1'),
('26', '102495685', '1'),
('27', '165428512', '1'),
('28', '165428512', '1'),
('29', '368596427', '2'),
('30', '368596427', '1'),
('31', '530219278', '2'),
('32', '530219278', '1'),
('33', '530219278', '1'),
('34', '997530699', '1'),
('35', '989622630', '3'),
('36', '735987135', '1'),
('36', '989622630', '1'),
('36', '272109045', '1'),
('36', '310299643', '1'),
('37', '610424485', '1'),
('37', '664840479', '2'),
('37', '667875142', '1'),
('37', '727241842', '1'),
('38', '436490324', '2'),
('39', '436490324', '2'),
('40', '270680926', '1'),
('40', '272109045', '1'),
('41', '165774859', '1'),
('41', '185829851', '5'),
('42', '194029918', '1'),
('42', '211468684', '1'),
('43', '418209302', '1'),
('43', '436490324', '1'),
('44', '667311057', '1'),
('45', '102495685', '2'),
('46', '165428512', '1'),
('47', '165774859', '1'),
('48', '530219278', '1'),
('49', '553124961', '1'),
('50', '578747125', '1');




-- -----------------------------------------------------
-- Views
-- -----------------------------------------------------

-- This first view contains the purchase details such as 
-- the description which correspond to the book's title,
-- the unit cost (the original price of the book), the quantity of book's copies purchased 
-- and the resultant amount (price*quantity).

create view invoice1 as
select o.order_id as order_id, b.title as `DESCRIPTION`, b.price as `UNIT COST`, 
i.quantity as `QTY/HR RATE`, b.price*i.quantity as AMOUNT
from book b
join order_itens i on i.isbn=b.isbn
join orders o on o.order_id=i.order_id
join `client` c on c.account_id=o.account_id
join location l on l.zipcode=c.zipcode;

-- The second view contains the head and the totals of the INVOICE. Containing client, company and invoice information.
-- Also, it contains the totals of the purchase that will have in detail the subtotal,
-- the discounts, the additional tax rate and its amount and the total amount 
-- that the client has to pay. 

create view invoice2 as
-- invoice information 
select o.order_id as `INVOICE NUMBER`, date(o.date_order) as `DATE OF ISSUE`, 
date_add(date(o.date_order), interval 3 day) as `DUE DATE`,
-- client information
c.client_name as `Client Name`, l.address as `Client Street adress`, 
concat(l.city,', ',l.country) as `City, Country`, l.zipcode as `ZIP code`,
-- company information
'International Online Bookstore' as `Company Name`, 
'77 Clinton St, New York(NY), 13417' as `Company Adress`,
'589-635-4144' as `Company Phone number`, 
'customercare@internationalbookstore.com' as `Company Email`,
'internationalbookstore.com' as `Company website`,
-- invoice subtotal, discount, tax rate and total
i1.subtotal as SUBTOTAL,
round((sum(b.discount)+c.extra_discount)*i1.subtotal,2) as DISCOUNT,
'23%' as `(TAX RATE)`,
round(0.23*i1.subtotal*(1-(sum(b.discount)+c.extra_discount)),2) as TAX,
round(1.23*i1.subtotal*(1-(sum(b.discount)+c.extra_discount)),2) as TOTAL
from book b 
join order_itens i on i.isbn=b.isbn
join orders o on o.order_id=i.order_id
join `client` c on c.account_id=o.account_id
join location l on l.zipcode=c.zipcode
join (select order_id, sum(amount) as subtotal from invoice1 group by order_id) i1 
on i1.order_id=o.order_id
group by o.order_id;

