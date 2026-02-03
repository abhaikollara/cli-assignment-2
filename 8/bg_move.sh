#!/bin/bash

# Background File Mover Script
# Moves files to backup/ directory using background processes

# Check if directory argument is provided
if [ $# -ne 1 ]; then
    echo "Error: Please provide a directory path."
    echo "Usage: $0 <directory>"
    exit 1
fi

TARGET_DIR="$1"

# Check if directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# Create backup directory if it doesn't exist
BACKUP_DIR="$TARGET_DIR/backup"
mkdir -p "$BACKUP_DIR"

echo "========================================="
echo "      BACKGROUND FILE MOVE OPERATION    "
echo "========================================="
echo ""
echo "Source Directory: $TARGET_DIR"
echo "Backup Directory: $BACKUP_DIR"
echo "Parent Process PID: $$"
echo ""

# Array to store PIDs
declare -a pids

# Get list of files (not directories)
files=$(find "$TARGET_DIR" -maxdepth 1 -type f)

if [ -z "$files" ]; then
    echo "No files found in '$TARGET_DIR' to move."
    exit 0
fi

echo "Moving files in background:"
echo "-----------------------------------------"

# Move each file in background
for file in $files; do
    filename=$(basename "$file")
    
    # Move file in background
    mv "$file" "$BACKUP_DIR/" &
    pid=$!
    pids+=($pid)
    
    echo "  Moving '$filename' - PID: $pid"
done

echo ""
echo "Waiting for all background processes to complete..."
echo "-----------------------------------------"

# Wait for all background processes
for pid in "${pids[@]}"; do
    wait $pid
    status=$?
    if [ $status -eq 0 ]; then
        echo "  Process $pid completed successfully."
    else
        echo "  Process $pid failed with status $status."
    fi
done

echo ""
echo "========================================="
echo "           OPERATION COMPLETE           "
echo "========================================="
echo "  Total files moved: ${#pids[@]}"
echo "  Files are now in: $BACKUP_DIR"
echo "========================================="
