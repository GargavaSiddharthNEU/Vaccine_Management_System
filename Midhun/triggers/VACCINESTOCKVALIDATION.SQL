create or replace TRIGGER VACCINESTOCKVALIDATION 
BEFORE INSERT ON VACCINE_RECORD 
FOR EACH ROW
DECLARE
  qty VACCINE_DETAILS.QUANTITY%type;
BEGIN
    
    SELECT QUANTITY into qty FROM VACCINE_DETAILS WHERE VACCINE_ID=:NEW.VACCINE_ID;
    dbms_output.put(qty);
    IF qty < 1 THEN raise_application_error(-20002, 'Requested vaccine not available!');
    END IF;
    UPDATE VACCINE_DETAILS set quantity=quantity-1 where vaccine_id=:new.vaccine_id;

END;