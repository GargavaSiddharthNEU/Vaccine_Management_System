CREATE TABLE Audit_log( 
AUDIT_LOG_ID NUMBER CONSTRAINT AUDIT_LOG_PK PRIMARY KEY, 
LOG_DESCRIPTION VARCHAR(150) NOT NULL, 
OPERATION_TYPE VARCHAR(15),
RECIPIENT_ID NUMBER,
TIME_STAMP TIMESTAMP DEFAULT SYSTIMESTAMP
);

GRANT SELECT,INSERT ON AUDIT_LOG TO APP_ADMIN;