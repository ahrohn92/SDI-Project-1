/*DROP VIEWS IF THEY EXIST */

DROP VIEW IF EXISTS aircraft_tickets;
DROP VIEW IF EXISTS aircraft_flights;
DROP VIEW IF EXISTS Components;
DROP VIEW IF EXISTS Ticket_Information;

/* DROPS TABLES IF THEY EXIST */

DROP TABLE IF EXISTS Ticket;
DROP TABLE IF EXISTS Flight;
DROP TABLE IF EXISTS Component;
DROP TABLE IF EXISTS Aircraft;
DROP TABLE IF EXISTS Pilot;
DROP TABLE IF EXISTS App_User;
DROP TABLE IF EXISTS Work_Center;

/* CREATES TABLES AND CONSTRAINTS */

CREATE TABLE Work_Center(
	Work_Center_ID SERIAL,
	Unit TEXT NOT NULL,
	Work_Center_Location TEXT,
	PRIMARY KEY (Work_Center_ID)
);

CREATE TABLE App_User(
	User_ID SERIAL,
	Work_Center_ID INTEGER NOT NULL,
	Username TEXT UNIQUE NOT NULL,
	Email_Address TEXT UNIQUE NOT NULL,
	Pass_Word TEXT UNIQUE NOT NULL,
	First_Name TEXT NOT NULL,
	Last_Name TEXT NOT NULL,
	User_Role TEXT NOT NULL,
	PRIMARY KEY (User_ID),
	CONSTRAINT App_User_Work_Center_FK 
		FOREIGN KEY(Work_Center_ID) 
		REFERENCES Work_Center(Work_Center_ID)
);

CREATE TABLE Pilot(
	Pilot_ID SERIAL,
	User_ID INTEGER UNIQUE NOT NULL,
	DNIF BOOLEAN NOT NULL,
	Shift TEXT NOT NULL,
	Flying_Hours NUMERIC NOT NULL,
	Qualification TEXT NOT NULL,
	PRIMARY KEY (Pilot_ID),
	CONSTRAINT Pilot_App_User_FK 
		FOREIGN KEY(User_ID) 
		REFERENCES App_User(User_ID)
);

CREATE TABLE Aircraft(
	Aircraft_ID SERIAL,
	Work_Center_ID INTEGER NOT NULL,
	Aircraft_Model TEXT NOT NULL,
	Tail_Number TEXT UNIQUE NOT NULL,
	Flight_Hours NUMERIC NOT NULL,
	Last_Fly_Date DATE NOT NULL,
	Operational_Status TEXT NOT NULL,
	PRIMARY KEY (Aircraft_ID),
	CONSTRAINT Aircraft_Work_Center_FK 
		FOREIGN KEY(Work_Center_ID) 
		REFERENCES Work_Center(Work_Center_ID)
);

CREATE TABLE Component(
	Component_ID SERIAL,
	Aircraft_ID INTEGER NOT NULL,
	Component_Name TEXT NOT NULL,
	Component_Status TEXT NOT NULL,
	PRIMARY KEY (Component_ID),
	CONSTRAINT Component_Aircraft_FK 
		FOREIGN KEY (Aircraft_ID) 
		REFERENCES Aircraft(Aircraft_ID)
);

CREATE TABLE Flight(
	Flight_ID SERIAL NOT NULL,
	Aircraft_ID INTEGER NOT NULL,
	Pilot_ID INTEGER NOT NULL,
	Scheduled_Takeoff_Timestamp TIMESTAMP NOT NULL,
	Scheduled_Landing_Timestamp TIMESTAMP NOT NULL,
	Actual_Takeoff_Timestamp TIMESTAMP,
	Actual_Landing_Timestamp TIMESTAMP,
	Call_Sign TEXT NOT NULL,
	PRIMARY KEY (Flight_ID),
	CONSTRAINT Flight_Aircraft_FK 
		FOREIGN KEY (Aircraft_ID) 
		REFERENCES Aircraft(Aircraft_ID),
	CONSTRAINT Flight_Pilot_FK 
		FOREIGN KEY (Pilot_ID) 
		REFERENCES Pilot(Pilot_ID)
);

CREATE TABLE Ticket(
	Ticket_ID SERIAL,
	Created_By_User_ID INTEGER NOT NULL,
	Work_Center_ID INTEGER NOT NULL,
	Component_ID INTEGER NOT NULL,
	Start_Timestamp TIMESTAMP NOT NULL,
	Suspense_Timestamp TIMESTAMP,
	Close_Timestamp TIMESTAMP,
	Is_Scheduled BOOLEAN NOT NULL,
	Narrative TEXT,
	Fix_Action TEXT,
	Closed_By_User_ID INTEGER,
	PRIMARY KEY (Ticket_ID),
	CONSTRAINT Ticket_App_User_FK1
		FOREIGN KEY (Created_By_User_ID) 
		REFERENCES App_User(User_ID),
	CONSTRAINT Ticket_Work_Center_FK
		FOREIGN KEY (Work_Center_ID) 
		REFERENCES Work_Center(Work_Center_ID),
	CONSTRAINT Ticket_Component_FK
		FOREIGN KEY (Component_ID) 
		REFERENCES Component(Component_ID),
	CONSTRAINT Ticket_App_User_FK2
		FOREIGN KEY (Closed_By_User_ID) 
		REFERENCES App_User(User_ID)
);

/* INSERT INITIAL VALUES INTO TABLES */

-- Work_Center
INSERT INTO Work_Center (Unit, Work_Center_Location) VALUES ('58 DSS', 'Ramstein AFB');
INSERT INTO Work_Center (Unit, Work_Center_Location) VALUES ('72 LCF', 'Joint Base Lewis-McChord');
INSERT INTO Work_Center (Unit, Work_Center_Location) VALUES ('460 SCS', 'Fort Bragg');

-- App_User
INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (1, 'ahrohn92', 'arohn@us.af.mil', 'MyPassword', 'Andrew', 'Rohn', 'Maintainer');
INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (1, 'mattJones93', 'mattjones@us.af.mil', 'LOLZKATZ!', 'Matthew', 'Jones', 'MX Scheduler');
INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (1, 'tomi_salami', 'tomisalami@us.af.mil', 'theBigSalami', 'Tomi', 'Salami', 'Maintainer');
INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (1, 'jill_steiner80', 'jillstein@us.af.mil', 'jack&jill', 'Jill', 'Stein', 'Pilot');
INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (1, 'Rockin_Poppins', 'marypoppins@us.af.mil', 'spoonful_Of_sugar', 'Mary', 'Poppins', 'Flight Scheduler');

INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (2, 'terri90', 'terriberry@us.af.mil', 'tearbear', 'Terri', 'Berry', 'Maintainer');
INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (2, 'tom_jones!', 'tomjones@us.af.mil', 'pussycat', 'Tom', 'Jones', 'MX Scheduler');
INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (2, 'Rick_Roller', 'rickastley@us.af.mil', 'rickrollin', 'Rick', 'Astley', 'Maintainer');
INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (2, 'TheRealDonald', 'donaldtrump@us.af.mil', 'maga2024', 'Donald', 'Trump', 'Pilot');
INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (2, 'LEEROY', 'leeroyjenkins@us.af.mil', 'chicken', 'Leeroy', 'Jenkins', 'Flight Scheduler');

INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (3, 'Hugh_Heff', 'hughheffner@us.af.mil', 'playboy', 'Hugh', 'Heffner', 'Maintainer');
INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (3, 'Best_Chef', 'gordonramsay@us.af.mil', 'RAW!!!', 'Gordon', 'Ramsay', 'MX Scheduler');
INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (3, 'McAwesome', 'ronaldmcdonald@us.af.mil', 'im_lovin_it', 'Ronald', 'McDonald', 'Maintainer');
INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (3, 'RidinBiden', 'joebiden@us.af.mil', 'im_tired', 'Joe', 'Biden', 'Pilot');
INSERT INTO App_User (Work_Center_ID, Username, Email_Address, Pass_Word, First_Name, Last_Name, User_Role) 
VALUES (3, 'Elvis', 'elvispresley@us.af.mil', 'theKing!', 'Elvis', 'Presley', 'Flight Scheduler');

-- Pilot
INSERT INTO Pilot (User_ID, DNIF, Shift, Flying_Hours, Qualification) 
VALUES (4, 'false', 'day', 835, 'Student');
INSERT INTO Pilot (User_ID, DNIF, Shift, Flying_Hours, Qualification) 
VALUES (9, 'true', 'night', 4000, 'Instructor');
INSERT INTO Pilot (User_ID, DNIF, Shift, Flying_Hours, Qualification) 
VALUES (14, 'true', 'day', 3150, 'Evaluator');

-- Aircraft
INSERT INTO Aircraft (Work_Center_ID, Aircraft_Model, Tail_Number, Flight_Hours, Last_Fly_Date, Operational_Status) 
VALUES (1, 'F-15', 'F15-001', 238, '08-NOV-2020', 'FMC');
INSERT INTO Aircraft (Work_Center_ID, Aircraft_Model, Tail_Number, Flight_Hours, Last_Fly_Date, Operational_Status) 
VALUES (1, 'F-22', 'F22-001', 786, '06-MAR-2020', 'NMC');
INSERT INTO Aircraft (Work_Center_ID, Aircraft_Model, Tail_Number, Flight_Hours, Last_Fly_Date, Operational_Status) 
VALUES (1, 'F-35', 'F35-001', 135.5, '16-NOV-2020', 'PMC');
INSERT INTO Aircraft (Work_Center_ID, Aircraft_Model, Tail_Number, Flight_Hours, Last_Fly_Date, Operational_Status) 
VALUES (1, 'A-10', 'A10-001', 845, '29-JUL-2019', 'PMC');
INSERT INTO Aircraft (Work_Center_ID, Aircraft_Model, Tail_Number, Flight_Hours, Last_Fly_Date, Operational_Status) 
VALUES (2, 'F-15', 'F15-002', 346, '01-FEB-2020', 'FMC');
INSERT INTO Aircraft (Work_Center_ID, Aircraft_Model, Tail_Number, Flight_Hours, Last_Fly_Date, Operational_Status) 
VALUES (2, 'F-22', 'F22-002', 367.5, '08-MAR-2020', 'FMC');
INSERT INTO Aircraft (Work_Center_ID, Aircraft_Model, Tail_Number, Flight_Hours, Last_Fly_Date, Operational_Status) 
VALUES (2, 'F-35', 'F35-002', 1023, '15-OCT-2020', 'PMC');
INSERT INTO Aircraft (Work_Center_ID, Aircraft_Model, Tail_Number, Flight_Hours, Last_Fly_Date, Operational_Status) 
VALUES (2, 'A-10', 'A10-002', 932, '04-JUL-2020', 'PMC');
INSERT INTO Aircraft (Work_Center_ID, Aircraft_Model, Tail_Number, Flight_Hours, Last_Fly_Date, Operational_Status) 
VALUES (3, 'F-15', 'F15-003', 742, '16-APR-2020', 'FMC');
INSERT INTO Aircraft (Work_Center_ID, Aircraft_Model, Tail_Number, Flight_Hours, Last_Fly_Date, Operational_Status) 
VALUES (3, 'F-22', 'F22-003', 616.5, '12-OCT-2020', 'NMC');
INSERT INTO Aircraft (Work_Center_ID, Aircraft_Model, Tail_Number, Flight_Hours, Last_Fly_Date, Operational_Status) 
VALUES (3, 'F-35', 'F35-003', 820, '09-JAN-2020', 'FMC');
INSERT INTO Aircraft (Work_Center_ID, Aircraft_Model, Tail_Number, Flight_Hours, Last_Fly_Date, Operational_Status) 
VALUES (3, 'A-10', 'A10-003', 320, '14-NOV-2020', 'PMC');

-- Component
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (1, 'engine', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (1, 'flight controls', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (1, 'radar', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (1, 'landing gear', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (2, 'engine', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (2, 'flight controls', 'broken');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (2, 'radar', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (2, 'landing gear', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (3, 'engine', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (3, 'flight controls', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (3, 'radar', 'inaccurate signals');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (3, 'landing gear', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (4, 'engine', 'needs to be cleaned');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (4, 'flight controls', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (4, 'radar', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (4, 'landing gear', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (5, 'engine', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (5, 'flight controls', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (5, 'radar', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (5, 'landing gear', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (6, 'engine', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (6, 'flight controls', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (6, 'radar', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (6, 'landing gear', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (7, 'engine', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (7, 'flight controls', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (7, 'radar', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (7, 'landing gear', 'moves slowly');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (8, 'engine', 'makes wierd noises');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (8, 'flight controls', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (8, 'radar', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (8, 'landing gear', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (9, 'engine', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (9, 'flight controls', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (9, 'radar', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (9, 'landing gear', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (10, 'engine', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (10, 'flight controls', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (10, 'radar', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (10, 'landing gear', 'broken');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (11, 'engine', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (11, 'flight controls', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (11, 'radar', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (11, 'landing gear', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (12, 'engine', 'does not start');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (12, 'flight controls', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (12, 'radar', 'OK');
INSERT INTO Component (Aircraft_ID, Component_Name, Component_Status) VALUES (12, 'landing gear', 'OK');

-- Flight
INSERT INTO Flight (Aircraft_ID, Pilot_ID, Scheduled_Takeoff_Timestamp, Scheduled_Landing_Timestamp, Actual_Takeoff_Timestamp, Actual_Landing_Timestamp, Call_Sign)
VALUES (1, 1, '2020-11-25 13:30:00', '2020-11-25 15:00:00', null, null, 'Maverick');
INSERT INTO Flight (Aircraft_ID, Pilot_ID, Scheduled_Takeoff_Timestamp, Scheduled_Landing_Timestamp, Actual_Takeoff_Timestamp, Actual_Landing_Timestamp, Call_Sign)
VALUES (3, 1, '2020-11-16 10:30:00', '2020-11-16 12:00:00', '2020-11-16 10:31:14', '2020-11-16 11:58:47', 'Ace');
INSERT INTO Flight (Aircraft_ID, Pilot_ID, Scheduled_Takeoff_Timestamp, Scheduled_Landing_Timestamp, Actual_Takeoff_Timestamp, Actual_Landing_Timestamp, Call_Sign)
VALUES (6, 2, '2020-12-04 19:30:00', '2020-12-04 21:00:00', null, null, 'Foxtrot');
INSERT INTO Flight (Aircraft_ID, Pilot_ID, Scheduled_Takeoff_Timestamp, Scheduled_Landing_Timestamp, Actual_Takeoff_Timestamp, Actual_Landing_Timestamp, Call_Sign)
VALUES (7, 2, '2020-10-15 20:00:00', '2020-10-15 22:00:00', '2020-10-15 20:03:38', '2020-10-15 22:14:50', 'Romeo');
INSERT INTO Flight (Aircraft_ID, Pilot_ID, Scheduled_Takeoff_Timestamp, Scheduled_Landing_Timestamp, Actual_Takeoff_Timestamp, Actual_Landing_Timestamp, Call_Sign)
VALUES (10, 3, '2021-01-23 08:30:00', '2021-01-23 10:00:00', null, null, 'Hotshot');
INSERT INTO Flight (Aircraft_ID, Pilot_ID, Scheduled_Takeoff_Timestamp, Scheduled_Landing_Timestamp, Actual_Takeoff_Timestamp, Actual_Landing_Timestamp, Call_Sign)
VALUES (12, 3, '2021-01-05 09:30:00', '2021-01-05 11:00:00', null, null, 'Endeavor');

-- Ticket
INSERT INTO Ticket (Created_By_User_ID, Work_Center_ID, Component_ID, Start_Timestamp, Suspense_Timestamp, Close_Timestamp, Is_Scheduled, Narrative, Fix_Action, Closed_By_User_ID)
VALUES (2, 1, 6, '2020-11-22 15:30:00', '2020-11-23 15:30:00', null, 'true', 'Need to fix broken flight controls', null, null);
INSERT INTO Ticket (Created_By_User_ID, Work_Center_ID, Component_ID, Start_Timestamp, Suspense_Timestamp, Close_Timestamp, Is_Scheduled, Narrative, Fix_Action, Closed_By_User_ID)
VALUES (1, 1, 11, '2020-11-23 16:30:00', null, null, 'false', 'Need to recalibrate radar', null, null);
INSERT INTO Ticket (Created_By_User_ID, Work_Center_ID, Component_ID, Start_Timestamp, Suspense_Timestamp, Close_Timestamp, Is_Scheduled, Narrative, Fix_Action, Closed_By_User_ID)
VALUES (3, 1, 13, '2020-11-30 16:00:00', null, null, 'false', 'the engine is dirty and needs to be cleaned', null, null);
INSERT INTO Ticket (Created_By_User_ID, Work_Center_ID, Component_ID, Start_Timestamp, Suspense_Timestamp, Close_Timestamp, Is_Scheduled, Narrative, Fix_Action, Closed_By_User_ID)
VALUES (6, 2, 28, '2020-11-25 12:00:00', null, null, 'false', 'The landing gear is moving slowly. It needs to be examined.', null, null);
INSERT INTO Ticket (Created_By_User_ID, Work_Center_ID, Component_ID, Start_Timestamp, Suspense_Timestamp, Close_Timestamp, Is_Scheduled, Narrative, Fix_Action, Closed_By_User_ID)
VALUES (8, 2, 29, '2020-11-27 13:30:00', null, null, 'false', 'The engine is making strange noises. It needs to be examined.', null, null);
INSERT INTO Ticket (Created_By_User_ID, Work_Center_ID, Component_ID, Start_Timestamp, Suspense_Timestamp, Close_Timestamp, Is_Scheduled, Narrative, Fix_Action, Closed_By_User_ID)
VALUES (12, 3, 40, '2020-11-24 14:30:00', '2020-11-27 14:30:00', null, 'true', 'The landing gear is not deploying and needs to be fixed.', null, null);
INSERT INTO Ticket (Created_By_User_ID, Work_Center_ID, Component_ID, Start_Timestamp, Suspense_Timestamp, Close_Timestamp, Is_Scheduled, Narrative, Fix_Action, Closed_By_User_ID)
VALUES (13, 3, 45, '2020-11-22 12:30:00', null, null, 'false', 'The engine is not starting up. It needs to be examined and fixed.', null, null);

/* VIEWS */

-- Ticket_Information View
CREATE OR REPLACE VIEW Ticket_Information AS
SELECT 	t5.Work_Center_ID, t1.Ticket_ID, t2.Username AS Opened_By, t3.Aircraft_Model, t3.Tail_Number, t1.Component_ID, t4.Component_Name, 
  		t1.Start_Timestamp, t1.Suspense_Timestamp, t1.Close_Timestamp, t1.Is_Scheduled, t1.Narrative, t1.Fix_Action, t6.Username AS Closed_By
FROM Ticket t1
INNER JOIN App_User t2
  	ON t1.Created_By_User_ID = t2.User_ID
INNER JOIN Component t4
	ON t1.Component_ID = t4.Component_ID
INNER JOIN Aircraft t3
 	ON t4.Aircraft_ID = t3.Aircraft_ID
INNER JOIN Work_Center t5
	ON t2.Work_Center_ID = t5.Work_Center_ID
LEFT JOIN App_User t6
 	ON t1.Closed_By_User_ID = t6.User_ID
ORDER BY t1.Ticket_ID ASC;

-- Components View
CREATE OR REPLACE VIEW Components AS
SELECT w.Work_Center_ID, c.Component_ID, c.Aircraft_ID, c.Component_Name, c.Component_Status
FROM Component c
JOIN Aircraft a 
	ON c.Aircraft_ID = a.Aircraft_ID
JOIN Work_Center w
	ON a.Work_Center_ID = w.Work_Center_ID;

/* CREATE VIEW */
CREATE VIEW aircraft_tickets AS
SELECT     ticket.Ticket_ID, 
    ticket.Created_By_User_ID, 
    aircraft.aircraft_id, 
    component.component_name, 
    ticket.Work_Center_ID, 
    ticket.Start_Timestamp, 
    ticket.Suspense_Timestamp, 
    ticket.Close_Timestamp, 
    ticket.Is_Scheduled, 
    ticket.Narrative, 
    ticket.Closed_By_User_ID
FROM ticket 
INNER JOIN component ON ticket.component_id = component.component_id
INNER JOIN aircraft ON component.aircraft_id = aircraft.aircraft_id;

CREATE VIEW aircraft_flights AS
SELECT flight.Flight_ID, flight.Aircraft_ID, flight.Pilot_ID, flight.Scheduled_Takeoff_Timestamp, flight.Scheduled_Landing_Timestamp, flight.Actual_Takeoff_Timestamp, flight.Actual_Landing_Timestamp, flight.Call_Sign
FROM flight
INNER JOIN aircraft ON flight.aircraft_id = aircraft.aircraft_id;
