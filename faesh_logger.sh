get_date () {
	# Gets today's date in the YYYY-MM-DD format
	local _date=$(date '+%Y-%m-%d')
	echo $_date
}

new_logfile () {
	
	# The first parameter (string) will be the prefix of the logfile

	if [ -n "$1" ]; then	
		# if the first parameter (filename prefix) has been specified
		local filename_prefix="$1"
	else
		local filename_prefix="faeshlog"
	fi

	local filepath="logs/""$filename_prefix""_$(get_date).log"

	touch $filepath
}

clean_logs () {
	
	# The first parameter (string) will be the prefix of the logfile
	# The second parameter (integer) will be the retention period

	if [ "$2" -eq "$2" ]; then	
		# Check to make sure that the param is an integer
		local retention=$2
	else
		# If the passed value is not an integer (or no param was passed at all)
		# Use a default retention of 10 days
		local retention=10
	fi

	if [ -n "$1" ]; then	
		# if the first parameter (filename prefix) has been specified
		local filename_prefix="$1"
	else
		local filename_prefix="faeshlog"
	fi
	
	# find the date of x days ago, where x equals retention period
	local oldest_log_date=$(date '+%Y-%m-%d' -d "$retention days ago")
	local olddate=$(date -d $oldest_log_date +%s)

	# Grep the logs directory to find file names matching $filename_prefix
	for file in logs/*; do
		
		local filematch=$(echo $file | grep $filename_prefix | wc -l)
		
		if [ $filematch -ge 1 ]; then
			# If the filename matches the prefix, extract date of file via RegEx
			local str_filedate=$(echo "$file" | grep -Eo '[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}')
			local filedate=$(date -d $str_filedate +%s)
			
			# Compare the date of the log file with the retention period
			if [ "$olddate" -gt "$filedate" ]; then
				echo "\nFound log file older than $oldest_log_date - proceed to remove $file"
				rm $file
			fi
		fi
	done
}
