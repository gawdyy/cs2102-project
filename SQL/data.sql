/*Setting up basic data*/

\c cs2102_project

-- Departments 
insert into Departments (did, dname) values (0, 'Human Resource');
insert into Departments (did, dname) values (1, 'Management');
insert into Departments (did, dname) values (2, 'Marketing');
insert into Departments (did, dname) values (3, 'Operations');

-- MeetingRooms 
insert into MeetingRooms (room, "floor", rname, did) values (1, 0, 'Dove', 0);
insert into MeetingRooms (room, "floor", rname, did) values (2, 0, 'Bat', 0);
insert into MeetingRooms (room, "floor", rname, did) values (1, 1, 'Lion', 1);
insert into MeetingRooms (room, "floor", rname, did) values (2, 1, 'Tiger', 1);
insert into MeetingRooms (room, "floor", rname, did) values (1, 2, 'Whale',2);
insert into MeetingRooms (room, "floor", rname, did) values (2, 2, 'Dolphin', 2);
insert into MeetingRooms (room, "floor", rname, did) values (1, 3, 'Snake', 3);
insert into MeetingRooms (room, "floor", rname, did) values (2, 3, 'Lizard', 3);


-- Employees
insert into Employees (eid, ename, email, home, phone, office, did) values (0, 'Seumas', 'Semuas0@ilovenus.com', 52087807, 95511104, 23111954, 0);
insert into Employees (eid, ename, email, home, phone, office, did) values (1, 'Donn', 'Donn1@ilovenus.com', 97347745, 57634275, null, 1);
insert into Employees (eid, ename, email, home, phone, office, did) values (2, 'Adriane', 'Adriane2@ilovenus.com', 46072806, 61210501, 21650107, 2);
insert into Employees (eid, ename, email, home, phone, office, did) values (3, 'Yolane', 'Yolane3@ilovenus.com', null, 35450235, 65595266, 3);
insert into Employees (eid, ename, email, home, phone, office, did) values (4, 'Jacqueline', 'Jacqueline4@ilovenus.com', 53850002, 47921732, 52116532, 0);
insert into Employees (eid, ename, email, home, phone, office, did) values (5, 'Paula', 'Paula5@ilovenus.com', null, 30162962, 65763936, 0);
insert into Employees (eid, ename, email, home, phone, office, did) values (6, 'Dukie', 'Dukie6@ilovenus.com', 25284293, 74881288, 47752861, 1);
insert into Employees (eid, ename, email, home, phone, office, did) values (7, 'Veda', 'Veda7@ilovenus.com', 96178253, 88279549, 29397038, 1);
insert into Employees (eid, ename, email, home, phone, office, did) values (8, 'Quintilla', 'Quintilla8@ilovenus.com', 81964694, 27390734, 78387189, 2);
insert into Employees (eid, ename, email, home, phone, office, did) values (9, 'Kimball', 'Kimball9@ilovenus.com', null, 42615309, 55287708, 2);
insert into Employees (eid, ename, email, home, phone, office, did) values (10, 'Lacey', 'Lacey10@ilovenus.com', 84960263, 23474737, null, 3);
insert into Employees (eid, ename, email, home, phone, office, did) values (11, 'Thalia', 'Thalia11@ilovenus.com', 70057524, 54611591, 34287578, 3);
insert into Employees (eid, ename, email, home, phone, office, did) values (12, 'Stan', 'Stan12@ilovenus.com', 52941167, 17081555, 91285021, 0);
insert into Employees (eid, ename, email, home, phone, office, did) values (13, 'Kimmi', 'Kimmi13@ilovenus.com', 95867972, 99531484, 14384585, 0);
insert into Employees (eid, ename, email, home, phone, office, did) values (14, 'Pauli', 'Pauli14@ilovenus.com', 54064156, 83490623, 95824800, 1);
insert into Employees (eid, ename, email, home, phone, office, did) values (15, 'Lucila', 'Lucila15@ilovenus.com', 78492733, 69266805, 35115840, 1);
insert into Employees (eid, ename, email, home, phone, office, did) values (16, 'Walton', 'Walton16@ilovenus.com', 14919719, 75985977, 51671799, 2);
insert into Employees (eid, ename, email, home, phone, office, did) values (17, 'Ogdan', 'Ogdan17@ilovenus.com', 45984958, 47010937, 32032874, 2);
insert into Employees (eid, ename, email, home, phone, office, did) values (18, 'Vere', 'Vere18@ilovenus.com', 73237410, 69121831, null, 3);
insert into Employees (eid, ename, email, home, phone, office, did) values (19, 'Huey', 'Huey19@ilovenus.com', 82950578, 36732148, 77046018, 3);

-- Junior
insert into Junior (eid) values (12), (13), (14), (15), (16), (17), (18), (19);

-- Booker
insert into Booker (eid) values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11);

-- Senior
insert into Senior (eid) values (4), (5), (6), (7), (8), (9), (10), (11);

-- Manager
insert into Manager (eid) values (0), (1), (2), (3);

-- Updates
insert into Updates ("date", room, "floor", capacity, eid) values (CURRENT_DATE - interval '3 day', 1, 0, 5, 0);
insert into Updates ("date", room, "floor", capacity, eid) values (CURRENT_DATE - interval '3 day', 2, 0, 5, 0);
insert into Updates ("date", room, "floor", capacity, eid) values (CURRENT_DATE - interval '3 day', 1, 1, 5, 1);
insert into Updates ("date", room, "floor", capacity, eid) values (CURRENT_DATE - interval '3 day', 2, 1, 5, 1);
insert into Updates ("date", room, "floor", capacity, eid) values (CURRENT_DATE - interval '3 day', 1, 2, 5, 2);
insert into Updates ("date", room, "floor", capacity, eid) values (CURRENT_DATE - interval '3 day', 2, 2, 5, 2);
insert into Updates ("date", room, "floor", capacity, eid) values (CURRENT_DATE - interval '3 day', 1, 3, 5, 3);
insert into Updates ("date", room, "floor", capacity, eid) values (CURRENT_DATE - interval '3 day', 2, 3, 5, 3);

-- HealthDeclaration
insert into HealthDeclaration (eid, "date", temp, fever) values (0, CURRENT_DATE - interval '3 day', 37.0, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (1, CURRENT_DATE - interval '3 day', 37.0, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (2, CURRENT_DATE - interval '3 day', 36.9, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (3, CURRENT_DATE - interval '3 day', 37.2, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (4, CURRENT_DATE - interval '3 day', 36.2, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (5, CURRENT_DATE - interval '3 day', 36.3, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (6, CURRENT_DATE - interval '3 day', 36.8, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (7, CURRENT_DATE - interval '3 day', 37.4, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (8, CURRENT_DATE - interval '3 day', 36.5, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (9, CURRENT_DATE - interval '3 day', 36.0, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (10, CURRENT_DATE - interval '3 day', 37.3, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (11, CURRENT_DATE - interval '3 day', 36.1, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (12, CURRENT_DATE - interval '3 day', 36.8, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (13, CURRENT_DATE - interval '3 day', 36.5, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (14, CURRENT_DATE - interval '3 day', 36.2, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (15, CURRENT_DATE - interval '3 day', 36.3, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (16, CURRENT_DATE - interval '3 day', 37.0, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (17, CURRENT_DATE - interval '3 day', 37.2, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (0, CURRENT_DATE - interval '2 day', 37.0, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (1, CURRENT_DATE - interval '2 day', 37.0, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (2, CURRENT_DATE - interval '2 day', 36.3, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (3, CURRENT_DATE - interval '2 day', 36.7, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (4, CURRENT_DATE - interval '2 day', 36.4, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (5, CURRENT_DATE - interval '2 day', 36.6, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (6, CURRENT_DATE - interval '2 day', 36.7, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (7, CURRENT_DATE - interval '2 day', 37.1, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (8, CURRENT_DATE - interval '2 day', 36.6, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (9, CURRENT_DATE - interval '2 day', 36.6, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (10, CURRENT_DATE - interval '2 day', 36.1, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (11, CURRENT_DATE - interval '2 day', 36.0, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (12, CURRENT_DATE - interval '2 day', 36.4, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (13, CURRENT_DATE - interval '2 day', 37.0, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (14, CURRENT_DATE - interval '2 day', 36.5, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (15, CURRENT_DATE - interval '2 day', 36.0, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (16, CURRENT_DATE - interval '2 day', 36.0, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (17, CURRENT_DATE - interval '2 day', 36.4, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (18, CURRENT_DATE - interval '2 day', 36.3, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (19, CURRENT_DATE - interval '2 day', 37.3, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (0, CURRENT_DATE - interval '1 day', 37.0, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (1, CURRENT_DATE - interval '1 day', 37.0, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (2, CURRENT_DATE - interval '1 day', 36.4, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (3, CURRENT_DATE - interval '1 day', 36.5, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (4, CURRENT_DATE - interval '1 day', 36.1, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (5, CURRENT_DATE - interval '1 day', 36.1, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (6, CURRENT_DATE - interval '1 day', 36.5, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (7, CURRENT_DATE - interval '1 day', 36.0, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (8, CURRENT_DATE - interval '1 day', 37.3, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (9, CURRENT_DATE - interval '1 day', 36.2, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (10, CURRENT_DATE - interval '1 day', 37.1, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (11, CURRENT_DATE - interval '1 day', 36.2, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (12, CURRENT_DATE - interval '1 day', 36.3, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (13, CURRENT_DATE - interval '1 day', 36.2, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (14, CURRENT_DATE - interval '1 day', 36.2, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (15, CURRENT_DATE - interval '1 day', 36.2, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (16, CURRENT_DATE - interval '1 day', 36.2, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (17, CURRENT_DATE - interval '1 day', 36.5, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (18, CURRENT_DATE - interval '1 day', 37.1, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (0, CURRENT_DATE, 36.4, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (2, CURRENT_DATE, 36.4, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (3, CURRENT_DATE, 36.5, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (4, CURRENT_DATE, 36.4, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (5, CURRENT_DATE, 36.1, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (6, CURRENT_DATE, 36.5, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (7, CURRENT_DATE, 36.0, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (8, CURRENT_DATE, 37.3, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (9, CURRENT_DATE, 36.8, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (10, CURRENT_DATE, 37.1, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (11, CURRENT_DATE, 36.3, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (12, CURRENT_DATE, 36.9, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (13, CURRENT_DATE, 36.5, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (14, CURRENT_DATE, 37.1, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (15, CURRENT_DATE, 36.4, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (16, CURRENT_DATE, 36.9, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (17, CURRENT_DATE, 37.4, false);
insert into HealthDeclaration (eid, "date", temp, fever) values (18, CURRENT_DATE, 36.9, false);

-- "Sessions"
-- "Session 1"
-- Consec timeslot -- Department '1' (Management Meeting) -- Booked Approved Manager -- Close_contact end limit
insert into "Sessions" ("time", "date", room, "floor", bid, approver) values (10, CURRENT_DATE - interval '3 day', 1, 1, 1, 1);
insert into "Sessions" ("time", "date", room, "floor", bid, approver) values (11, CURRENT_DATE - interval '3 day', 1, 1, 1, 1);
insert into "Sessions" ("time", "date", room, "floor", bid, approver) values (12, CURRENT_DATE - interval '3 day', 1, 1, 1, 1);
-- "Session 2"
-- 1 Representative from Junior, Senior, Manager meeting -- Department '0' -- Close_contact D-1
insert into "Sessions" ("time", "date", room, "floor", bid, approver) values (15, CURRENT_DATE - interval '1 day', 2, 0, 4, 0);
-- "Session 3"
-- Close_contact start_limit
insert into "Sessions" ("time", "date", room, "floor", bid, approver) values (21, CURRENT_DATE, 2, 1, 6, 1);
-- "Session 4"
-- Booked_by_close_contact Senior 6 (To be cancelled) - Pending
insert into "Sessions" ("time", "date", room, "floor", bid, approver) values (16, CURRENT_DATE + interval '1 day', 2, 1, 6, NULL);
-- "Session 5"
-- Booked_by_fever personnel Manager 1 (To be cancelled)
insert into "Sessions" ("time", "date", room, "floor", bid, approver) values (20, CURRENT_DATE + interval '5 day', 1, 1, 1, 1);
-- "Session 6"
-- Attended by 1 close_contact 
insert into "Sessions" ("time", "date", room, "floor", bid, approver) values (13, CURRENT_DATE + interval '7 day', 2, 3, 10, 3);
-- "Session 7"
-- exposure_end_date AFTER DAY 1 -- Hit Capacity Limit --
insert into "Sessions" ("time", "date", room, "floor", bid, approver) values (0, CURRENT_DATE + interval '8 day', 1, 2, 2, 2);

-- Participants
/* "Session 1" */
insert into Participants (eid, "time", "date", room, "floor") values (1, 10, CURRENT_DATE - interval '3 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (1, 11, CURRENT_DATE - interval '3 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (1, 12, CURRENT_DATE - interval '3 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (6, 10, CURRENT_DATE - interval '3 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (6, 11, CURRENT_DATE - interval '3 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (6, 12, CURRENT_DATE - interval '3 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (7, 10, CURRENT_DATE - interval '3 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (7, 11, CURRENT_DATE - interval '3 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (7, 12, CURRENT_DATE - interval '3 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (14, 10, CURRENT_DATE - interval '3 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (14, 11, CURRENT_DATE - interval '3 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (14, 12, CURRENT_DATE - interval '3 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (15, 10, CURRENT_DATE - interval '3 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (15, 11, CURRENT_DATE - interval '3 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (15, 12, CURRENT_DATE - interval '3 day', 1, 1);
/* "Session 2" */
insert into Participants (eid, "time", "date", room, "floor") values (4, 15, CURRENT_DATE - interval '1 day', 2, 0);
insert into Participants (eid, "time", "date", room, "floor") values (0, 15, CURRENT_DATE - interval '1 day', 2, 0);
insert into Participants (eid, "time", "date", room, "floor") values (12, 15, CURRENT_DATE - interval '1 day', 2, 0);
/* "Session 3" */
insert into Participants (eid, "time", "date", room, "floor") values (6, 21, CURRENT_DATE, 2, 1);
insert into Participants (eid, "time", "date", room, "floor") values (1, 21, CURRENT_DATE, 2, 1);
insert into Participants (eid, "time", "date", room, "floor") values (0, 21, CURRENT_DATE, 2, 1);
/* "Session 4" */
insert into Participants (eid, "time", "date", room, "floor") values (6, 16, CURRENT_DATE + interval '1 day', 2, 1);
/* "Session 5" */
insert into Participants (eid, "time", "date", room, "floor") values (1, 20, CURRENT_DATE + interval '5 day', 1, 1);
insert into Participants (eid, "time", "date", room, "floor") values (8, 20, CURRENT_DATE + interval '5 day', 1, 1);
/* "Session 6" */
insert into Participants (eid, "time", "date", room, "floor") values (10, 13, CURRENT_DATE + interval '7 day', 2, 3);
insert into Participants (eid, "time", "date", room, "floor") values (0, 13, CURRENT_DATE + interval '7 day', 2, 3);
insert into Participants (eid, "time", "date", room, "floor") values (7, 13, CURRENT_DATE + interval '7 day', 2, 3);
insert into Participants (eid, "time", "date", room, "floor") values (3, 13, CURRENT_DATE + interval '7 day', 2, 3);
/* "Session 7" */
insert into Participants (eid, "time", "date", room, "floor") values (2, 0, CURRENT_DATE + interval '8 day', 1, 2);
insert into Participants (eid, "time", "date", room, "floor") values (8, 0, CURRENT_DATE + interval '8 day', 1, 2);
insert into Participants (eid, "time", "date", room, "floor") values (9, 0, CURRENT_DATE + interval '8 day', 1, 2);
insert into Participants (eid, "time", "date", room, "floor") values (19, 0, CURRENT_DATE + interval '8 day', 1, 2);
insert into Participants (eid, "time", "date", room, "floor") values (0, 0, CURRENT_DATE + interval '8 day', 1, 2);
