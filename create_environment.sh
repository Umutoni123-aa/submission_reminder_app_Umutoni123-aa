#!/bin/bash
 #ask the user to enter the name 
 echo "The directory has to have a name"
 read -p "Please, Enter your directory name: " name

 if [ -z "$name" ]; then
	 echo "Please enter your name."
	 echo "The input is empty."
	 exit 1
 fi 
 #creating the folder 
 dir="submission_reminder_$name"
 mkdir -p "$dir"
