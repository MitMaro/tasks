#!/bin/bash
: '
Tasks Switcher
A task list switcher for `t`

By: Tim Oram
'

# set some defaults
__TASKS_T_PATH=${__TASKS_T_PATH:-~/bin/t/t.py}
__TASKS_LIST_DIR=${__TASKS_LIST_DIR:-"~/.tasks"}
__TASKS_LIST_FILE=${__TASKS_LIST_FILE:-"tasks"}
__TASK_CURRENT_LIST_FILE=${__TASK_CURRENT_LIST_FILE:-".current_task_list"}

__TASKS_SHOW_PROBABILITY=${__TASKS_SHOW_PROBABILITY:-"10"} # note this is 10 not -10

__TASKS_DEFAULT_COUNT_COLOR=${__TASKS_DEFAULT_COUNT_COLOR:-"\033[1;37m"}
__TASKS_LOW_COUNT_COLOR=${__TASKS_LOW_COUNT_COLOR:-"\033[0;32m"}
__TASKS_MEDIUM_COUNT_COLOR=${__TASKS_MEDIUM_COUNT_COLOR:-"\033[1;33m"}
__TASKS_HIGH_COUNT_COLOR=${__TASKS_HIGH_COUNT_COLOR:-"\033[0;31m"}
__TASKS_NAME_COLOR=${__TASKS_NAME_COLOR:-"\033[1;33m"}
__TASKS_COLOR_NORMAL=${__TASKS_COLOR_NORMAL:-"\033[0;37m"}
__TASKS_COLOR_RESET=${__TASKS_COLOR_RESET:-"\033[0m"}

__TASKS_LOW_COUNT_LIMIT=${__TASKS_LOW_COUNT_LIMIT:-"2"}
__TASKS_MEDIUM_COUNT_LIMIT=${__TASKS_MEDIUM_COUNT_LIMIT:-"6"}
__TASKS_HIGH_COUNT_LIMIT=${__TASKS_HIGH_COUNT_LIMIT:-"14"}

__TASK_PS1_PREFIX=${__TASK_PS1_PREFIX:-"  ("}
__TASK_PS1_POSTFIX=${__TASK_PS1_POSTFIX:-")"}

__TASK_PROMPT_PREFIX=${__TASK_PROMPT_PREFIX:-"\n"}
__TASK_PROMPT_POSTFIX=${__TASK_PROMPT_POSTFIX:-"\n"}

# task list switcher/creator
tasks () {
	
	# if tasks directory does not exist create it, but check for a file
	if [ -f "$__TASKS_LIST_DIR" ]; then
		echo "__TASKS_LIST_DIR is a file, needs to be a directory"
	elif [ ! -d "$__TASKS_LIST_DIR" ]; then
		echo "Creating task directory: $__TASKS_LIST_DIR";
		mkdir "$__TASKS_LIST_DIR"
	fi
	
	# list tasks
	if [ "$1" == "-l" ]; then
		ls -1 $__TASKS_LIST_DIR
		return
	# simple help message
	elif [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
		echo "usage: tasks [name]"
		echo "       tasks -l"
		echo "       tasks -h"
		echo
		echo "Options:"
		echo " name  The name of a task list"
		echo " -l    List all task lists available"
		echo " -h    Show this message"
		echo ""
	# set current task list to the saved task
	elif [ "$1" == "" ]; then
		
		# if there is no current task file we just exit, doing nothing
		if [ ! -f "$__TASKS_LIST_DIR/$__TASK_CURRENT_LIST_FILE" ]; then
			return
		fi
		
		export __TASKS_LIST_FILE=`cat $__TASKS_LIST_DIR/$__TASK_CURRENT_LIST_FILE`
	# switch the task list
	else
		# if a new task file
		if [ ! -f "$__TASKS_LIST_DIR/$1" ]; then
			
			# prompt to create new list, return on no 
			read -n1 -p"List does not exists. Create? [y|N] " REPLY
			echo
			if [[ $REPLY != [yY] ]]; then
				return
			fi
		fi
		
		# set the task list file
		export __TASKS_LIST_FILE="$1"
		
		# save the current task file to a file
		echo $__TASKS_LIST_FILE > $__TASKS_LIST_DIR/$__TASK_CURRENT_LIST_FILE
	fi
	
	# create/update the alias
	alias t='python $__TASKS_T_PATH --task-dir $__TASKS_LIST_DIR --list $__TASKS_LIST_FILE $__TASKS_T_ARGS'
}

# load the default saved task list when this file is loaded
tasks

# prompt message for unfinished tasks
__tasks_prompt() {
	
	local task
	local task_count
	local rand=$((RANDOM%$__TASKS_SHOW_PROBABILITY+1)) 
	
	# only show the message 1 out of __TASKS_SHOW_PROBABILITY times
	if [ $rand -eq 1 ]; then
		task_count=`t | wc -l | sed -e's/ *//'`
		
		# no tasks, no point showing anything
		if [ $task_count -eq 0 ]; then
			return
		fi
		
		# pick a random number
		rand=$((RANDOM%$task_count+1))
		
		# get a random task
		task=`head -$rand $__TASKS_LIST_DIR/$__TASKS_LIST_FILE | tail -1 | awk -F"|" '{print \$1}'`
		
		# show a message on that task
		echo -e "$__TASK_PROMPT_PREFIX${__TASKS_COLOR_NORMAL}Have you forgotten about the task: $COLOR_YELLOW"\
$task "$__TASKS_COLOR_NORMAL?$__TASKS_COLOR_RESET$__TASK_PROMPT_POSTFIX"
		
	fi
}

# coloured task counts
__tasks_ps1() {
	
	# default color
	local color=$__TASKS_DEFAULT_COUNT_COLOR;
	local task_count=`t | wc -l | sed -e's/ *//'`
	
	# if no tasks, do nothing
	if (( $task_count < 1 )); then
		return
	fi
	
	# Show different colors depending on number of tasks not complete.
	if (( $task_count > $__TASKS_HIGH_COUNT_LIMIT )); then
		color=$__TASKS_HIGH_COUNT_COLOR;
	elif (( $task_count > $__TASKS_MEDIUM_COUNT_LIMIT )); then
		color=$__TASKS_MEDIUM_COUNT_COLOR;
	elif (( $task_count > $__TASKS_LOW_COUNT_LIMIT )); then
		color=$__TASKS_LOW_COUNT_COLOR;
	fi
	
	# add an 's' if more than one task
	if (( $task_count == 1 )); then
		echo -e "$__TASK_PS1_PREFIX$color$task_count Task$__TASKS_COLOR_NORMAL in $__TASKS_LIST_FILE$__TASKS_COLOR_RESET$__TASK_PS1_POSTFIX"
	else
		echo -e "$__TASK_PS1_PREFIX$color$task_count Tasks$__TASKS_COLOR_NORMAL in $__TASKS_LIST_FILE$__TASKS_COLOR_RESET$__TASK_PS1_POSTFIX"
	fi
}

