# tasks

`tasks` is a list switcher for the fantastic task manager [[t by steve losh|http://stevelosh.com/projects/t/]]. `tasks` also comes with a prompt string function that will output the number of tasks you have incomplete. The output is color coded depending on the number of tasks you have incomplete. There is also a prompt command that will display a reminder message on an incomplete task at random intervals.

## Why Write This?

I wanted to be able to change the list that `t` works on without any hassle. I usually keep a different task list for work and personal and switch daily.

## Installing tasks

**Installing `tasks` is really easy:**

[[Install t|http://stevelosh.com/projects/t/#installing-t]]

Grab a copy using `git clone`

Modify your .bashrc and add the following lines:

    export __TASKS_T_PATH="/path/to/t.py"
    source "/path/to/tasks.sh"

## Optional Installs

### Install the Reminder Messages
In your .bashrc file add the following line below the rest of the setup:

    PROMPT_COMMAND=$PROMPT_COMMAND"__tasks_prompt;"

### PS1 Function
In your .bashrc file add something like the following line below the rest of the setup:

    export PS1="$PS1 \$(__tasks_ps1)"

## Usage

### tasks command
    usage: tasks [name]
           tasks -l
           tasks -h

    Options:
     name  The name of a task list
     -l    List all task lists available
     -h    Show this message

## Configuration

`tasks` is highly configurable, I tried to make everything I could think of user changeable. Below is a list of configuration options. To set an option just add `export __OPTION_NAME__=value` to your .bashrc file.

###__TASKS_T_PATH
The path to the `t` python file. Default: `~/bin/t/t.py`

###__TASKS_LIST_DIR
The directory where the `t` list files are saved. I recommend using a [[Dropbox|http://db.tt/UpKcGyU]] folder. Default: `~/.tasks`

###__TASK_CURRENT_LIST_FILE
The name of the file to save the current list name. This file is created inside the __TASKS_LIST_DIR. Default:`.current_task_list`

###__TASKS_SHOW_PROBABILITY
The probability that the task reminder message will be displayed. The higher the value the less likely the message will display. A setting of 1 will always show the message. Default:`10`

###__TASKS_DEFAULT_COUNT_COLOR
The default colour used in the `PS1` display for task counts when the count is below the low threshold. Default:`\033[1;37m`

###__TASKS_LOW_COUNT_COLOR
The colour used in the `PS1` display for task counts when the count is within the low threshold. Default:`\033[0;32m`

###__TASKS_MEDIUM_COUNT_COLOR
The colour used in the `PS1` display for task counts when the count is within the medium threshold. Default:`\033[1;33m`

###__TASKS_HIGH_COUNT_COLOR
The colour used in the `PS1` display for task counts when the count is greater than the high threshold. Default:`\033[0;31m`

###__TASKS_NAME_COLOR
The colour used for the task name in the task reminder message. Default: `\033[1;33m`

###__TASKS_COLOR_NORMAL
The colour used for miscellaneous text. Default: `\033[0;37m`

###__TASKS_COLOR_RESET
The reset colour. I have had issues with the "default" color not working in my terminal. This setting allows you to override the reset color code. Default:`\033[0m`

###__TASKS_LOW_COUNT_LIMIT
The lower threshold for the task count to be considered low. Default: `2`

###__TASKS_MEDIUM_COUNT_LIMIT
The lower threshold for the task count to be considered medium. Default: `6`

###__TASKS_HIGH_COUNT_LIMIT
The lower threshold for the task count to be considered high. Default: `14`

###__TASK_PS1_PREFIX
The value to prefix the PS1 output. Default: `  (`

###__TASK_PS1_POSTFIX
The value to postfix the PS1 output. Default: `)`

###__TASK_PROMPT_PREFIX
The value to prefix the reminder message with. Default: `\n`

###__TASK_PROMPT_POSTFIX
The value to postfix the reminder message with. Default: `\n`
