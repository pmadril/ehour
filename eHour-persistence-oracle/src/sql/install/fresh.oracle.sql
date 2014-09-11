DROP TABLE USER_PREFERENCES;
DROP TABLE CUSTOMER_REVIEWERS;
DROP TABLE CUSTOMER_REPORTERS;
DROP TABLE CUSTOMER_FOLD_PREFERENCE;
DROP TABLE USER_TO_USERROLE;
DROP TABLE USER_ROLE;
DROP TABLE TIMESHEET_ENTRY;
DROP TABLE TIMESHEET_COMMENT;
DROP TABLE APPROVAL_STATUSES;
DROP TABLE ACTIVITIES;
DROP TABLE MAIL_LOG_ASSIGNMENT;
DROP TABLE PROJECT_ASSIGNMENT;
DROP TABLE PROJECT_ASSIGNMENT_TYPE;
DROP TABLE PROJECT;
DROP TABLE MAIL_LOG;
DROP TABLE USERS;
DROP TABLE USER_DEPARTMENT;
DROP TABLE CUSTOMER;
DROP TABLE MAIL_TYPE;
DROP TABLE CONFIGURATION;
DROP TABLE CONFIGURATION_BIN;
DROP TABLE AUDITLOG;

DROP SEQUENCE HIBERNATE_SEQUENCE;

CREATE SEQUENCE SEQ_CUSTOMER_ID START WITH 10;
CREATE SEQUENCE SEQ_MAIL_LOG_ID START WITH 10;
CREATE SEQUENCE SEQ_PROJECT_ID START WITH 10;
CREATE SEQUENCE SEQ_ASSIGNMENT_ID START WITH 10;
CREATE SEQUENCE SEQ_USER_ID START WITH 10;
CREATE SEQUENCE SEQ_DEPARTMENT_ID START WITH 10;
--
-- Single sequence used by all tables
--
CREATE SEQUENCE HIBERNATE_SEQUENCE START WITH 100;


CREATE TABLE AUDITLOG (
	AUDIT_ID INT NOT NULL,
	USER_ID INT default NULL,
	USER_FULLNAME VARCHAR2(256),
	AUDIT_DATE timestamp,
	PAGE VARCHAR2(256),
	ACTION VARCHAR2(256),
	PARAMETERS VARCHAR2(1024),
	SUCCESS char(1) NOT NULL,
	AUDIT_ACTION_TYPE VARCHAR2(32),
    PRIMARY KEY  (AUDIT_ID)
);

CREATE TABLE CONFIGURATION (
  config_key varchar2(255) NOT NULL,
  config_value varchar2(255) default NULL,
  PRIMARY KEY  (config_key)
);

INSERT INTO CONFIGURATION VALUES ('completeDayHours','8.0');
INSERT INTO CONFIGURATION VALUES ('showTurnOver','true');
INSERT INTO CONFIGURATION VALUES ('localeLanguage','en');
INSERT INTO CONFIGURATION VALUES ('localeCountry','EN_NL');
INSERT INTO CONFIGURATION VALUES ('localeCurrency','en_NL');
INSERT INTO CONFIGURATION VALUES ('availableTranslations','en,nl,fr,it');
INSERT INTO CONFIGURATION VALUES ('mailFrom','noreply@localhost.net');
INSERT INTO CONFIGURATION VALUES ('mailSmtp','127.0.0.1');
INSERT INTO CONFIGURATION VALUES ('smtpPort','25');
INSERT INTO CONFIGURATION VALUES ('version', '0.8');
INSERT INTO CONFIGURATION VALUES ('demoMode','false');
INSERT INTO CONFIGURATION VALUES ('initialized','true');
INSERT INTO CONFIGURATION VALUES ('dontForceLanguage','false');
INSERT INTO CONFIGURATION VALUES ('smtpUsername','');
INSERT INTO CONFIGURATION VALUES ('smtpPassword','');
INSERT INTO CONFIGURATION VALUES ('firstDayOfWeek','1.0');

--
-- Table structure for table CONFIGURATION_BIN
--
CREATE TABLE CONFIGURATION_BIN (
  CONFIG_KEY varchar2(255) NOT NULL,
  CONFIG_VALUE BLOB,
  METADATA varchar2(255) default NULL,
  PRIMARY KEY  (config_key)
);


--
-- Table structure for table MAIL_TYPE
--

CREATE TABLE MAIL_TYPE (
  MAIL_TYPE_ID INT NOT NULL,
  MAIL_TYPE varchar2(255) default NULL,
  PRIMARY KEY (MAIL_TYPE_ID)
);

--
-- Table structure for table CUSTOMER
--

CREATE TABLE CUSTOMER (
  CUSTOMER_ID INT NOT NULL, -- auto_increment,
  NAME varchar2(255) NOT NULL,
  DESCRIPTION varchar2(1024) default NULL,
  CODE varchar2(32) NOT NULL,
  ACTIVE char(1) default 'Y' NOT NULL,
  CONSTRAINT CODE$1 UNIQUE(CODE),
  CONSTRAINT CODE_ACTIVE UNIQUE(CODE, ACTIVE),
  PRIMARY KEY (CUSTOMER_ID)
);

--
-- Table structure for table USER_DEPARTMENT
--

CREATE TABLE USER_DEPARTMENT (
  DEPARTMENT_ID INT NOT NULL, -- auto_increment,
  NAME varchar2(512) NOT NULL,
  CODE varchar2(64) NOT NULL,
  PRIMARY KEY  (DEPARTMENT_ID)
);
INSERT INTO USER_DEPARTMENT (DEPARTMENT_ID, NAME, CODE) VALUES (1,'Internal','INT');

--
-- Table structure for table USERS
--

CREATE TABLE USERS (
  USER_ID INT NOT NULL, -- auto_increment,
  USERNAME varchar2(64) NOT NULL,
  PASSWORD varchar2(128),
  FIRST_NAME varchar2(64) default NULL,
  LAST_NAME varchar2(64) NOT NULL,
  DEPARTMENT_ID INT NOT NULL,
  EMAIL varchar2(128) default NULL,
  SALT INT default NULL,
  ACTIVE char(1) default 'Y' NOT NULL,
  PRIMARY KEY  (USER_ID),
  CONSTRAINT USERNAME$1 UNIQUE(USERNAME),
  CONSTRAINT USERNAME_ACTIVE UNIQUE(USERNAME,ACTIVE),
  CONSTRAINT USER_fk FOREIGN KEY (DEPARTMENT_ID) REFERENCES USER_DEPARTMENT (DEPARTMENT_ID)
);
INSERT INTO USERS (USER_ID, USERNAME, PASSWORD, FIRST_NAME, LAST_NAME, DEPARTMENT_ID, SALT, ACTIVE) VALUES 
  (1,'admin','54a728be057d52571ec9f99ef6a9b583d42fd036','eHour','Admin',1,'7135','Y');
--
-- Table structure for table MAIL_LOG
--

CREATE TABLE MAIL_LOG (
  MAIL_LOG_ID INT NOT NULL, -- auto_increment,
  MAIL_TYPE_ID INT NOT NULL,
  TIMESTAMP timestamp NOT NULL,
  SUCCESS char(1) NOT NULL,
  TO_USER_ID INT default NULL,
  RESULT_MSG varchar2(255) default NULL,
  PRIMARY KEY (MAIL_LOG_ID),
  CONSTRAINT MAIL_LOG_fk FOREIGN KEY (MAIL_TYPE_ID) REFERENCES MAIL_TYPE (MAIL_TYPE_ID),
  CONSTRAINT MAIL_LOG_fk1 FOREIGN KEY (TO_USER_ID) REFERENCES USERS (USER_ID)
);

--
-- Table structure for table PROJECT
--

CREATE TABLE PROJECT (
  PROJECT_ID INT NOT NULL, -- auto_increment,
  CUSTOMER_ID INT default NULL,
  NAME varchar2(255) NOT NULL,
  DESCRIPTION varchar2(1024) default NULL,
  CONTACT varchar2(255) default NULL,
  PROJECT_CODE varchar2(32) NOT NULL,
  DEFAULT_PROJECT char(1) default 'N' NOT NULL,
  ACTIVE char(1) default 'Y' NOT NULL ,
  PROJECT_MANAGER INT default NULL,
  BILLABLE char(1) default 'N' NOT NULL,
  PRIMARY KEY  (PROJECT_ID),
  CONSTRAINT PROJECT_CODE$1 UNIQUE(PROJECT_CODE),
  CONSTRAINT PROJECT_CODE_ACTIVE UNIQUE(PROJECT_CODE,ACTIVE),  
  CONSTRAINT PROJECT_fk FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER (CUSTOMER_ID),
  CONSTRAINT PROJECT_fk1 FOREIGN KEY (PROJECT_MANAGER) REFERENCES USERS (USER_ID)
);

--
-- Table structure for table PROJECT_ASSIGNMENT_TYPE
--

CREATE TABLE PROJECT_ASSIGNMENT_TYPE (
  ASSIGNMENT_TYPE_ID INT NOT NULL,
  ASSIGNMENT_TYPE varchar2(64) default NULL,
  PRIMARY KEY  (ASSIGNMENT_TYPE_ID)
);


--
-- Table structure for table PROJECT_ASSIGNMENT
--

CREATE TABLE PROJECT_ASSIGNMENT (
  ASSIGNMENT_ID INT NOT NULL, -- auto_increment,
  PROJECT_ID INT NOT NULL,
  HOURLY_RATE float(9) default NULL,
  DATE_START timestamp default NULL,
  DATE_END timestamp default NULL,
  ROLE varchar2(255) default NULL,
  USER_ID INT NOT NULL,
  ACTIVE char(1) default 'Y' NOT NULL,
  ASSIGNMENT_TYPE_ID INT NOT NULL,
  ALLOTTED_HOURS float(9) default NULL,
  ALLOTTED_HOURS_OVERRUN float(9) default NULL,
  NOTIFY_PM_ON_OVERRUN char(1) default 'N' NOT NULL,
  PRIMARY KEY  (ASSIGNMENT_ID),
  CONSTRAINT PROJECT_ASSIGNMENT_fk2 FOREIGN KEY (ASSIGNMENT_TYPE_ID) REFERENCES PROJECT_ASSIGNMENT_TYPE (ASSIGNMENT_TYPE_ID),
  CONSTRAINT PROJECT_ASSIGNMENT_fk FOREIGN KEY (PROJECT_ID) REFERENCES PROJECT (PROJECT_ID),
  CONSTRAINT PROJECT_ASSIGNMENT_fk1 FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID)
);

--
-- Table structure for table MAIL_LOG_ASSIGNMENT
--

CREATE TABLE MAIL_LOG_ASSIGNMENT (
  MAIL_LOG_ID INT NOT NULL,
  PROJECT_ASSIGNMENT_ID INT NOT NULL,
  BOOKED_HOURS float(9) default NULL,
  BOOK_DATE timestamp default NULL,
  CONSTRAINT MAIL_LOG_ASSIGNMENT_fk FOREIGN KEY (MAIL_LOG_ID) REFERENCES MAIL_LOG (MAIL_LOG_ID),
  CONSTRAINT MAIL_LOG_ASSIGNMENT_fk1 FOREIGN KEY (PROJECT_ASSIGNMENT_ID) REFERENCES PROJECT_ASSIGNMENT (ASSIGNMENT_ID)
);

INSERT INTO MAIL_TYPE VALUES (SEQ_MAIL_LOG_ID.nextval,'FIXED_ALLOTTED_REACHED');
INSERT INTO MAIL_TYPE VALUES (SEQ_MAIL_LOG_ID.nextval,'FLEX_ALLOTTED_REACHED');
INSERT INTO MAIL_TYPE VALUES (SEQ_MAIL_LOG_ID.nextval,'FLEX_OVERRUN_REACHED');

--
-- Dumping data for table PROJECT_ASSIGNMENT_TYPE
--

INSERT INTO PROJECT_ASSIGNMENT_TYPE VALUES (0,'DATE_TYPE');
INSERT INTO PROJECT_ASSIGNMENT_TYPE VALUES (2,'TIME_ALLOTTED_FIXED');
INSERT INTO PROJECT_ASSIGNMENT_TYPE VALUES (3,'TIME_ALLOTTED_FLEX');

--
-- Table structure for table TIMESHEET_COMMENT
--

CREATE TABLE TIMESHEET_COMMENT (
  USER_ID INT NOT NULL,
  COMMENT_DATE timestamp NOT NULL,
  COMMENT_TEXT varchar2(2048) default NULL,
  CONSTRAINT comment_pk PRIMARY KEY  (COMMENT_DATE,USER_ID)
);

--
-- Table structure for table ACTIVITIES
--

CREATE TABLE ACTIVITIES (
  ACTIVITY_ID INT NOT NULL,
  CODE varchar2(32) NOT NULL,
  NAME varchar2(255) NOT NULL,
  DATE_START timestamp default NULL,
  DATE_END timestamp default NULL,
  ALLOTTED_HOURS float(9) NOT NULL,
  ACTIVE char(1) DEFAULT 'Y' NOT NULL,
  LOCKED char(1) DEFAULT 'Y' NOT NULL,
  PROJECT_ID INT NOT NULL,
  USER_ID INT NOT NULL,
  CONSTRAINT ACTIVITY_CODE$1 UNIQUE(CODE),
  CONSTRAINT ACTIVITY_CODE_ACTIVE UNIQUE(CODE,ACTIVE),    
  CONSTRAINT ACTIVITY_ID_PK PRIMARY KEY (ACTIVITY_ID),
  CONSTRAINT ACTIVITY_fk1 FOREIGN KEY (PROJECT_ID) REFERENCES PROJECT (PROJECT_ID),
  CONSTRAINT ACTIVITY_fk2 FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID)    
); 

--
-- Table structure for table TIMESHEET_ENTRY
--


CREATE TABLE TIMESHEET_ENTRY (
  ACTIVITY_ID INT NOT NULL,
  ENTRY_DATE timestamp NOT NULL,
  UPDATE_DATE TIMESTAMP,  
  HOURS float(9),
  COMMENT_TEXT varchar2(2048),
  CONSTRAINT entry_pk PRIMARY KEY(ENTRY_DATE,ACTIVITY_ID),
  CONSTRAINT TIMESHEET_ENTRY_fk FOREIGN KEY (ACTIVITY_ID) REFERENCES ACTIVITIES (ACTIVITY_ID)
);



--
-- Table structure for table USER_ROLE
--

CREATE TABLE USER_ROLE (
  ROLE varchar2(128) NOT NULL,
  NAME varchar2(128) NOT NULL,
  CONSTRAINT role_pk PRIMARY KEY  (ROLE)
);


--
-- Dumping data for table USER_ROLE
--


INSERT INTO USER_ROLE VALUES ('ROLE_ADMIN','Administrator');
INSERT INTO USER_ROLE VALUES ('ROLE_CONSULTANT','Consultant');
INSERT INTO USER_ROLE VALUES ('ROLE_PROJECTMANAGER','PM');
INSERT INTO USER_ROLE VALUES ('ROLE_REPORT','Report role');
INSERT INTO USER_ROLE VALUES ('ROLE_CUSTOMERREVIEWER','Customer Reviewer');
INSERT INTO USER_ROLE VALUES ('ROLE_CUSTOMERREPORTER','Customer Reporter');


--
-- Table structure for table USER_TO_USERROLE
--

CREATE TABLE USER_TO_USERROLE (
  ROLE varchar2(128) NOT NULL,
  USER_ID INT NOT NULL,
  CONSTRAINT userrole_pk PRIMARY KEY  (ROLE,USER_ID),
  CONSTRAINT USER_TO_USERROLE_fk FOREIGN KEY (ROLE) REFERENCES USER_ROLE (ROLE),
  CONSTRAINT USER_TO_USERROLE_fk1 FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID)
);

--
-- Dumping data for table USER_TO_USERROLE
--

INSERT INTO USER_TO_USERROLE (ROLE, USER_ID) VALUES ('ROLE_ADMIN',1);
INSERT INTO USER_TO_USERROLE (ROLE, USER_ID) VALUES ('ROLE_REPORT',1);

CREATE TABLE CUSTOMER_FOLD_PREFERENCE (
  CUSTOMER_ID INT NOT NULL,
  USER_ID INT NOT NULL,
  FOLDED char(1) default 'N' NOT NULL,
  CONSTRAINT reference_pk PRIMARY KEY  (CUSTOMER_ID,USER_ID)
);

--
-- Structure for table CUSTOMER_REVIEWERS
--
CREATE TABLE CUSTOMER_REVIEWERS (
  USER_ID INT NOT NULL,
  CUSTOMER_ID INT NOT NULL,
  CONSTRAINT CUSTOMER_REVIEWERS_PK PRIMARY KEY (USER_ID, CUSTOMER_ID),
  CONSTRAINT CUSTOMER_REVIEWERS_fk1 FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID),
  CONSTRAINT CUSTOMER_REVIEWERS_fk2 FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER (CUSTOMER_ID)  
);

--
-- Structure for table CUSTOMER_REPORTERS
--
CREATE TABLE CUSTOMER_REPORTERS (
  USER_ID INT NOT NULL,
  CUSTOMER_ID INT NOT NULL,
  CONSTRAINT CUSTOMER_REPORTERS_PK PRIMARY KEY (USER_ID,CUSTOMER_ID),
  CONSTRAINT CUSTOMER_REPORTERS_fk1 FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID),
  CONSTRAINT CUSTOMER_REPORTERS_fk2 FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER (CUSTOMER_ID)  
);

CREATE TABLE APPROVAL_STATUSES (
  APPROVALSTATUS_ID NUMBER NOT NULL,
  DATE_START timestamp default NULL,
  DATE_END timestamp default NULL,
  CUSTOMER_ID NUMBER NOT NULL,
  USER_ID NUMBER NOT NULL,
  STATUS varchar2(128) NOT NULL,
  COMMENT_TEXT varchar2(2048) default NULL,
  PRIMARY KEY  (APPROVALSTATUS_ID),  
  CONSTRAINT APPROVAL_STATUSES_fk1 FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER (CUSTOMER_ID),
  CONSTRAINT APPROVAL_STATUSES_fk2 FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID)  
);

CREATE TABLE USER_PREFERENCES (
  USER_ID INT NOT NULL,
  USER_PREFERENCE_KEY varchar2(255) NOT NULL,
  USER_PREFERENCE_VALUE varchar2(255) default NULL,
  CONSTRAINT USER_PREFENCES_PK PRIMARY KEY(USER_ID,USER_PREFERENCE_KEY),
  CONSTRAINT USER_PREFERENCES_fk FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID)
);

commit;
