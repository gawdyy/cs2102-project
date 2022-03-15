DROP DATABASE IF EXISTS cs2102_project;
CREATE DATABASE cs2102_project;

\c cs2102_project


DROP TABLE IF EXISTS	
	Employees, Departments, Junior, Booker, Senior, Manager, MeetingRooms, Updates, "Sessions", Participants, HealthDeclaration CASCADE;

DROP TRIGGER IF EXISTS 
	resign_meetings ON Employees CASCADE;
DROP TRIGGER IF EXISTS 
	over_capacity ON Updates CASCADE;	
DROP TRIGGER IF EXISTS 
	fever_update ON HealthDeclaration CASCADE;
DROP TRIGGER IF EXISTS	
	fever_check ON HealthDeclaration CASCADE;

DROP FUNCTION IF EXISTS add_department, remove_department, add_room,
 change_capacity, add_employee, remove_employee, update_room_did, update_enfo, check_capacity_constraint, 
 resign_from_meetings, search_room, book_room, unbook_room, join_meeting, leave_meeting, approve_meeting, reject_meeting, 
 update_fever_status, declare_health, contact_tracing, update_contact_tracing,
 non_compliance, view_booking_report, view_future_meeting, view_manager_report CASCADE;
 

CREATE TABLE Departments (
	did INT CHECK (did >= 0),
	dname TEXT,
	PRIMARY KEY (did)
);

CREATE TABLE Employees (
	eid INT CHECK (eid >= 0),
	ename TEXT,
	email TEXT UNIQUE, 
	home INT CHECK (home > 9999999), -- home number (8 digits or more)
	phone INT CHECK (phone > 9999999), -- phone number (8 digits or more)
	office INT CHECK (phone > 9999999), -- office number (8 digits or more)
	resign DATE DEFAULT NULL,
	did INT NOT NULL,
	exposure_end_date DATE DEFAULT NULL,
	PRIMARY KEY(eid),
	FOREIGN KEY (did) REFERENCES Departments (did)
);

CREATE TABLE Junior (
	eid INT,
	PRIMARY KEY(eid),
	FOREIGN KEY (eid) REFERENCES Employees (eid)
);

CREATE TABLE Booker (
	eid INT,
	PRIMARY KEY(eid),
	FOREIGN KEY (eid) REFERENCES Employees (eid)
);

CREATE TABLE Senior (
	eid INT,
	PRIMARY KEY(eid),
	FOREIGN KEY (eid) REFERENCES Booker (eid)
);

CREATE TABLE Manager (
	eid INT,
	PRIMARY KEY(eid),
	FOREIGN KEY (eid) REFERENCES Booker (eid)
);


CREATE TABLE MeetingRooms(
	room INT CHECK (room > 0), 
	"floor" INT, 
	rname TEXT, 
	did INT NOT NULL, 
	PRIMARY KEY(room, "floor"), 
	FOREIGN KEY (did) REFERENCES Departments (did)
);

CREATE TABLE Updates ( /* Store all updates */
	"date" DATE,
	room INT CHECK (room > 0),
	"floor" INT,
	capacity INT CHECK (capacity > 0), /* The capacity as of the stated date */
	eid INT, /* The manager who made the update */
	PRIMARY KEY("date", "floor", room),
	FOREIGN KEY ("floor", room) REFERENCES MeetingRooms("floor", room),
	FOREIGN KEY (eid) REFERENCES Manager (eid)
);

CREATE TABLE "Sessions" (
	"time" INT CHECK ("time" BETWEEN 0 AND 23), /* 24HR Format (I.E 0600,1400) */
	"date" DATE,
	room INT CHECK (room > 0),
	"floor" INT, 
	bid INT NOT NULL, /* Person who booked the session */
	approver INT DEFAULT NULL, /* The manager who approved the session */
	PRIMARY KEY("time", "date", room, "floor"), 
	FOREIGN KEY (bid) REFERENCES Booker (eid), 
	FOREIGN KEY (room, "floor") REFERENCES MeetingRooms (room, "floor"),
	FOREIGN KEY (approver) REFERENCES Manager (eid)
) ;

CREATE TABLE Participants ( /* Each entry is a participant for a certain session */
	eid INT,
	"time" INT CHECK ("time" BETWEEN 0 AND 23),
	"date" DATE,
	room INT CHECK (room > 0),
	"floor" INT,
	PRIMARY KEY(eid, "time", "date", room, "floor"),
	FOREIGN KEY ("time", "date", room, "floor") REFERENCES "Sessions" ("time", "date", room, "floor") ON DELETE CASCADE
);

CREATE TABLE HealthDeclaration (
	eid INT,
	"date" DATE,
	temp FLOAT CHECK (temp BETWEEN 34 AND 43),
	fever BOOLEAN, /* FEVER > 37.5 in declareHealth function */
	PRIMARY KEY(eid, "date"),
	FOREIGN KEY(eid) REFERENCES Employees(eid)
);