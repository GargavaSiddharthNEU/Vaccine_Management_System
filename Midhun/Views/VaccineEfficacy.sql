CREATE VIEW VACCINE_EFFICACY
AS select vaccine_id, calculateefficacy(vd.vaccine_id) as efficacy from vaccine_details vd;
