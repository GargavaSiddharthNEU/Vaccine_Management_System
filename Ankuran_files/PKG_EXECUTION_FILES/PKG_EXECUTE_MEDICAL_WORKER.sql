SET SERVEROUTPUT ON;

EXECUTE APP_ADMIN.PKG_ONBOARD_VACCINE_REC.ONBOARD_VACCINE_REC(60150,'21-SEP-2022 10:20:34','21-SEP-2022 11:25:50','21-SEP-2022','NULL',12017,50011,302);
EXECUTE APP_ADMIN.PKG_ONBOARD_VACCINE_REC.ONBOARD_VACCINE_REC(60152,'21-SEP-2022 10:20:34','21-SEP-2022 11:25:50','21-SEP-2022','NULL',12017,50011,302);
EXECUTE APP_ADMIN.PKG_ONBOARD_VACCINE_REC.ONBOARD_VACCINE_REC(60151,'21-SEP-2022 10:20:34','21-SEP-2022 11:25:50','21-SEP-2022','NULL',12017,50011,302);

EXECUTE APP_ADMIN.PKG_DELETE_MEDICAL_WORKER.DEL_VACCINE_RECORD(60152);
EXECUTE APP_ADMIN.PKG_DELETE_MEDICAL_WORKER.DEL_VACCINE_RECORD(60151);