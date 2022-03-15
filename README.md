# cs2102-project

## Setting up Database Locally (PSQL)

1. Open your Command Line Interface (CLI) in the SQL folder directory
2. Load the SQL dump into your psql using the following commands:  

Create a database cs2102_project in your postgres and the relevant tables)  
> `psql -U postgres -f schema.sql`  

Add the relevant data to the tables  
> `psql -U postgres -f data.sql`  

Add the function to the database
> `psql -U postgres -f proc.sql`

3. Connect to database `psql -U postgres -d cs2102_project` and execute queries directly there.

4. Once connected, you can do `\d` to check if the tables are created correctly.

## NOTES REGARDING SCHEMA

Overlapping keywords (Use quotations for reference)  

- "floor"
- "date"
- "Sessions"
- "time"

## DUMMY DATA SPECIFICS

### Settings

- Company 1st Day: D-3 (3 Days before your CURRENT_DATE)  
- Current Date: D-DAY (THE DATE ON YOUR COMPUTER)  

### Departments

Department ID: 0-indexed  

0. Human Resource
1. Management
2. Marketing
3. Operations  

### Employees

Employee ID: 0-indexed  
Total number of Employees: 20  
Each Department:  

- 2 Juniors
- 2 Seniors
- 1 Manager  

### Meeting Rooms

- Floors: 4 (0-indexed)  
- Rooms per Floor: 2 (1-indexed)  
- Rooms per Dpt: 2 (Same as Floor Number)  

### Updates

Initial Capacity: 5  
Update ID: Manager of their respective Dpts  
Update Date: D-3 (Company Start Date)  

### Sessions

("time", "date", room, "floor", bid, approver)  
"Session 1":  
(10, D-3, 1, 1, 1, 1);  
(11, D-3, 1, 1, 1, 1);  
(12, D-3, 1, 1, 1, 1);  
-- Close_contact END LIMIT  
-- Consec timeslot  
-- Booked approved both manager  
-- All personnels (1, 6, 7, 14, 15) from department '1'  

"Session 2":  
(15, D-1, 2, 0, 4, 0)  
-- Close_contact D-1  

"Session 3":  
(21, D-Day, 2, 1, 6, 1)
-- Close_contact START LIMIT  
-- Fever personnel (Manager 1)  

"Session 4":  
 (16, D+1, 2, 1, 6, NULL)  
-- exposure_end_date START LIMIT  
-- Booked by close_contact 6 (To be Cancelled)  
-- 1 Attendie  

"Session 5":  
(20, D+5, 1, 1, 1, 1)  
-- Booked by fever personnel 1 (To be Cancelled)  
-- 2 Attendies  

"Session 6":  
(13, D+7, 2, 3, 10, 3)  
-- exposure_end_date END LIMIT  
-- Attended by 2 close_contact (Manager 1, Senior 7)  

"Session 7"  
(0, D+8, 1, 2, 2, 2)  
-- exposure_end_date AFTER DAY 1  
-- Hit capacity limit  
-- Attended by 1 close_contact (Manager 1)  

### Health Declaration

Non-Compliance:  
Junior 18 - 1 day (D-3)  
Junior 19 - 3 days (D-3, D-1, D-day)  
Manager 1 - 1 day (D-day)

### Participation List

Current total number of Participants: 33  
**Active personnels for fever/resign function testing**

Fever Testing
Health Declaration Not Done D-DAY:  

Manager 1  
-- Attended Session: 1, 3  
-- Upcoming Session: 5  
-- Close contact <0, 6, 7, 14, 15>  
-- Close contact Session: 4, 6, 7  
-- Total participants removal: 5 (Session 4, 5, 6)  
-- Total "Sessions" removal : 2 (Session 4, 5)

Junior 19  
-- Upcoming Session: 7 (D+8)  
-- Total "Sessions" removal: 0  
-- Total participants removal: 1

## Authors

Group 88:

- Gordon Tham Qi Hao
- Jasin Chow Si Yuan
- Keith Tay Xiang Rui
- Tay Wei Hong, Allan

Tech Stack:

- Database: PostgresSQL
