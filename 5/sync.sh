#!/bin/bash

# Directory Sync Comparison Script
# Compares two directories and lists differences

DIRA="dirA"
DIRB="dirB"

# Check if both directories exist
if [ ! -d "$DIRA" ]; then
    echo "Error: Directory '$DIRA' not found."
    exit 1
fi

if [ ! -d "$DIRB" ]; then
    echo "Error: Directory '$DIRB' not found."
    exit 1
fi

echo "========================================="
echo "     DIRECTORY COMPARISON RESULTS       "
echo "========================================="
echo ""

# Get list of files in each directory
files_a=$(ls -1 "$DIRA" 2>/dev/null)
files_b=$(ls -1 "$DIRB" 2>/dev/null)

# Files only in dirA
echo "FILES ONLY IN $DIRA:"
echo "-----------------------------------------"
only_in_a=0
for file in $files_a; do
    if [ ! -e "$DIRB/$file" ]; then
        echo "  $file"
        ((only_in_a++))
    fi
done
if [ $only_in_a -eq 0 ]; then
    echo "  (none)"
fi
echo ""

# Files only in dirB
echo "FILES ONLY IN $DIRB:"
echo "-----------------------------------------"
only_in_b=0
for file in $files_b; do
    if [ ! -e "$DIRA/$file" ]; then
        echo "  $file"
        ((only_in_b++))
    fi
done
if [ $only_in_b -eq 0 ]; then
    echo "  (none)"
fi
echo ""

# Files in both directories - compare contents
echo "FILES IN BOTH DIRECTORIES:"
echo "-----------------------------------------"
matching=0
different=0
for file in $files_a; do
    if [ -e "$DIRB/$file" ]; then
        # Use cmp to compare file contents
        if cmp -s "$DIRA/$file" "$DIRB/$file"; then
            echo "  $file - IDENTICAL"
            ((matching++))
        else
            echo "  $file - DIFFERENT"
            ((different++))
        fi
    fi
done
if [ $matching -eq 0 ] && [ $different -eq 0 ]; then
    echo "  (no common files)"
fi
echo ""

# Summary
echo "========================================="
echo "                SUMMARY                  "
echo "========================================="
echo "  Files only in $DIRA:     $only_in_a"
echo "  Files only in $DIRB:     $only_in_b"
echo "  Common files (identical): $matching"
echo "  Common files (different): $different"
echo "========================================="
