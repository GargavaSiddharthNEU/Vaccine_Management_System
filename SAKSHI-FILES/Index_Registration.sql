--------------------------------------------------------
--  File created - Sunday-November-27-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Index REGISTRATION_IDX
--------------------------------------------------------

  CREATE UNIQUE INDEX "APP_ADMIN"."REGISTRATION_IDX" ON "APP_ADMIN"."REGISTRATION" ("RECIPIENT_ID", "LAST_VACCINATION_DATE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;
