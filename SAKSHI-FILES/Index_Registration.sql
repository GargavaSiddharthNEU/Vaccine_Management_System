--------------------------------------------------------
--  File created - Sunday-November-27-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Index REGISTRATION_IDX
--------------------------------------------------------

   CREATE INDEX "APP_ADMIN"."REGISTRATION_IDX" ON "APP_ADMIN"."REGISTRATION" ("RECIPIENT_ID", "LAST_VACCINATION_DATE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "DATA" ;