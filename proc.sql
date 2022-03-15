\c cs2102_project

-- BASIC
CREATE OR REPLACE FUNCTION add_department(IN id INT, IN dpt_name TEXT)
RETURNS VOID AS 
$$ BEGIN
	INSERT INTO Departments VALUES (id, dpt_name);

END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION remove_department(IN id INT)
RETURNS VOID AS 
$$ BEGIN
	/* Checking no employees under department*/
	IF (id IN (SELECT DISTINCT did FROM Employees WHERE resign IS NOT NULL)) THEN RAISE EXCEPTION 'Employees with current department id still exist';

	/*Changing all MeetingRooms to be under Department 0 (HR/Management - report)*/
	ELSE UPDATE MeetingRooms SET did = 0 WHERE did = id;	

	DELETE FROM Departments WHERE did = id;
	END IF;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION add_room(IN floor_num INT, IN room_num INT, IN room_name TEXT, IN capacity INT, IN dept_id INT, IN manager_id INT)
RETURNS VOID AS 
$$ BEGIN
	IF ((SELECT did FROM Employees WHERE eid = manager_id) <> (dept_id))
	THEN RAISE EXCEPTION 'Only a manager in the same department can add a room for that department';
	ELSE
	INSERT INTO MeetingRooms VALUES (room_num, floor_num, room_name, dept_id);
	INSERT INTO Updates VALUES ((CURRENT_DATE), room_num, floor_num, capacity, manager_id);
	END IF;
END; $$ LANGUAGE plpgsql;

/*For reallocation of rooms in the event departments are removed and returned to HR*/
CREATE OR REPLACE FUNCTION update_room_did(IN room_num INT, IN floor_num INT, IN new_did INT) 
RETURNS VOID AS $$
BEGIN
	UPDATE MeetingRooms set did = new_did WHERE room = room_num AND "floor" = floor_num;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION change_capacity(IN floor_num INT, IN room_num INT, IN manager_id INT, IN new_capacity INT, IN curr_date DATE, 
IN change_date DATE)
RETURNS VOID AS 
$$ BEGIN
	/*Add in date_of_effect_of_update, check the date is not before today*/
	IF change_date <= curr_date THEN RAISE EXCEPTION 'Date is in the past';
	/*Must be a MANAGER*/
	ELSEIF manager_id NOT IN (SELECT eid FROM Manager) THEN RAISE EXCEPTION 'Employee is not a Manager';
	/*only manager in same department can change capacity*/
	ELSEIF ((SELECT did FROM Employees WHERE eid = manager_id) <> (SELECT did FROM MeetingRooms WHERE room = room_num AND "floor" = floor_num))
	THEN RAISE EXCEPTION 'Only a manager in same department as this room can change its capacity';
	
	ELSE 
	INSERT INTO Updates VALUES (change_date, room_num, floor_num, new_capacity, manager_id);
	
	
	END IF;
END; $$ LANGUAGE plpgsql;


/*remove all sessions that have more participants higher than new capacity*/
CREATE OR REPLACE FUNCTION check_capacity_constraint() RETURNS TRIGGER AS $$
BEGIN
	DELETE FROM "Sessions"
	WHERE room = NEW.room
	AND "floor" = NEW."floor" 
	AND "date" >= NEW."date"
	AND "time" IN(  SELECT ref."time"
			FROM (SELECT COUNT(eid) AS total_participants, "time", "date", room, "floor"
		                    	FROM Participants
					GROUP BY "time", "date", room, "floor") AS ref 
					WHERE ref."date" >= NEW."date"
					AND ref.room = NEW.room
					AND ref."floor" = NEW."floor"
					AND ref.total_participants > NEW.capacity);

	RETURN NULL;
END; $$ LANGUAGE plpgsql;


CREATE TRIGGER over_capacity
AFTER INSERT ON Updates
FOR EACH ROW EXECUTE FUNCTION check_capacity_constraint();


CREATE OR REPLACE FUNCTION add_employee(IN ename TEXT, IN home INT, IN phone INT, IN office INT, IN did INT, IN e_kind TEXT /*J or S or M*/)
RETURNS VOID AS $$
DECLARE
	email TEXT := '';
	eid INT := 0;
BEGIN
	IF did NOT IN (SELECT d.did FROM Departments d) THEN RAISE EXCEPTION 'Department does not exist';
	ELSEIF (e_kind <> 'S') AND (e_kind <> 'J') AND (e_kind <> 'M') THEN RAISE EXCEPTION 'Invalid Employee kind';
	ELSE
		IF ((SELECT COUNT(*) FROM Employees) <> 0) THEN eid := (SELECT MAX(e.eid) FROM Employees e) + 1;
		END IF;
		email := (SELECT CONCAT(ename, eid, '@ilovenus.com')); -- Auto generated email 
		INSERT INTO Employees VALUES (eid, ename, email, home, phone, office, NULL, did, NULL);
	END IF;

	IF (e_kind = 'J') THEN INSERT INTO Junior VALUES(eid);
	ELSE 	INSERT INTO Booker VALUES(eid); -- Not Junior means can book
		IF (e_kind = 'S') THEN INSERT INTO Senior VALUES(eid);
		ELSE INSERT INTO Manager VALUES(eid);	
		END IF;
	END IF;

END; $$ LANGUAGE plpgsql;


/*Update employee info */
CREATE OR REPLACE FUNCTION update_enfo(IN change_type TEXT, IN new_value INT, IN eid_to_change INT) /*change type - home(H), phone(P), office(O), did(D)*/
RETURNS VOID AS $$
BEGIN
	IF (change_type = 'H') THEN UPDATE Employees SET home = new_value WHERE eid = eid_to_change;
	ELSEIF (change_type = 'P') THEN UPDATE Employees SET phone = new_value WHERE eid = eid_to_change;
	ELSEIF (change_type = 'O') THEN UPDATE Employees SET office = new_value WHERE eid = eid_to_change;
	ELSEIF (change_type = 'D') THEN UPDATE Employees SET did = new_value WHERE eid = eid_to_change;
	ELSE RAISE EXCEPTION 'Invalid variable type input';
	END IF;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION remove_employee(IN del_eid INT)
RETURNS VOID AS 
$$ BEGIN
	UPDATE Employees 
	SET resign = (SELECT(CURRENT_DATE))
	WHERE eid = del_eid;	
END; $$ LANGUAGE plpgsql;


/*RESIGN -> 
	they are no longer allowed to book or approve any meetings rooms. Additionally, any future records (e.g., future
meetings) are removed. create tigger to auto do this after employee remove*/
CREATE OR REPLACE FUNCTION resign_from_meetings() RETURNS TRIGGER AS $$
BEGIN
	IF (NEW.resign IS NOT NULL) THEN 
	DELETE FROM "Sessions" WHERE bid = NEW.eid AND "date" >= (SELECT(CURRENT_DATE));
	DELETE FROM Participants WHERE eid = NEW.eid AND "date" >= (SELECT(CURRENT_DATE));
	END IF;
	RETURN NEW;
END; $$ LANGUAGE plpgsql;


CREATE TRIGGER resign_meetings
AFTER UPDATE ON Employees
FOR EACH ROW EXECUTE FUNCTION resign_from_meetings();


-- CORE
CREATE OR REPLACE FUNCTION search_room(IN cap INT, IN bdate DATE, IN start_hour INT, IN end_hour INT)
RETURNS TABLE (rfloor INT, mroom INT, dept INT, capa INT) AS $$
BEGIN
	RETURN QUERY WITH Occupied AS (
		SELECT DISTINCT "floor", room
		FROM "Sessions" 
		WHERE "time" >= start_hour AND "time" < end_hour AND "date" = bdate
	)
	SELECT a."floor", a.room, b.did, c.capacity
	FROM ((SELECT "floor", room FROM MeetingRooms) EXCEPT (SELECT * FROM Occupied)) a,
		MeetingRooms b, Updates c
	WHERE a."floor" = b."floor" AND a."room" = b."room"
	AND a."floor" = c."floor" AND a."room" = c."room"
	AND capacity >= cap
	ORDER BY capacity;	
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION book_room(IN rfloor INT, IN mroom INT, IN bdate DATE, IN start_hour INT, IN end_hour INT, IN booker INT)
RETURNS VOID AS $$
DECLARE
	today DATE := (SELECT CURRENT_DATE);
	fever BOOLEAN := (SELECT fever FROM HealthDeclaration WHERE (eid = booker AND "date" = today));
	resign_date DATE := (SELECT resign FROM Employees WHERE eid = booker);
	eed DATE := (SELECT COALESCE(exposure_end_date,CURRENT_DATE-1) FROM Employees WHERE eid = booker);
	avail BOOLEAN := TRUE;
	hour INT := start_hour;
BEGIN
	IF (end_hour = 0) THEN end_hour := 24; 
	END IF;
	WHILE hour < end_hour LOOP
		IF ((SELECT EXISTS(SELECT * from "Sessions" WHERE "time" = hour AND "date" = bdate AND room = mroom AND "floor" = rfloor) = TRUE)) THEN 
			avail := FALSE;
		END IF;
		hour := hour + 1;
	END LOOP;

	hour := start_hour;

	IF (SELECT booker IN (SELECT eid FROM Booker)) THEN
		IF (resign_date IS NULL) THEN
			IF (fever = FALSE) THEN
				IF (eed < today) THEN
					IF (avail = TRUE) THEN
						WHILE hour < end_hour LOOP
							INSERT INTO "Sessions"("time", "date", room, "floor", bid) VALUES (hour, bdate, mroom, rfloor, booker);
							INSERT INTO Participants(eid, "time", "date", room, "floor") VALUES (booker, hour, bdate, mroom, rfloor);
							hour := hour + 1;
						END LOOP;
					ELSE RAISE EXCEPTION 'Meeting room not available!';
					END IF;
				ELSE RAISE EXCEPTION 'You are a close contact of a recent fever case. You cannot book a room today!';
				END IF;
			ELSEIF (fever IS NULL) THEN RAISE EXCEPTION 'You have not declared your temperature. You cannot book a room!';
			ELSE RAISE EXCEPTION 'You are having a fever. You cannot book a room today!';
			END IF;
		ELSE RAISE EXCEPTION 'You are no longer an employee. You cannot book a room!';
		END IF;
	ELSE RAISE EXCEPTION 'You are a junior employee. You cannot book a room!';
	END IF;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION unbook_room(IN rfloor INT, IN mroom INT, IN bdate DATE, IN start_hour INT, IN end_hour INT, IN bookerid INT)
RETURNS VOID AS $$
DECLARE
	hour INT := start_hour;
	resign_date DATE := (SELECT resign FROM Employees WHERE eid = bookerid);
BEGIN
	IF (end_hour = 0) THEN end_hour := 24;
	END IF;
	IF (resign_date IS NOT NULL) THEN RAISE EXCEPTION 'You are no longer an employee!';
	END IF;
	WHILE hour < end_hour LOOP
		-- ON DELETING SESSION, ALL PARTICIPANTS IN THE SESSION WILL BE REMOVED FROM THE PARTICIPANTS TABLE
		DELETE FROM "Sessions" WHERE ("time" = hour AND "date" = bdate AND room = mroom AND "floor" = rfloor AND bid = bookerid);
		hour := hour + 1;
	END LOOP;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION join_meeting(IN rfloor INT, IN mroom INT, IN bdate DATE, IN start_hour INT, IN end_hour INT, IN employee INT)
RETURNS VOID AS $$
DECLARE
	today DATE := (SELECT CURRENT_DATE);
	fever BOOLEAN := (SELECT fever FROM HealthDeclaration 
					WHERE eid = employee AND "date" = today);
	approver INT := (SELECT COALESCE(approver,0) FROM "Sessions" 
					WHERE "time" = start_hour AND "date" = bdate AND room = mroom AND "floor" = rfloor);
	participants INT := (SELECT COUNT(*) FROM Participants
					WHERE "time" = start_hour AND "date" = bdate AND room = mroom AND "floor" = rfloor);
	capacity INT := (SELECT capacity FROM Updates 
					WHERE room = mroom AND "floor" = rfloor AND "date" <= today ORDER BY "date" DESC LIMIT 1);
	resign_date DATE := (SELECT resign FROM Employees WHERE eid = employee);
	eed DATE := (SELECT COALESCE(exposure_end_date,CURRENT_DATE-1) FROM Employees WHERE eid = employee);
	hour INT := start_hour;
BEGIN
	IF (end_hour = 0) THEN end_hour := 24;
	END IF;
	WHILE hour < end_hour LOOP
		IF (fever = FALSE) THEN
			IF (approver = 0) THEN
				IF (participants+1 <= capacity) THEN
					IF (resign_date IS NULL) THEN
						IF (eed < today) THEN
							INSERT INTO Participants VALUES (employee, hour, bdate, mroom, rfloor);
						ELSE RAISE EXCEPTION 'You are a close contact of a recent fever case. You cannot join the meeting!';
						END IF;
					ELSE RAISE EXCEPTION 'You are no longer an employee. You cannot join the meeting!';
					END IF;
				ELSE RAISE EXCEPTION 'The room has reached its maximum capacity. You cannot join the meeting!';
				END IF;
			ELSE RAISE EXCEPTION 'This meeting has been approved. You cannot join the meeting!';
			END IF;
		ELSE RAISE EXCEPTION 'You are having a fever. You cannot join the meeting!';
		END IF;
		hour := hour + 1;
	END LOOP;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION leave_meeting(IN rfloor INT, IN mroom INT, IN bdate DATE, IN start_hour INT, IN end_hour INT, IN employee INT)
RETURNS VOID AS $$
DECLARE
	approver INT := (SELECT COALESCE(approver,0) FROM "Sessions" 
					WHERE "time" = start_hour AND "date" = bdate AND room = mroom AND "floor" = rfloor);
	hour INT := start_hour;
BEGIN
	IF (end_hour = 0) THEN end_hour := 24;
	END IF;
	WHILE hour < end_hour LOOP
		IF (approver = 0) THEN DELETE FROM Participants WHERE ("time" = hour AND "date" = bdate AND room = mroom AND "floor" = rfloor AND eid = employee);
		ELSE RAISE EXCEPTION 'This meeting has been approved. You cannot leave the meeting!';
		END IF;
		hour := hour + 1;
	END LOOP;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION approve_meeting(IN rfloor INT, IN mroom INT, IN bdate DATE, IN start_hour INT, IN end_hour INT, IN mid INT)
RETURNS VOID AS $$
DECLARE
	booker INT := (SELECT bid FROM "Sessions" WHERE ("time" = start_hour AND "date" = bdate AND room = mroom AND "floor" = rfloor));
	booker_dept INT := (SELECT did FROM Employees WHERE eid = booker);
	manager_dept INT := (SELECT e.did FROM Employees e JOIN Manager m ON (e.eid = m.eid AND e.eid = mid));
	resign_date DATE := (SELECT resign FROM Employees WHERE eid = mid);
	hour INT := start_hour;
BEGIN
	IF (end_hour = 0) THEN end_hour := 24;
	END IF;
	IF (manager_dept IS NULL) THEN RAISE EXCEPTION 'You are not a manager! You cannot approve the meeting!';
	END IF;
	WHILE hour < end_hour LOOP
		IF (booker_dept = manager_dept) THEN 
			IF (resign_date IS NULL) THEN
				UPDATE "Sessions"
				SET approver = mid
				WHERE ("time" = hour AND "date" = bdate AND room = mroom AND "floor" = rfloor AND bid = booker);
			ELSE RAISE EXCEPTION 'You are no longer an employee. You cannot approve the meeting!';
			END IF;
		ELSE RAISE EXCEPTION 'You and the booker are not from the same department!';
		END IF;
		hour := hour + 1;
	END LOOP;
END; $$ LANGUAGE plpgsql;


/* Giving the manager the responsibility to delete meetings that are pending so as to free up the slot */
CREATE OR REPLACE FUNCTION reject_meeting(IN rfloor INT, IN mroom INT, IN bdate DATE, IN start_hour INT, IN end_hour INT, IN mid INT)
RETURNS VOID AS $$
DECLARE
	booker INT := (SELECT bid FROM "Sessions" WHERE ("time" = start_hour AND "date" = bdate AND room = mroom AND "floor" = rfloor));
	booker_dept INT := (SELECT did FROM Employees WHERE eid = booker);
	manager_dept INT := (SELECT e.did FROM Employees e JOIN Manager m ON (e.eid = m.eid AND e.eid = mid));
	resign_date DATE := (SELECT resign FROM Employees WHERE eid = mid);
	hour INT := start_hour;
BEGIN
	IF (end_hour = 0) THEN end_hour := 24;
	END IF;
	IF (manager_dept IS NULL) THEN RAISE EXCEPTION 'You are not a manager! You cannot reject the meeting!';
	END IF;
	WHILE hour < end_hour LOOP
		IF (booker_dept = manager_dept) THEN 
			IF (resign_date IS NULL) THEN
				DELETE FROM "Sessions"
				WHERE ("time" = hour AND "date" = bdate AND room = mroom AND "floor" = rfloor AND bid = booker);
			ELSE RAISE EXCEPTION 'You are no longer an employee. You cannot reject the meeting!';
			END IF;
		ELSE RAISE EXCEPTION 'You and the booker are not from the same department!';
		END IF;
		hour := hour + 1;
	END LOOP;
END; $$ LANGUAGE plpgsql;


-- HEALTH
CREATE OR REPLACE FUNCTION update_fever_status()
RETURNS TRIGGER AS $$
BEGIN
	IF (NEW.temp > 37.5) THEN NEW.fever := true;
	ELSE NEW.fever := false;
	END IF;
	RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER fever_update
BEFORE INSERT ON HealthDeclaration
FOR EACH ROW EXECUTE FUNCTION update_fever_status();


CREATE OR REPLACE FUNCTION declare_health
	(IN employee_id INT, IN temperature FLOAT)
RETURNS VOID AS $$ 
DECLARE
	declaration_date DATE = (SELECT CURRENT_DATE);
BEGIN
	IF (SELECT EXISTS(SELECT 1 FROM Employees WHERE eid = employee_id AND (resign IS NULL) = false)) 
	THEN RAISE EXCEPTION 'Employee % has already resigned as of %', employee_id, (SELECT resign FROM Employees WHERE eid = employee_id) USING HINT = 'INVALID EMPLOYEE';
	END IF;

	IF (temperature BETWEEN 34 AND 43) THEN  
		INSERT INTO HealthDeclaration(eid, "date", temp) VALUES(employee_id, declaration_date, temperature);
	ELSE RAISE EXCEPTION 'Invalid Temperature ---> %', temperature USING HINT = 'Temperature must be between 34 and 43 degrees';
	END IF;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION contact_tracing
	(IN employee_id INT, IN trace_from DATE)
RETURNS TABLE(contacted INT) AS 
$$ BEGIN
	/*Check if health declaration was done by the employee*/
	IF (SELECT EXISTS(SELECT 1 FROM HealthDeclaration WHERE eid = employee_id AND "date" = trace_from)) THEN 
		/*Check if that employee has a fever on the given date*/
		IF(SELECT EXISTS(SELECT 1 FROM HealthDeclaration WHERE eid = employee_id AND "date" = trace_from AND fever = true)) THEN
			CREATE TEMP TABLE contacted AS
				WITH meetings_attended AS ( 
					SELECT "time", "date", room, "floor" 
					FROM Participants 
					WHERE eid = employee_id AND ("date" BETWEEN trace_from - interval '3 day' AND trace_from) 
				) 
				SELECT DISTINCT eid AS contacts
				FROM Participants p RIGHT JOIN meetings_attended ma
				ON p."time" = ma."time" AND p."date" = ma."date" 
				AND p.room = ma.room AND p."floor" = ma."floor" AND eid<>employee_id
			;
			RETURN QUERY SELECT contacts FROM contacted;
			DROP TABLE IF EXISTS contacted; 
		ELSE RAISE EXCEPTION 'Employee % did not have fever on %', employee_id, trace_from;
		END IF;
	ELSE RAISE EXCEPTION 'Employee % did not declare health on %', employee_id, trace_from USING HINT = 'No records found';
	END IF;
END; 
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_contact_tracing()
RETURNS TRIGGER AS $$
BEGIN
	/*First cancel all future rooms booked by this Employee*/
	DELETE FROM "Sessions" AS s WHERE s.bid = NEW.eid AND s."date" > NEW."date";
	/*Remove employee from all future meetings that he is not the booker*/
	DELETE FROM Participants AS p WHERE p.eid = NEW.eid AND p."date" > NEW."date";
	CREATE TEMP TABLE close_contacts ON COMMIT DROP AS
		SELECT contact_tracing(NEW.eid, NEW."date")
	;
	/*Edit exposure end_date for close contacts*/
	UPDATE Employees AS e SET exposure_end_date = (NEW."date" + interval '7 day') WHERE e.eid IN (SELECT contact_tracing FROM close_contacts);
	/*Remove employees contacted from meeting for next 7 days*/
	DELETE FROM "Sessions" AS s WHERE s.bid IN (SELECT contact_tracing FROM close_contacts) AND ("date" BETWEEN (NEW."date" + interval '1 day') AND (NEW."date" + interval '7 day'));
	DELETE FROM Participants AS p WHERE p.eid IN (SELECT contact_tracing FROM close_contacts) AND ("date" BETWEEN (NEW."date" + interval '1 day') AND (NEW."date" + interval '7 day'));
	RETURN NEW;
END; $$ LANGUAGE plpgsql;


CREATE TRIGGER fever_check
AFTER INSERT ON HealthDeclaration
FOR EACH ROW WHEN (NEW.fever = true)
EXECUTE FUNCTION update_contact_tracing();


-- ADMIN
CREATE OR REPLACE FUNCTION non_compliance
	(IN "start_date" DATE, IN end_date DATE)
RETURNS TABLE(eid INT, "count" BIGINT) AS $$
#variable_conflict use_column
DECLARE
	"days" INT := end_date - "start_date" + 1;	
BEGIN
	return query 
	SELECT eid, "days" - COUNT(*) as "count" /* days is the 'correct' number of entries. count(*) is number of entries. we take the difference */
	FROM HealthDeclaration
	WHERE "date" >= "start_date"
	AND "date" <= end_date
	GROUP BY eid 
	HAVING COUNT(*) <> "days" /* exclude employees who have the 'correct' number of entries. */
	ORDER BY "count" DESC ; /* order by decreasing number of days, as stipulated */
	
END; 
$$ LANGUAGE plpgsql;


/* This function doesn't change approval status to boolean. Hence approved status is determined by whether the 'approved' column is NULL (not approved) or an integer (approved) */
CREATE OR REPLACE FUNCTION view_booking_report
	(IN "start_date" DATE, IN eid INT) 
RETURNS TABLE ("floor" INT, room INT, "date" DATE, hour INT, approved INT) AS $$
#variable_conflict use_column
BEGIN
RETURN QUERY WITH SessionsRaw AS (
		SELECT "floor", room, "date", "time", approver
		FROM "Sessions" s
		WHERE s.bid = eid
		AND s."date" >= "start_date"
	)
	SELECT *
	FROM SessionsRaw  
	ORDER BY "date", "time"; /* order by date and times in ascending order, as stipulated */
END; 
$$ LANGUAGE plpgsql;


/* participants table contains all approved meetings already, hence no need to check if approved anot */
/* note input eid is defined as eid1. This is to avoid p.eid = eid in the query, which will reference p.eid itself i.e simply returns meetings from start_date on and ignoring input eid */
CREATE OR REPLACE FUNCTION view_future_meeting
	(IN "start_date" DATE, IN eid1 INT)
RETURNS TABLE ("floor" INT, room INT, "date" DATE, start_hour INT) AS $$
#variable_conflict use_column
BEGIN
RETURN QUERY
SELECT "floor",room, "date", "time"
FROM participants p NATURAL JOIN "Sessions" s
WHERE p.eid = eid1
AND p.date >= "start_date" AND s.approver IS NOT NULL  
ORDER BY "date", "time";
END; 
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION view_manager_report
	(IN "start_date" DATE, eid1 INT)
RETURNS TABLE("floor" INT, room INT, "date" DATE, start_hour INT, eid INT) AS $$ 
#variable_conflict use_column
/* no need for trigger : query will naturally return empty table if ied is not that of a manager's */
DECLARE
	m_did INT := (SELECT did FROM employees NATURAL JOIN manager WHERE eid = eid1); /* get manager's dept id */
BEGIN
RETURN QUERY /*WITH ManagerInfo AS (select * from employees natural join manager where eid = eid1)*/
SELECT "floor", room, "date", "time", bid
FROM "Sessions" natural join meetingrooms
WHERE did = m_did
AND "date" >= "start_date"
AND approver IS NULL ;
	
END; 
$$ LANGUAGE plpgsql;
