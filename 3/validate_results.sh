#!/bin/bash

# Student Results Validator Script
# Reads student data from marks.txt and validates pass/fail status

MARKS_FILE="marks.txt"
PASSING_MARKS=33

# Check if marks.txt exists
if [ ! -f "$MARKS_FILE" ]; then
    echo "Error: File '$MARKS_FILE' not found."
    exit 1
fi

# Initialize counters
failed_one_count=0
passed_all_count=0

# Arrays to store student names
declare -a failed_one_students
declare -a passed_all_students

echo "========================================="
echo "      STUDENT RESULTS VALIDATION        "
echo "========================================="
echo ""

# Read the file line by line
while IFS=',' read -r rollno name marks1 marks2 marks3 || [ -n "$rollno" ]; do
    # Skip empty lines
    [ -z "$rollno" ] && continue
    
    # Trim whitespace from fields
    rollno=$(echo "$rollno" | xargs)
    name=$(echo "$name" | xargs)
    marks1=$(echo "$marks1" | xargs)
    marks2=$(echo "$marks2" | xargs)
    marks3=$(echo "$marks3" | xargs)
    
    # Count failed subjects
    failed_subjects=0
    
    if [ "$marks1" -lt "$PASSING_MARKS" ]; then
        ((failed_subjects++))
    fi
    
    if [ "$marks2" -lt "$PASSING_MARKS" ]; then
        ((failed_subjects++))
    fi
    
    if [ "$marks3" -lt "$PASSING_MARKS" ]; then
        ((failed_subjects++))
    fi
    
    # Categorize students
    if [ "$failed_subjects" -eq 0 ]; then
        passed_all_students+=("$rollno - $name (Marks: $marks1, $marks2, $marks3)")
        ((passed_all_count++))
    elif [ "$failed_subjects" -eq 1 ]; then
        failed_one_students+=("$rollno - $name (Marks: $marks1, $marks2, $marks3)")
        ((failed_one_count++))
    fi
    
done < "$MARKS_FILE"

# Print students who passed in ALL subjects
echo "STUDENTS WHO PASSED ALL SUBJECTS:"
echo "-----------------------------------------"
if [ ${#passed_all_students[@]} -eq 0 ]; then
    echo "  No students passed all subjects."
else
    for student in "${passed_all_students[@]}"; do
        echo "  $student"
    done
fi
echo ""

# Print students who failed in exactly ONE subject
echo "STUDENTS WHO FAILED IN EXACTLY ONE SUBJECT:"
echo "-----------------------------------------"
if [ ${#failed_one_students[@]} -eq 0 ]; then
    echo "  No students failed in exactly one subject."
else
    for student in "${failed_one_students[@]}"; do
        echo "  $student"
    done
fi
echo ""

# Print summary counts
echo "========================================="
echo "                SUMMARY                  "
echo "========================================="
echo "  Students passed all subjects:     $passed_all_count"
echo "  Students failed in one subject:   $failed_one_count"
echo "========================================="
