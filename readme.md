## FAESH LOGGER: Fast And Easy baSH LOGGER (Work in Progress!)

#### Main Principle: Keep it Simple & Stupid

1. Write to log file using a bash function - Log files naming convention: <log_prefix>_<date>.log
2. Keep the log files for x days (configurable in retention.conf, can be overridden via the function)
3. Remove the oldest log files after x days

#### Logic flow:
1. When writing logs to a log file, check if the log file already exists
2. If yes, create a new log file - and clean up logs
3. Check if oldest log file exceeds retention period
	- if yes delete it

#### Functions
1. get_date
	- get today's date
2. get_retention_from_conf
	- gets configured retention period from retention.conf
2. clean_logs
	- checks if oldest log file exceeds retention period
4. faeshlog
	- writes to log
