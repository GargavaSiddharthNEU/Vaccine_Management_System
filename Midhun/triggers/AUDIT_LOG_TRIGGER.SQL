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