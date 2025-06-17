#!/bin/bash
# Startup script for Submission Reminder App
APP_PATH="$(dirname "$0")/app/reminder.sh"
if [ -x "$APP_PATH" ]; then
	bash "$APP_PATH"
else
	echo "reminder.sh not fount or not executable"
	exit 1
fi
