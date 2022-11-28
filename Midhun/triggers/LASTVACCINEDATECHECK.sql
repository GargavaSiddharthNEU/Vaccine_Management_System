--Vaccine in last 180 days 
CREATE OR REPLACE TRIGGER LASTVACCINECHECK
     BEFORE INSERT 
     ON REGISTRATION
     FOR EACH ROW
DECLARE
     difference  NUMBER;
BEGIN
     SELECT EXTRACT (YEAR FROM SYSDATE) - EXTRACT (YEAR FROM RG.last_vaccination_date)
       INTO difference
       FROM REGISTRATION RG
      WHERE RG.last_vaccination_date = :new.LAST_VACCINATION_DATE;

 

     IF (difference < 12)
      THEN
        raise_application_error (-20000, 'Recipient cannot book a vaccination slot before the 180 days from last vaccination date');
     END IF;
  END;
