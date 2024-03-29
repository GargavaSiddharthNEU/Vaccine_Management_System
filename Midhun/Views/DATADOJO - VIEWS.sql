--VIEWS SCRIPTS
--View1
CREATE OR REPLACE VIEW RECIPIENT_DETAILS AS
SELECT RP.RECIPIENT_ID,RG.REGISTRATION_ID,RP.FIRST_NAME, RP.LAST_NAME,
RP.DATE_OF_BIRTH,RP.CONTACT_NUMBER,RP.STREET_ADDRESS, RP.CITY,RP.ZIPCODE,RP.GENDER, 
RG.EMAIL_ID,RG.LAST_VACCINATION_DATE,VACCINE_RECORD_ID,VR.VACCINE_RECORD_DATE,VR.REMARKS,
HP.HOSPITAL_ID,HP.HOSPITAL_NAME,MW.MEDICAL_WORKER_ID,VD.VACCINE_ID,VD.VACCINE_NAME

FROM RECIPIENT RP
JOIN REGISTRATION RG ON
RG.RECIPIENT_ID = RP.RECIPIENT_ID
JOIN VACCINE_RECORD VR ON
VR.REGISTRATION_ID = RG.REGISTRATION_ID
JOIN MEDICAL_WORKER MW ON
MW.MEDICAL_WORKER_ID = VR.MEDICAL_WORKER_ID
JOIN HOSPITAL HP ON
HP.HOSPITAL_ID = MW.HOSPITAL_ID
JOIN VACCINE_DETAILS VD ON
VD.VACCINE_ID = VR.VACCINE_ID;

--View2
CREATE OR REPLACE VIEW HOSPITAL_WISE_TOTAL_VACCINE_ADMINISTERED AS

SELECT H.HOSPITAL_ID, H.HOSPITAL_NAME,COUNT(VR.VACCINE_RECORD_ID) AS TOTAL_VACCINE_ADMINISTERED

FROM HOSPITAL H
JOIN MEDICAL_WORKER MW ON
MW.HOSPITAL_ID = H.HOSPITAL_ID
JOIN VACCINE_RECORD VR ON 
VR.MEDICAL_WORKER_ID = MW.MEDICAL_WORKER_ID

GROUP BY H.HOSPITAL_ID,H.HOSPITAL_NAME;


--View3
CREATE OR REPLACE VIEW MEDICAL_WORKER_WISE_TOTAL_VACCINE_ADMINISTERED AS

SELECT MW.MEDICAL_WORKER_ID, MW.FIRST_NAME,COUNT(VR.VACCINE_RECORD_ID) AS TOTAL_VACCINE_ADMINISTERED

FROM HOSPITAL H
JOIN MEDICAL_WORKER MW ON
MW.HOSPITAL_ID = H.HOSPITAL_ID
JOIN VACCINE_RECORD VR ON 
VR.MEDICAL_WORKER_ID = MW.MEDICAL_WORKER_ID

GROUP BY MW.MEDICAL_WORKER_ID,MW.FIRST_NAME;

--View4
CREATE OR REPLACE VIEW REGION_WISE_TOTAL_VACCINE_ADMINISTERED AS

SELECT H.CITY, COUNT(VR.VACCINE_RECORD_ID) AS TOTAL_VACCINE_ADMINISTERED

FROM HOSPITAL H
JOIN MEDICAL_WORKER MW ON
MW.HOSPITAL_ID = H.HOSPITAL_ID
JOIN VACCINE_RECORD VR ON 
VR.MEDICAL_WORKER_ID = MW.MEDICAL_WORKER_ID

GROUP BY H.CITY;

--View5
CREATE OR REPLACE VIEW WEEK_WISE_TOTAL_VACCINE_ADMINISTERED AS
SELECT to_char(to_date(VR.VACCINE_RECORD_DATE,'DD/MON/YYYY'),'WW/YY')AS WEEK,
COUNT(vr.vaccine_record_id) AS TOTAL_VACCINE_ADMINISTERED

FROM HOSPITAL H
JOIN MEDICAL_WORKER MW ON
MW.HOSPITAL_ID = H.HOSPITAL_ID
JOIN VACCINE_RECORD VR ON 
VR.MEDICAL_WORKER_ID = MW.MEDICAL_WORKER_ID
JOIN VACCINE_DETAILS VD ON
VD.VACCINE_ID = VR.VACCINE_ID

GROUP BY VR.VACCINE_RECORD_DATE

ORDER BY VR.VACCINE_RECORD_DATE ASC;

--View6
CREATE OR REPLACE VIEW VACCINE_TYPE_WISE_ADMINISTERED AS
SELECT VD.VACCINE_NAME,VD.VACCINE_ID, COUNT(VR.VACCINE_RECORD_ID) AS TOTAL_VACCINE_TYPE

FROM HOSPITAL H
JOIN MEDICAL_WORKER MW ON
MW.HOSPITAL_ID = H.HOSPITAL_ID
JOIN VACCINE_RECORD VR ON 
VR.MEDICAL_WORKER_ID = MW.MEDICAL_WORKER_ID
JOIN VACCINE_DETAILS VD ON
VD.VACCINE_ID = VR.VACCINE_ID

GROUP BY VD.VACCINE_NAME,VD.VACCINE_ID;

--View7
CREATE OR REPLACE VIEW TOTAL_BILLING_BY_HOSPITAL AS
SELECT H.HOSPITAL_ID,H.HOSPITAL_NAME,SUM(RG.PAYMENT_AMOUNT) AS TOTAL_BILLING

FROM HOSPITAL H
JOIN MEDICAL_WORKER MW ON
MW.HOSPITAL_ID = H.HOSPITAL_ID
JOIN VACCINE_RECORD VR ON
VR.MEDICAL_WORKER_ID = MW.MEDICAL_WORKER_ID
JOIN REGISTRATION RG ON
RG.REGISTRATION_ID = VR.REGISTRATION_ID

GROUP BY H.HOSPITAL_ID,H.HOSPITAL_NAME;

--View8
CREATE OR REPLACE VIEW TRAILING_DAY_WISE_TOTAL_VACCINE_ADMINISTERED AS
SELECT VACCINE_RECORD_DATE, COUNT(VACCINE_RECORD_ID) AS TOTAL_VACCINE_ADMINISTERED

FROM VACCINE_RECORD

GROUP BY VACCINE_RECORD_DATE
ORDER BY VACCINE_RECORD_DATE ASC;

--View9
CREATE OR REPLACE VIEW VACCINE_EFFICACY
AS select vaccine_name,vaccine_id, calculateefficacy(vd.vaccine_id) as efficacy from vaccine_details vd;

--ALL VIEWS select
SELECT * FROM HOSPITAL_WISE_TOTAL_VACCINE_ADMINISTERED;

SELECT * FROM MEDICAL_WORKER_WISE_TOTAL_VACCINE_ADMINISTERED;

SELECT * FROM RECIPIENT_DETAILS;

SELECT * FROM REGION_WISE_TOTAL_VACCINE_ADMINISTERED;

SELECT * FROM TOTAL_BILLING_BY_HOSPITAL;

SELECT * FROM TRAILING_DAY_WISE_TOTAL_VACCINE_ADMINISTERED;

SELECT * FROM VACCINE_EFFICACY;

SELECT * FROM VACCINE_TYPE_WISE_ADMINISTERED;

SELECT * FROM WEEK_WISE_TOTAL_VACCINE_ADMINISTERED; 