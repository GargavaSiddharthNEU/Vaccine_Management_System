SET SERVEROUTPUT ON;

--PL/SQL BLOCK FOR TABLE CREATION
declare
    is_true number;
begin
    select count(*) 
    INTO IS_TRUE
    from user_tables where table_name='VACCINE_RECORD';
    IF IS_TRUE > 0
    THEN
    EXECUTE IMMEDIATE 'DROP TABLE VACCINE_RECORD';
    END IF;
END;
/

declare
    is_true number;
begin
    select count(*) 
    INTO IS_TRUE
    from user_tables where table_name='REGISTRATION';
    IF IS_TRUE > 0
    THEN
    EXECUTE IMMEDIATE 'DROP TABLE REGISTRATION';
    END IF;
END;
/



declare
    is_true number;
begin
    select count(*) 
    INTO IS_TRUE
    from user_tables where table_name='MEDICAL_WORKER';
    IF IS_TRUE > 0
    THEN
    EXECUTE IMMEDIATE 'DROP TABLE MEDICAL_WORKER';
    END IF;
END;
/

declare
    is_true number;
begin
    select count(*) 
    INTO IS_TRUE
    from user_tables where table_name='VACCINE_DETAILS';
    IF IS_TRUE > 0
    THEN
    EXECUTE IMMEDIATE 'DROP TABLE VACCINE_DETAILS';
    END IF;
END;
/

declare
    is_true number;
begin
    select count(*) 
    INTO IS_TRUE
    from user_tables where table_name='HOSPITAL';
    IF IS_TRUE > 0
    THEN
    EXECUTE IMMEDIATE 'DROP TABLE HOSPITAL';
    END IF;
END;
/


declare
    is_true number;
begin
    select count(*) 
    INTO IS_TRUE
    from user_tables where table_name='RECIPIENT';
    IF IS_TRUE > 0
    THEN
    EXECUTE IMMEDIATE 'DROP TABLE RECIPIENT';
    END IF;
END;
/

declare
    is_true number;
begin
    select count(*) 
    INTO IS_TRUE
    from user_tables where table_name='AUDIT_LOG';
    IF IS_TRUE > 0
    THEN
    EXECUTE IMMEDIATE 'DROP TABLE AUDIT_LOG';
    END IF;
END;
/

CREATE TABLE RECIPIENT(
RECIPIENT_ID NUMBER CONSTRAINT RECIPIENT_PK PRIMARY KEY,
FIRST_NAME VARCHAR(90),
LAST_NAME VARCHAR(90),
DATE_OF_BIRTH DATE NOT NULL,
CONTACT_NUMBER NUMBER NOT NULL CONSTRAINT CONTACT_RECIPIENT_UNQ UNIQUE,
STREET_ADDRESS VARCHAR(120), 
CITY VARCHAR(50) NOT NULL,
ZIPCODE VARCHAR(10) NOT NULL,
GENDER VARCHAR(30) CONSTRAINT GENDER_RECIPIENT_CHECK CHECK(GENDER IN ('MALE','FEMALE','OTHER')),
AGE_ELIGIBILITY VARCHAR(50)
);

CREATE TABLE Audit_log( 
AUDIT_LOG_ID NUMBER CONSTRAINT AUDIT_LOG_PK PRIMARY KEY, 
LOG_DESCRIPTION VARCHAR(150) NOT NULL, 
OPERATION_TYPE VARCHAR(15),
RECIPIENT_ID NUMBER,
TIME_STAMP TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE HOSPITAL(
HOSPITAL_ID NUMBER CONSTRAINT HOSPITAL_PK PRIMARY KEY,
HOSPITAL_NAME VARCHAR(90) NOT NULL,
HOSPITAL_STREET_ADDRESS VARCHAR(120),
CITY VARCHAR(50) NOT NULL,
ZIPCODE VARCHAR(10) NOT NULL,
HOSPITAL_CONTACT NUMBER NOT NULL CONSTRAINT HOSPITAL_CONTACT_UNQ UNIQUE,
HOSPITAL_LICENSE_NUMBER VARCHAR(50) NOT NULL CONSTRAINT HOSPITAL_LICENSE_UNQ UNIQUE
);


CREATE TABLE VACCINE_DETAILS(
VACCINE_ID NUMBER CONSTRAINT VACCINE_ID_PK PRIMARY KEY,
VACCINE_NAME VARCHAR(120) NOT NULL,
VIAL_SIZE NUMBER CONSTRAINT VIAL_SIZE_CHECK CHECK(VIAL_SIZE IN (10, 20, 30)),
LOT_ID VARCHAR(20) NOT NULL CONSTRAINT LOT_ID_UNQ UNIQUE,
MANUFACTURED_DATE DATE NOT NULL,
EXPIRY_DATE DATE NOT NULL,
QUANTITY NUMBER NOT NULL,
VACCINE_PRICE NUMBER NOT NULL
);

CREATE TABLE MEDICAL_WORKER(
MEDICAL_WORKER_ID NUMBER CONSTRAINT MEDICAL_WORKER_PK PRIMARY KEY,
FIRST_NAME VARCHAR(90),
LAST_NAME VARCHAR(90),
CONTACT_NUMBER NUMBER NOT NULL CONSTRAINT CONTACT_MEDICAL_WORKER_UNQ UNIQUE,
STREET_ADDRESS VARCHAR(120),
CITY VARCHAR(50) NOT NULL,
ZIPCODE VARCHAR(10) NOT NULL,
GENDER VARCHAR(30) CONSTRAINT GENDER_MEDICAL_WORKER_CHECK CHECK(GENDER IN ('MALE','FEMALE','OTHER')),
EMAIL_ID VARCHAR(40),
HOSPITAL_ID NUMBER NOT NULL CONSTRAINT HOSPITAL_ID_FK REFERENCES HOSPITAL(HOSPITAL_ID) ON DELETE CASCADE
);

CREATE TABLE REGISTRATION( 
REGISTRATION_ID NUMBER CONSTRAINT REGISTRATION_PK PRIMARY KEY, 
RECIPIENT_ID NUMBER NOT NULL CONSTRAINT RECIPIENT_ID_FK REFERENCES RECIPIENT(RECIPIENT_ID) ON DELETE CASCADE, 
USERNAME VARCHAR(20) NOT NULL CONSTRAINT USERNAME_UNQ UNIQUE, 
PASS_WORD VARCHAR(50) NOT NULL, 
EMAIL_ID VARCHAR(50) NOT NULL, 
LAST_VACCINATION_DATE DATE, 
PAYMENT_TIMESTAMP TIMESTAMP NOT NULL, 
PAYMENT_AMOUNT NUMBER NOT NULL, 
TRANSACTION_ID VARCHAR(20) NOT NULL CONSTRAINT TRANSACTION_ID_UNQ UNIQUE, 
PAYMENT_TYPE VARCHAR(20) CONSTRAINT PAYMENT_TYPE_CHECK CHECK(PAYMENT_TYPE IN ('CARD','CASH')) 
);

CREATE TABLE VACCINE_RECORD( 
VACCINE_RECORD_ID NUMBER CONSTRAINT VACCINE_RECORD_PK PRIMARY KEY, 
START_TIME TIMESTAMP NOT NULL, 
END_TIME TIMESTAMP NOT NULL, 
VACCINE_RECORD_DATE DATE DEFAULT SYSDATE, 
REMARKS VARCHAR(150), 
MEDICAL_WORKER_ID NUMBER NOT NULL CONSTRAINT MEDICAL_WORKER_ID_FK REFERENCES MEDICAL_WORKER(MEDICAL_WORKER_ID) ON DELETE CASCADE, 
REGISTRATION_ID NUMBER NOT NULL CONSTRAINT REGISTRATION_ID_FK REFERENCES REGISTRATION(REGISTRATION_ID) ON DELETE CASCADE, 
VACCINE_ID NUMBER NOT NULL CONSTRAINT VACCINE_ID_FK REFERENCES VACCINE_DETAILS(VACCINE_ID) ON DELETE CASCADE 
);

-- GRANTS on TABLES and OBJECTS
GRANT SELECT,INSERT ON REGISTRATION TO RECIPIENT;
GRANT SELECT ON VACCINE_RECORD TO RECIPIENT;
GRANT SELECT ON VACCINE_DETAILS TO RECIPIENT;

GRANT SELECT, INSERT, UPDATE, DELETE ON MEDICAL_WORKER TO HOSPITAL_ADMIN;
GRANT SELECT ON VACCINE_DETAILS TO HOSPITAL_ADMIN;
GRANT SELECT ON VACCINE_RECORD TO HOSPITAL_ADMIN;
GRANT SELECT ON REGISTRATION TO HOSPITAL_ADMIN;

GRANT SELECT, INSERT, UPDATE, DELETE ON VACCINE_RECORD TO MEDICAL_WORKER;
GRANT SELECT ON VACCINE_DETAILS TO MEDICAL_WORKER;
GRANT SELECT ON REGISTRATION TO MEDICAL_WORKER;

GRANT EXECUTE ON PKG_DELETE_RECORDS_HOSPITAL_ADMIN TO HOSPITAL_ADMIN;
GRANT EXECUTE ON PKG_DELETE_MEDICAL_WORKER TO MEDICAL_WORKER;
GRANT EXECUTE ON PKG_DELETE_RECORDS_RECIEPIENT TO RECIPIENT;

GRANT EXECUTE ON PKG_ONBOARD_MEDICAL_WORKER TO HOSPITAL_ADMIN;
GRANT EXECUTE ON PKG_ONBOARD_VACCINE_REC TO MEDICAL_WORKER;
GRANT EXECUTE ON PACKAGE_ONBOARD_RECIPIENT TO RECIPIENT;

GRANT EXECUTE on "APP_ADMIN"."LOGIN_CHECK" to "RECIPIENT" ;

GRANT INDEX ON REGISTRATION TO APP_ADMIN;
GRANT INDEX ON REGISTRATION TO RECIPIENT;

GRANT EXECUTE ON APP_ADMIN.GET_VAXX_PRICE TO RECIPIENT;

--TRIGGER AGE_ELIGIBILITY
CREATE OR REPLACE TRIGGER ELIGIBILITYVALIDATION 
BEFORE INSERT ON RECIPIENT 
FOR EACH ROW
BEGIN
 IF 
 MONTHS_BETWEEN(SYSDATE,:NEW.DATE_OF_BIRTH) < 144 THEN :NEW.AGE_ELIGIBILITY := 'NOT ELIGIBLE';
 ELSE 
 :NEW.AGE_ELIGIBILITY := 'ELIGIBLE';
 END IF;
END;
/

--SEQUENCE GENERATION FOR AUDIT_LOG TABLE
DROP SEQUENCE  APP_ADMIN.EVALUATIONS_SEQUENCE;

CREATE SEQUENCE "APP_ADMIN"."EVALUATIONS_SEQUENCE" 
MINVALUE 1 
MAXVALUE 8000000000 
INCREMENT BY 1 
START WITH 1 
CACHE 20 
ORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;

--TRIGGER AUDIT_LOG
create or replace TRIGGER AUDIT_LOG 
BEFORE INSERT OR UPDATE OR DELETE ON RECIPIENT
REFERENCING OLD AS OLD NEW AS NEW 
FOR EACH ROW
DECLARE 
 message varchar2(10000);
BEGIN
 IF DELETING THEN
 message := 'Deleted Recipient with Recipient ID ' || :OLD.Recipient_ID;
 INSERT INTO AUDIT_LOG(AUDIT_LOG_ID,LOG_DESCRIPTION,OPERATION_TYPE,RECIPIENT_ID)
 VALUES(evaluations_sequence.nextval,message,'DELETE',:OLD.RECIPIENT_ID);
 END IF;
 IF INSERTING THEN
 message := 'Added Recipient with Recipient ID ' || :NEW.Recipient_ID;
 INSERT INTO AUDIT_LOG(AUDIT_LOG_ID,LOG_DESCRIPTION,OPERATION_TYPE,RECIPIENT_ID)
 VALUES(evaluations_sequence.nextval,message,'INSERT',:NEW.RECIPIENT_ID);
 END IF;
 
 IF UPDATING ('FIRST_NAME') THEN 
 message := 'Updating First Name from ' || :OLD.FIRST_NAME || ' to ' || :NEW.FIRST_NAME;
 INSERT INTO AUDIT_LOG(AUDIT_LOG_ID,LOG_DESCRIPTION,OPERATION_TYPE,RECIPIENT_ID)
 VALUES(evaluations_sequence.nextval,message,'UPDATE',:OLD.RECIPIENT_ID);
 END IF;
 IF UPDATING ('LAST_NAME') THEN 
 message := 'Updating LAST Name from ' || :OLD.LAST_NAME || ' to ' || :NEW.LAST_NAME;
 INSERT INTO AUDIT_LOG(AUDIT_LOG_ID,LOG_DESCRIPTION,OPERATION_TYPE,RECIPIENT_ID)
 VALUES(evaluations_sequence.nextval,message,'UPDATE',:OLD.RECIPIENT_ID);
 END IF;
 IF UPDATING ('DATE_OF_BIRTH') THEN 
 message := 'Updating Date of Birth from ' || :OLD.DATE_OF_BIRTH || ' to ' || :NEW.DATE_OF_BIRTH;
 INSERT INTO AUDIT_LOG(AUDIT_LOG_ID,LOG_DESCRIPTION,OPERATION_TYPE,RECIPIENT_ID)
 VALUES(evaluations_sequence.nextval,message,'UPDATE',:OLD.RECIPIENT_ID);
 END IF;
 IF UPDATING ('CONTACT_NUMBER') THEN 
 message := 'Updating CONTACT NUMBER from ' || :OLD.CONTACT_NUMBER || ' to ' || :NEW.CONTACT_NUMBER;
 INSERT INTO AUDIT_LOG(AUDIT_LOG_ID,LOG_DESCRIPTION,OPERATION_TYPE,RECIPIENT_ID)
 VALUES(evaluations_sequence.nextval,message,'UPDATE',:OLD.RECIPIENT_ID);
 END IF;
 IF UPDATING ('STREET_ADDRESS') THEN 
 message := 'Updating STREET ADDRESS from ' || :OLD.STREET_ADDRESS || ' to ' || :NEW.STREET_ADDRESS;
 INSERT INTO AUDIT_LOG(AUDIT_LOG_ID,LOG_DESCRIPTION,OPERATION_TYPE,RECIPIENT_ID)
 VALUES(evaluations_sequence.nextval,message,'UPDATE',:OLD.RECIPIENT_ID);
 END IF;
 IF UPDATING ('CITY') THEN 
 message := 'Updating CITY from ' || :OLD.CITY || ' to ' || :NEW.CITY;
 INSERT INTO AUDIT_LOG(AUDIT_LOG_ID,LOG_DESCRIPTION,OPERATION_TYPE,RECIPIENT_ID)
 VALUES(evaluations_sequence.nextval,message,'UPDATE',:OLD.RECIPIENT_ID);
 END IF;
 IF UPDATING ('ZIPCODE') THEN 
 message := 'Updating ZIP CODE from ' || :OLD.ZIPCODE || ' to ' || :NEW.ZIPCODE;
 INSERT INTO AUDIT_LOG(AUDIT_LOG_ID,LOG_DESCRIPTION,OPERATION_TYPE,RECIPIENT_ID)
 VALUES(evaluations_sequence.nextval,message,'UPDATE',:OLD.RECIPIENT_ID);
 END IF;
 IF UPDATING ('GENDER') THEN 
 message := 'Updating GENDER from ' || :OLD.GENDER || ' to ' || :NEW.GENDER;
 INSERT INTO AUDIT_LOG(AUDIT_LOG_ID,LOG_DESCRIPTION,OPERATION_TYPE,RECIPIENT_ID)
 VALUES(evaluations_sequence.nextval,message,'UPDATE',:OLD.RECIPIENT_ID);
 END IF;
END;
/

--DML INSERTION FOR APP_ADMIN
--TEST CASES FOR INSERT FOR RECIPIENT

INSERT INTO RECIPIENT(RECIPIENT_ID,FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,CONTACT_NUMBER,STREET_ADDRESS,CITY,ZIPCODE,GENDER)
VALUES(122,'HELEN','SMITH','23-OCT-1990',6162844342,'235 HUNTINGTON AVE','BOSTON','02115','FEMALE');

INSERT INTO RECIPIENT(RECIPIENT_ID,FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,CONTACT_NUMBER,STREET_ADDRESS,CITY,ZIPCODE,GENDER)
VALUES(108,'ALEX','CHEN','07-NOV-1990',7769971678,'379 ARCHER ROAD','MATTAPAN','02124','MALE');

INSERT INTO RECIPIENT(RECIPIENT_ID,FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,CONTACT_NUMBER,STREET_ADDRESS,CITY,ZIPCODE,GENDER)
VALUES(110,'ELLEN','LEN','20-MAR-2003',6132344890,'1295 RARITAN ROAD','CLARK','07066','OTHER');

INSERT INTO RECIPIENT(RECIPIENT_ID,FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,CONTACT_NUMBER,STREET_ADDRESS,CITY,ZIPCODE,GENDER)
VALUES(121,'RAHA','AHMED','30-NOV-1965',4134500761,'1595 CLAY STREET','LOS ANGELES','94612','OTHER');

INSERT INTO RECIPIENT(RECIPIENT_ID,FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,CONTACT_NUMBER,STREET_ADDRESS,CITY,ZIPCODE,GENDER)
VALUES(111,'LOVELINA','DCRUZ','30-AUG-1989',3134561761,'125 CLAY STREET','LOS ANGELES','94612','FEMALE');


--TEST CASES FOR INSERT FOR VACCINE_DETAILS

INSERT INTO VACCINE_DETAILS (VACCINE_ID,VACCINE_NAME,VIAL_SIZE,LOT_ID,MANUFACTURED_DATE,EXPIRY_DATE,QUANTITY,VACCINE_PRICE) 
VALUES(304,'JJ',20,'LOT6998','08-AUG-2021','06-NOV-2023',90,15);

INSERT INTO VACCINE_DETAILS (VACCINE_ID,VACCINE_NAME,VIAL_SIZE,LOT_ID,MANUFACTURED_DATE,EXPIRY_DATE,QUANTITY,VACCINE_PRICE) 
VALUES(307,'COVAXIN',10,'LOT6567','07-JUN-2022','05-SEP-2023',100,20);
 
INSERT INTO VACCINE_DETAILS (VACCINE_ID,VACCINE_NAME,VIAL_SIZE,LOT_ID,MANUFACTURED_DATE,EXPIRY_DATE,QUANTITY,VACCINE_PRICE) 
VALUES(308,'EU-COVIN',30,'LOT0234','21-NOV-2021','19-AUG-2023',97,15);

INSERT INTO VACCINE_DETAILS (VACCINE_ID,VACCINE_NAME,VIAL_SIZE,LOT_ID,MANUFACTURED_DATE,EXPIRY_DATE,QUANTITY,VACCINE_PRICE) 
VALUES(309,'SPUTNIK',10,'LOT5423','17-JAN-2022','06-FEB-2022',90,15);


--TEST CASES FOR INSERT FOR HOSPITAL

INSERT INTO HOSPITAL (HOSPITAL_ID,HOSPITAL_NAME,HOSPITAL_STREET_ADDRESS,CITY,ZIPCODE,HOSPITAL_CONTACT,HOSPITAL_LICENSE_NUMBER) 
VALUES (1104,'APEX HOSPITAL','249 FORSYTH STREET','BOSTON','02119',4156882234,'BOS12045HOSP');

INSERT INTO HOSPITAL (HOSPITAL_ID,HOSPITAL_NAME,HOSPITAL_STREET_ADDRESS,CITY,ZIPCODE,HOSPITAL_CONTACT,HOSPITAL_LICENSE_NUMBER) 
VALUES (1105,'LOTUS GENERAL HOSPITAL','1310 COMMONS DRIVE','SPRINGFIELD','60134',3167433567,'SPR3425HOSP');

INSERT INTO HOSPITAL (HOSPITAL_ID,HOSPITAL_NAME,HOSPITAL_STREET_ADDRESS,CITY,ZIPCODE,HOSPITAL_CONTACT,HOSPITAL_LICENSE_NUMBER) 
VALUES (1108,'LA HOSPITAL','6245 DEPRE AVE','LOS ANGELES','90023',6187090708,'LAD2908HOSP');

INSERT INTO HOSPITAL (HOSPITAL_ID,HOSPITAL_NAME,HOSPITAL_STREET_ADDRESS,CITY,ZIPCODE,HOSPITAL_CONTACT,HOSPITAL_LICENSE_NUMBER) 
VALUES (1109,'DC HOSPITAL','23RD STREET','WASHINGTON DC','20039',7168907870,'WAH7178HOSP');

--INDEX GENERATION  
 
CREATE INDEX REGISTRATION_IDX ON APP_ADMIN.REGISTRATION (RECIPIENT_ID,LAST_VACCINATION_DATE); 


--ONBOARDING PACKAGING EXECUTIONS
EXECUTE PKG_ONBOARD.ONBOARD_RECIPIENT(123,'SHRUTI','MOHAN','23-OCT-2015',6172345342,'234 FORSYTH STREET','BOSTON','03115','FEMALE'); 
DELETE FROM RECIPIENT WHERE RECIPIENT_ID = 126;
EXECUTE PKG_ONBOARD.ONBOARD_RECIPIENT(126,'NEELU','HASNANI','01-JUL-2016',7172345342,'65 HILLSIDE STREET','BOSTON','04115','FEMALE'); 
EXECUTE PKG_ONBOARD.ONBOARD_RECIPIENT(127,'SHREYAS','PATEL','23-NOV-1992',8172345342,'10 BROADWAY','BOSTON','05115','MALE'); 

EXECUTE PKG_ONBOARD.ONBOARD_HOSPITAL(1110,'ILLINOIS GENERAL HOSPITAL','1310 COMMONS DRIVE','CHICAGO','62134',4124433567,'QLL3425HOSP');
EXECUTE PKG_ONBOARD.ONBOARD_HOSPITAL(1111,'MASS GENERAL HOSPITAL','1312 PARK DRIVE','BOSTON','12134',5124433567,'WLL3425HOSP');
EXECUTE PKG_ONBOARD.ONBOARD_HOSPITAL(1112,'BOSTON GENERAL HOSPITAL','1202 BROOKLINE','BOSTON','56134',6124433567,'ELL3425HOSP');

EXECUTE PKG_ONBOARD.ONBOARD_VACCINE_DETAILS(305,'NOVAVAX',30,'LOT5123','17-JAN-2022','06-FEB-2022',40,15);
EXECUTE PKG_ONBOARD.ONBOARD_VACCINE_DETAILS(306,'PFIZER',10,'LOT5124','17-JAN-2022','06-FEB-2022',50,20);
EXECUTE PKG_ONBOARD.ONBOARD_VACCINE_DETAILS(302,'COVISHIELD',20,'LOT5125','17-JAN-2022','06-FEB-2022',75,10);
EXECUTE PKG_ONBOARD.ONBOARD_VACCINE_DETAILS(303,'BIOTECH',10,'LOT5126','17-JAN-2022','06-FEB-2022',90,20);

--DELETING PACKAGING EXECUTIONS
EXECUTE PKG_DELETE_RECORDS_APP_ADMIN.DEL_VACCINE_DETAILS(302);
EXECUTE PKG_DELETE_RECORDS_APP_ADMIN.DEL_VACCINE_DETAILS(305);
EXECUTE PKG_DELETE_RECORDS_APP_ADMIN.DEL_VACCINE_DETAILS(303);

EXECUTE PKG_DELETE_RECORDS_APP_ADMIN.DEL_HOSPITAL(1111);
EXECUTE PKG_DELETE_RECORDS_APP_ADMIN.DEL_HOSPITAL(1112);

EXECUTE PKG_DELETE_RECORDS_APP_ADMIN.DEL_RECIPIENT(123);
EXECUTE PKG_DELETE_RECORDS_APP_ADMIN.DEL_RECIPIENT(127);

----EFFICACY FUNCTION
--SELECT vd.vaccine_name, CALCULATEEFFICACY(vd.vaccine_id) efficacy from vaccine_details vd;
--
----ALL VIEWS select
--SELECT * FROM HOSPITAL_WISE_TOTAL_VACCINE_ADMINISTERED;
--
--SELECT * FROM MEDICAL_WORKER_WISE_TOTAL_VACCINE_ADMINISTERED;
--
--SELECT * FROM RECIPIENT_DETAILS;
--
--SELECT * FROM REGION_WISE_TOTAL_VACCINE_ADMINISTERED;
--
--SELECT * FROM TOTAL_BILLING_BY_HOSPITAL;
--
--SELECT * FROM TRAILING_DAY_WISE_TOTAL_VACCINE_ADMINISTERED;
--
--SELECT * FROM VACCINE_EFFICACY;
--
--SELECT * FROM VACCINE_TYPE_WISE_ADMINISTERED;
--
--SELECT * FROM WEEK_WISE_TOTAL_VACCINE_ADMINISTERED; 





 