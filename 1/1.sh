#!/bin/bash

# Check if exactly one argument is provided
if [ $# -ne 1 ]; then
    echo "Error: Invalid argument count. Please provide exactly one argument."
    echo "Usage: $0 <file_or_directory_path>"
    exit 1
fi

path="$1"

# Check if the path exists
if [ ! -e "$path" ]; then
    echo "Error: Path '$path' does not exist."
    exit 1
fi

# Check if the argument is a file
if [ -f "$path" ]; then
    echo "Analyzing file: $path"
    echo "----------------------------"
    
    # Get line, word, and character count using wc
    lines=$(wc -l < "$path")
    words=$(wc -w < "$path")
    chars=$(wc -c < "$path")
    
    echo "Number of lines: $lines"
    echo "Number of words: $words"
    echo "Number of characters: $chars"

# Check if the argument is a directory
elif [ -d "$path" ]; then
    echo "Analyzing directory: $path"
    echo "----------------------------"
    
    # Count total number of files (not directories)
    total_files=$(find "$path" -maxdepth 1 -type f | wc -l)
    
    # Count number of .txt files
    txt_files=$(find "$path" -maxdepth 1 -type f -name "*.txt" | wc -l)
    
    echo "Total number of files: $total_files"
    echo "Number of .txt files: $txt_files"

else
    echo "Error: '$path' is neither a regular file nor a directory."
    exit 1
fi

exit 0
