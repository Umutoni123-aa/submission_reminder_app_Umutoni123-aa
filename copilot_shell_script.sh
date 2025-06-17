#!/bin/bash

read -p "Enter the same name as used in the environment folder name: " user_name

if [ -z "$user_name" ]; then
    echo "Please enter your name."
    echo "--------------------------"
    echo "Exiting..."
    exit 1
fi

if ! [[ "$user_name" =~ ^[a-zA-Z\s]+$ ]]; then
    echo "NO NUMBERS."
    exit 1
fi
dir="submission_reminder_$user_name"
submissions_file="$dir/assets/submissions.txt"
config_file="$dir/config/config.env"

if [ ! -d "$dir" ]; then
    echo "Directory '$dir' not found."
    echo "You should run create_environment.sh first."
    exit 1
fi

# Checking if the directory exists
read -p "Enter the assignment name: " assignment
read -p "Enter the number of days remaining: " days_remaining

# Sanitazing the varibales input
assignment=$(echo "$assignment" | sed "s/$(echo -e '\u00a0')/ /g" | tr -cd '[:alnum:] [:space:]' | xargs)
days_remaining=$(echo "$days_remaining" | xargs)

# Input validation

# Checking if the name is not empty and that the Days are numbers
if [ -z "$assignment" ] || ! [[ "$days_remaining" =~ ^[0-9]+$ ]]; then
    echo "Assignment name should not be empty." 
    echo "The Days must be a NUMBERS."
    exit 1
fi

if ! echo "$assignment" | grep -qE '^[A-Za-z ]+$'; then
    echo "Assignment name must contain only LETTERS and SPACES."
    exit 1
fi

# Checking if the Assignment name ain't numerical
matched_assignment=$(grep -i ", *$assignment," "$submissions_file" | awk -F',' '{print $2}' | head -n1 | xargs)

if [ -z "$matched_assignment" ]; then
    echo "Assignment '$assignment' not found in $submissions_file."
    echo "Try again."
    exit 1
fi

# Update config.env
echo "Updating config.env in $config_file"
echo "ASSIGNMENT=\"$matched_assignment\"" > "$config_file"
echo "DAYS_REMAINING=$days_remaining" >> "$config_file"

echo "Configuration updated:"
cat "$config_file"
echo ""

# Ask if they want to start the app
read -p "Would you like to run the reminder app now? (y/n): " run_choice

if [[ "$run_choice" =~ ^[Yy]$ ]]; then
    echo "Starting reminder app..."
    bash "$dir/startup.sh"
    echo "App finished running."
else
    echo "You can run the app later with:"
    echo "bash $dir/startup.sh"
fi

