ALTER TABLE PROJECT ADD PROJECT_MANAGER int(11) DEFAULT NULL;
CREATE INDEX PROJECT_FK1 ON PROJECT (`PROJECT_MANAGER`);
ALTER TABLE PROJECT ADD CONSTRAINT  `PROJECT_fk1` FOREIGN KEY (`PROJECT_MANAGER`) REFERENCES `USER` (`USER_ID`);

INSERT INTO `CONFIGURATION` VALUES ('mailFrom','noreply@localhost.net'),('mailSmtp','127.0.0.1');

--
-- Table structure for table `MAIL_TYPE`
--

DROP TABLE IF EXISTS `MAIL_TYPE`;
CREATE TABLE `MAIL_TYPE` (
  `MAIL_TYPE_ID` int(11) NOT NULL,
  `MAIL_TYPE` varchar(255) default NULL,
  PRIMARY KEY  (`MAIL_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `MAIL_TYPE`
--

LOCK TABLES `MAIL_TYPE` WRITE;
/*!40000 ALTER TABLE `MAIL_TYPE` DISABLE KEYS */;
INSERT INTO `MAIL_TYPE` VALUES (1,'FIXED_ALLOTTED_REACHED'),(2,'FLEX_ALLOTTED_REACHED'),(3,'FLEX_OVERRUN_REACHED');
/*!40000 ALTER TABLE `MAIL_TYPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MAIL_LOG`
--

DROP TABLE IF EXISTS `MAIL_LOG`;
CREATE TABLE `MAIL_LOG` (
  `MAIL_LOG_ID` int(11) NOT NULL auto_increment,
  `MAIL_TYPE_ID` int(11) NOT NULL,
  `TIMESTAMP` datetime NOT NULL,
  `SUCCESS` char(1) NOT NULL,
  `TO_USER_ID` int(11) default NULL,
  `RESULT_MSG` varchar(255) default NULL,
  PRIMARY KEY  (`MAIL_LOG_ID`),
  UNIQUE KEY `MAIL_LOG_ID` (`MAIL_LOG_ID`),
  KEY `MAIL_TYPE_ID` (`MAIL_TYPE_ID`),
  KEY `TO_USER_ID` (`TO_USER_ID`),
  CONSTRAINT `MAIL_LOG_fk` FOREIGN KEY (`MAIL_TYPE_ID`) REFERENCES `MAIL_TYPE` (`MAIL_TYPE_ID`),
  CONSTRAINT `MAIL_LOG_fk1` FOREIGN KEY (`TO_USER_ID`) REFERENCES `USER` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `MAIL_LOG_ASSIGNMENT`
--

DROP TABLE IF EXISTS `MAIL_LOG_ASSIGNMENT`;
CREATE TABLE `MAIL_LOG_ASSIGNMENT` (
  `MAIL_LOG_ID` int(11) NOT NULL,
  `PROJECT_ASSIGNMENT_ID` int(11) NOT NULL,
  `BOOKED_HOURS` float(9,3) default NULL,
  `BOOK_DATE` datetime default NULL,
  PRIMARY KEY  (`MAIL_LOG_ID`),
  UNIQUE KEY `MAIL_LOG_ID` (`MAIL_LOG_ID`),
  KEY `PROJECT_ASSIGNMENT_ID` (`PROJECT_ASSIGNMENT_ID`),
  CONSTRAINT `MAIL_LOG_ASSIGNMENT_fk` FOREIGN KEY (`MAIL_LOG_ID`) REFERENCES `MAIL_LOG` (`MAIL_LOG_ID`),
  CONSTRAINT `MAIL_LOG_ASSIGNMENT_fk1` FOREIGN KEY (`PROJECT_ASSIGNMENT_ID`) REFERENCES `PROJECT_ASSIGNMENT` (`ASSIGNMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `PROJECT_ASSIGNMENT_TYPE`
--

DROP TABLE IF EXISTS `PROJECT_ASSIGNMENT_TYPE`;
CREATE TABLE `PROJECT_ASSIGNMENT_TYPE` (
  `ASSIGNMENT_TYPE_ID` int(11) NOT NULL,
  `ASSIGNMENT_TYPE` varchar(64) default NULL,
  PRIMARY KEY  (`ASSIGNMENT_TYPE_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


--
-- Dumping data for table `PROJECT_ASSIGNMENT_TYPE`
--

LOCK TABLES `PROJECT_ASSIGNMENT_TYPE` WRITE;
/*!40000 ALTER TABLE `PROJECT_ASSIGNMENT_TYPE` DISABLE KEYS */;
INSERT INTO `PROJECT_ASSIGNMENT_TYPE` VALUES (0,'DATE_TYPE'),(2,'TIME_ALLOTTED_FIXED'),(3,'TIME_ALLOTTED_FLEX');
/*!40000 ALTER TABLE `PROJECT_ASSIGNMENT_TYPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROJECT_ASSIGNMENT_TYPE`
--

DROP TABLE IF EXISTS `PROJECT_ASSIGNMENT_TYPE`;
CREATE TABLE `PROJECT_ASSIGNMENT_TYPE` (
  `ASSIGNMENT_TYPE_ID` int(11) NOT NULL,
  `ASSIGNMENT_TYPE` varchar(64) default NULL,
  PRIMARY KEY  (`ASSIGNMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `PROJECT_ASSIGNMENT_TYPE`
--

LOCK TABLES `PROJECT_ASSIGNMENT_TYPE` WRITE;
/*!40000 ALTER TABLE `PROJECT_ASSIGNMENT_TYPE` DISABLE KEYS */;
INSERT INTO `PROJECT_ASSIGNMENT_TYPE` VALUES (0,'DATE_TYPE'),(2,'TIME_ALLOTTED_FIXED'),(3,'TIME_ALLOTTED_FLEX');
/*!40000 ALTER TABLE `PROJECT_ASSIGNMENT_TYPE` ENABLE KEYS */;
UNLOCK TABLES;

-- Modify PROJECT_ASSIGNMENT
ALTER TABLE PROJECT_ASSIGNMENT ADD `ALLOTTED_HOURS` float(9,3) default NULL;
ALTER TABLE PROJECT_ASSIGNMENT ADD `ALLOTTED_HOURS_OVERRUN` float(9,3) default NULL;
ALTER TABLE PROJECT_ASSIGNMENT ADD `NOTIFY_PM_ON_OVERRUN` char(1) NOT NULL default 'N';
ALTER TABLE PROJECT_ASSIGNMENT ADD `ASSIGNMENT_TYPE_ID` int(11) NOT NULl;
UPDATE PROJECT_ASSIGNMENT SET ASSIGNMENT_TYPE_ID = 0;
ALTER TABLE PROJECT_ASSIGNMENT DROP DEFAULT_ASSIGNMENT;
CREATE INDEX PROJECT_ASG1 ON PROJECT_ASSIGNMENT (ASSIGNMENT_TYPE_ID);
ALTER TABLE PROJECT_ASSIGNMENT ADD CONSTRAINT `PROJECT_ASSIGNMENT_fk2` FOREIGN KEY (`ASSIGNMENT_TYPE_ID`) REFERENCES `PROJECT_ASSIGNMENT_TYPE` (`ASSIGNMENT_TYPE_ID`);

-- Insert the new PM role
INSERT INTO `USER_ROLE` VALUES ('ROLE_PROJECTMANAGER','PM');
