
#!/bin/bash

# Load environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Submissions file path
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining for submission: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file

