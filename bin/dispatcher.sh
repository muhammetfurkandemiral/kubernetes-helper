#!/bin/bash

# Dispatches calls of commands and arguments
dispatcher ()
{
	arg="${1:-}"       # First argument
	short="${arg#*-}"  # First argument without trailing -
	long="${short#*-}" # First argument without trailing --

	# Exit and warn if no first argument is found
	if [ -z "$arg" ]; then
		"_no_arg_handler" # Call empty call placeholder
		return 1
	fi



	shift 1 # Remove namespace and first argument from $@

	# Detects if a command, --long or -short option was called
	if [ "$arg" = "--$long" ];then
		longname="${long%%=*}" # Long argument before the first = sign

		# Detects if the --long=option has = sign
		if [ "$long" != "$longname" ]; then
			longval="${long#*=}"
			long="$longname"
			set -- "$longval" "${@:-}"
		fi

		main_call=option_${long}


	elif [ "$arg" = "-$short" ];then
		main_call=option_${short}
	else
		main_call=command_${long}
	fi

	$main_call "${@:-}" && dispatch_returned=$? || dispatch_returned=$?

	if [ $dispatch_returned = 127 ]; then
		"_empty_call_handler" "$arg" # Empty placeholder
		return 1
	fi

	return $dispatch_returned
}
