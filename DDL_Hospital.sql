/* =========================================================
   LEVEL 3 - HOSPITAL MANAGEMENT SYSTEM
   SQL SERVER / SSMS
   TABLES ONLY - NO DATA
   ========================================================= */

USE master;
GO

IF DB_ID('HospitalDB') IS NOT NULL
BEGIN
    ALTER DATABASE HospitalDB
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;

    DROP DATABASE HospitalDB;
END;
GO

CREATE DATABASE HospitalDB;
GO

USE HospitalDB;
GO

/* =========================================================
   TABLES
   ========================================================= */

CREATE TABLE Patient (
    patient_id INT PRIMARY KEY,
    personal_info VARCHAR(255),
    contact_info VARCHAR(255),
    DOB DATE NOT NULL,
    age INT NOT NULL CHECK (age >= 0),
    blood_group VARCHAR(10),
    gender VARCHAR(20)
);
GO

CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    head_doctor_id INT NULL UNIQUE
);
GO

CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY,
    specialization VARCHAR(120),
    professional_details VARCHAR(255),
    department_id INT NOT NULL,

    CONSTRAINT FK_Doctor_Department
        FOREIGN KEY (department_id)
        REFERENCES Department(department_id)
);
GO

ALTER TABLE Department
ADD CONSTRAINT FK_Department_HeadDoctor
FOREIGN KEY (head_doctor_id)
REFERENCES Doctor(doctor_id);
GO

CREATE TABLE Service (
    service_id INT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    type VARCHAR(80),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    department_id INT NOT NULL,

    CONSTRAINT FK_Service_Department
        FOREIGN KEY (department_id)
        REFERENCES Department(department_id)
);
GO

CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(30) NOT NULL,
    type VARCHAR(60),

    CONSTRAINT FK_Appointment_Patient
        FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id),

    CONSTRAINT FK_Appointment_Doctor
        FOREIGN KEY (doctor_id)
        REFERENCES Doctor(doctor_id)
);
GO

CREATE TABLE Medical_Record (
    record_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT NOT NULL UNIQUE,
    diagnosis VARCHAR(500),
    treatment VARCHAR(500),

    CONSTRAINT FK_Record_Patient
        FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id),

    CONSTRAINT FK_Record_Doctor
        FOREIGN KEY (doctor_id)
        REFERENCES Doctor(doctor_id),

    CONSTRAINT FK_Record_Appointment
        FOREIGN KEY (appointment_id)
        REFERENCES Appointment(appointment_id)
);
GO

CREATE TABLE Billing (
    bill_id INT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,

    CONSTRAINT FK_Billing_Appointment
        FOREIGN KEY (appointment_id)
        REFERENCES Appointment(appointment_id)
);
GO

CREATE TABLE Appointment_Service (
    appointment_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price_applied DECIMAL(10,2) NOT NULL
        CHECK (unit_price_applied >= 0),

    CONSTRAINT PK_Appointment_Service
        PRIMARY KEY (appointment_id, service_id),

    CONSTRAINT FK_AppointmentService_Appointment
        FOREIGN KEY (appointment_id)
        REFERENCES Appointment(appointment_id),

    CONSTRAINT FK_AppointmentService_Service
        FOREIGN KEY (service_id)
        REFERENCES Service(service_id)
);
GO

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    bill_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_details VARCHAR(255),

    CONSTRAINT FK_Payment_Billing
        FOREIGN KEY (bill_id)
        REFERENCES Billing(bill_id)
);
GO

PRINT 'HospitalDB tables created successfully.';
GO
