## FAESH LOGGER: Fast And Easy baSH LOGGER (Work in Progress!)

#### Main Principle: Keep it Simple & Stupid

1. Create a log file a day
2. Keep the log files for x days (configurable)
3. Clean log files after x days

#### Logic flow:
1. ~~New day, new log file is required to be created~~
2. ~~Create new log file with today's date~~
3. Check if oldest log file exceeds retention period
	- if yes delete it

#### Functions
1. ~~new_logfile~~
	- creates a new log file
2. clean_logs
	- checks if oldest log file exceeds retention period
3. ~~check_latest_log~~
	- boolean statement
	- checks if today's log has been created
4. faeshlog
	- writes to log
5. get_date
	- get today's date
