# SEVA - Smart Extensive Vaccine Administration

Database Used : **Oracle 19c**

Language : **Oracle PL/SQL**

## Problem Statement :

As the world faced the devastating effects of Covid-19, one key-way emerged to combat Covid was through the vaccine. 
Vaccinations had to be administered to recipients by medical workers in a clinic/hospital. However, this entire process of vaccine administration became a challenge. An effective solution was required to streamline the mechanisms of recipients registering and billing; medical workers administering the vaccine in a clinic/hospital.

## Objectives :

1. Design a system that will streamline the process of recording vaccine distribution in a centralized, real time accessible manner
2. Recording vaccinated patients in hospitals/vaccination centers
3. Simplifying registration process for folks to receive vaccination
4. Extensive database storing vaccine and vaccination-related information including their pricing, and expiration dates
5. Robust billing process to smoothen vaccine-related transactions
6. Identifying medical workers in each vaccine disbursal for transparency and accountability

## Roles :

1. Application Admin 
2. Hospital Admin 
3. Medical Worker 
4. Recipient


## Proposed Solution :

The proposed solution is to create a system that manages COVID Vaccination record data quickly, securely, and effectively using a relational database. Through a single secure portal, patients could register for a particular COVID vaccine, pay their bill, Hospitals could stock their supplies, a medical worker can administer the vaccine and records can be maintained of the same. By using this platform, the patient will be in direct digital contact with the vaccination management setup, eliminating the need for multiple points of contact for vaccine registrations, slot availability, prior vaccinations details etc. thereby enabling quicker care for the client.

The vaccine management system is as follows:

1. The client can register for the vaccine with basic information, including their name, date of birth, email address, phone number, and address. 
2. Hospital Admin enter the data of medical workers who’ll be carrying out vaccinations 
3. The Medical Worker uses the vaccine of a specific type and administers the dose
4. The record of the administered vaccine is updated on the vaccine record table by medical worker hence completing the vaccine administration cycle.
5. App Admin is responsible for maintaining details about different participating hospitals and vaccination shots available

## Entity Relationship Diagram :

![ER Diagram](https://github.com/GargavaSiddharthNEU/Vaccine_Management_System/blob/main/ERD%20Diagram/ERD%20Diagram%20Vaccine%20Project.png?raw=true)

## Graphs :

Total number of vaccines administered by Hospital

![Graph vaccine by hospital](https://github.com/GargavaSiddharthNEU/Vaccine_Management_System/blob/main/ERD%20Diagram/Vaccines%20by%20Hospital.png)

Total number of vaccines administered by region

![Graph vaccine by region](https://github.com/GargavaSiddharthNEU/Vaccine_Management_System/blob/main/ERD%20Diagram/Vaccines%20by%20Region.png)

Vaccine Efficacy, Effectiveness of each vaccine

![Graph vaccine efficacy of each vaccine](https://github.com/GargavaSiddharthNEU/Vaccine_Management_System/blob/main/ERD%20Diagram/Vaccine%20Efficacy.png)

Total number of vaccines administered by each Medical Worker

![Graph vaccine by medical worker](https://github.com/GargavaSiddharthNEU/Vaccine_Management_System/blob/main/ERD%20Diagram/Vaccines%20by%20Medical%20Worker.png)

Total number of vaccines administered by each vaccine type

![Graph vaccine by vaccine type](https://github.com/GargavaSiddharthNEU/Vaccine_Management_System/blob/main/ERD%20Diagram/Vaccines%20by%20Vaccine%20Type.png)