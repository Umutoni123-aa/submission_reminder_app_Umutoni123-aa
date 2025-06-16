#!/bin/bash
 #ask the user to enter the name 
 echo "The directory has to have a name"
 read -p "Please, Enter your directory name: " name

 if [ -z "$name" ]; then
	 echo "Please enter your name."
	 echo "The input is empty."
	 exit 1
 fi
 # Name not a number

if ! [[ "$name" =~ ^[a-zA-Z\s]+$ ]]; then
    echo "The inputed name must contain NO NUMBERS"
    exit 1
fi



#creating the folder 

dir="submission_reminder_$name"
 if [ -d "$dir" ]; then
        echo "The directory has previously been created."
        exit 1
else
        mkdir -p "$dir"
        echo "The Directory '$dir' creation was a success"
        echo "_________________"
      
fi

# Creating  subdirectories

mkdir -p "$dir/app"
mkdir -p "$dir/modules"
mkdir -p "$dir/assets"
mkdir -p "$dir/config"

# Creating the empty files

[ ! -f "$dir/app/reminder.sh" ] && touch "$dir/app/reminder.sh"
[ ! -f "$dir/modules/functions.sh" ] && touch "$dir/modules/functions.sh"
[ ! -f "$dir/assets/submissions.txt" ] && touch "$dir/assets/submissions.txt"
[ ! -f "$dir/config/config.env" ] && touch "$dir/config/config.env"
[ ! -f "$dir/startup.sh" ] && touch "$dir/startup.sh"

# Inserting the necessary data into the blank files

echo '
#!/bin/bash

# Load environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Submissions file path
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignments: $ASSIGNMENT"
echo "Days remaining for submission: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
' >> $dir/app/reminder.sh

echo '
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
' >> $dir/modules/functions.sh

echo '
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
' >> $dir/assets/submissions.txt

echo '
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
' >> $dir/config/config.env

# Adding contents in startup.sh

cat <<EOL >> "$dir/assets/submissions.txt"
Nada, Git, not submitted
Nadal, Shell Navigation, submitted
armand, Git, not submitted
Victor, Shell Basics, not submitted
walid, Shell Navigation, submitted
EOL

# Create startup.sh with logic to run the app

cat << 'EOL' > "$dir/startup.sh"
#!/bin/bash
# Startup script for Submission Reminder App

cd "$(dirname "$0")"
bash ./app/reminder.sh
EOL

# Making them executable
find . -type f -name "*.sh" -exec chmod +x {} \;
echo "Good work"
echo "Open $dir for checking."
