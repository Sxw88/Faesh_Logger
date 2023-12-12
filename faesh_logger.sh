get_date () {
	# Gets today's date in the YYYY-MM-DD format
	local _date=$(date '+%Y-%m-%d')
	echo $_date
}

get_retention_from_conf () {
	
	# NOTE: To use this function, you need to cast the returned value to an integer,
	# For example:
	#	retention_days=$(get_retention_from_conf)
	#	retention_days=$(($retention_days))

	# The first parameter (string) will be the prefix of the logfile

	if [ -n "$1" ]; then	
		# if the first parameter (filename prefix) has been specified
		local conf_filename_prefix="$1"
	else
		local conf_filename_prefix="faeshlog"
	fi

	source retention.conf

	local retention_conf_name=${conf_filename_prefix}_retention_days
	local retention_conf_value=${!retention_conf_name}
	
	if [ "$retention_conf_value" -eq "$retention_conf_value" ]; then
		local retention_conf_value=$(($retention_conf_value))
	else
		local retention_conf_value=10
	fi

	# If the retention period is not specified in retention_conf, or is an illegal value
	# return default value 10
	if [ "$retention_conf_value" -lt "1" ]; then
		echo 10	
	else
		echo $retention_conf_value
	fi
}

clean_logs () {
	
	# The first parameter (string) will be the prefix of the logfile
	# The second parameter (integer) will be the retention period
	
	if [ -n "$1" ]; then	
		# if the first parameter (filename prefix) has been specified
		local filename_prefix="$1"
	else
		local filename_prefix="faeshlog"
	fi
	
	if [ "$2" -eq "$2" ]; then	
		# Check to make sure that the param is an integer
		local retention=$2
	else
		# If the passed value is not an integer (or no param was passed at all)
		# Check retention.conf for any custom specified retention period
		local retention=$(get_retention_from_conf)
		local retention=$(($retention))
		# If the value can't be found in retention.conf,
		# A default retention of 10 days will be applied
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

faeshlog () {
	
	# The first parameter (string) will be the prefix of the logfile
	# The second parameter consists of the message to be logged

	if [ -n "$1" ]; then	
		# if the first parameter (filename prefix) has been specified
		local filename_prefix="$1"
	else
		local filename_prefix="faeshlog"
	fi

	local filepath="logs/""$filename_prefix""_$(get_date).log"
	
	if [ -f "$filepath" ]; then
		echo "$(date):$2" >> $filepath
	else
		echo "$(date):$2" > $filepath
		clean_logs
	fi
}
