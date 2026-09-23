
create database HospitalDB

use HospitalDB


create table Patient
(
	patient_id int primary key,
	personal_info nvarchar(255),
	contact_info nvarchar(255),
	DOB date,
	blood_group nvarchar(10),
	gender nvarchar(20)
)


create table Department
(
	department_id int primary key,
	name nvarchar(100),
	head_doctor_id int
)


create table Doctor
(
	doctor_id int primary key,
	specialization nvarchar(100),
	professional_details nvarchar(255),
	department_id int,
	foreign key (department_id) references Department(department_id)
)


alter table Department
add foreign key (head_doctor_id) references Doctor(doctor_id)


create table Service
(
	service_id int primary key,
	name nvarchar(100),
	type nvarchar(80),
	price decimal(10,2),
	department_id int,
	foreign key (department_id) references Department(department_id)
)


create table Appointment
(
	appointment_id int primary key,
	patient_id int,
	doctor_id int,
	appointment_date date,
	appointment_time time,
	status nvarchar(30),
	type nvarchar(60),
	foreign key (patient_id) references Patient(patient_id),
	foreign key (doctor_id) references Doctor(doctor_id)
)


create table Medical_Record
(
	record_id int primary key,
	patient_id int,
	doctor_id int,
	appointment_id int,
	diagnosis nvarchar(500),
	treatment nvarchar(500),
	foreign key (patient_id) references Patient(patient_id),
	foreign key (doctor_id) references Doctor(doctor_id),
	foreign key (appointment_id) references Appointment(appointment_id)
)


create table Billing
(
	bill_id int primary key,
	appointment_id int,
	payment_details nvarchar(255),
	foreign key (appointment_id) references Appointment(appointment_id)
)


create table Appointment_Service
(
	appointment_id int,
	service_id int,
	Quantity int,
	foreign key (appointment_id) references Appointment(appointment_id),
	foreign key (service_id) references Service(service_id),
	primary key (appointment_id, service_id)
)
