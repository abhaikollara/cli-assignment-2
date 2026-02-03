#!/bin/bash

# Email Cleaner Script
# Processes emails.txt and separates valid/invalid emails

EMAILS_FILE="emails.txt"
VALID_FILE="valid.txt"
INVALID_FILE="invalid.txt"

# Check if emails.txt exists
if [ ! -f "$EMAILS_FILE" ]; then
    echo "Error: File '$EMAILS_FILE' not found."
    exit 1
fi

# Clear output files if they exist
> "$VALID_FILE"
> "$INVALID_FILE"

# Valid email pattern: <letters_and_digits>@<letters>.com
# Pattern breakdown:
# ^[a-zA-Z0-9]+  - starts with one or more letters/digits
# @              - followed by @
# [a-zA-Z]+      - followed by one or more letters
# \.com$         - ends with .com

VALID_PATTERN='^[a-zA-Z0-9]+@[a-zA-Z]+\.com$'

echo "========================================="
echo "         EMAIL CLEANER RESULTS          "
echo "========================================="
echo ""

# Extract valid emails (using grep with extended regex)
grep -E "$VALID_PATTERN" "$EMAILS_FILE" | sort | uniq > "$VALID_FILE"

# Extract invalid emails (invert match)
grep -vE "$VALID_PATTERN" "$EMAILS_FILE" | grep -v '^$' > "$INVALID_FILE"

# Count results
valid_count=$(wc -l < "$VALID_FILE" | tr -d ' ')
invalid_count=$(wc -l < "$INVALID_FILE" | tr -d ' ')

# Display valid emails
echo "VALID EMAILS (saved to $VALID_FILE):"
echo "-----------------------------------------"
if [ "$valid_count" -eq 0 ]; then
    echo "  No valid emails found."
else
    cat "$VALID_FILE" | while read -r email; do
        echo "  $email"
    done
fi
echo ""

# Display invalid emails
echo "INVALID EMAILS (saved to $INVALID_FILE):"
echo "-----------------------------------------"
if [ "$invalid_count" -eq 0 ]; then
    echo "  No invalid emails found."
else
    cat "$INVALID_FILE" | while read -r email; do
        echo "  $email"
    done
fi
echo ""

# Print summary
echo "========================================="
echo "                SUMMARY                  "
echo "========================================="
echo "  Valid emails (unique):   $valid_count"
echo "  Invalid emails:          $invalid_count"
echo "========================================="
echo ""
echo "Files generated:"
echo "  - $VALID_FILE (unique valid emails)"
echo "  - $INVALID_FILE (invalid emails)"
