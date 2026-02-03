#!/bin/bash

# Log File Analyzer Script
# Analyzes log files and generates a summary report

# Check if a log file argument is provided
if [ $# -ne 1 ]; then
    echo "Error: Please provide a log file as an argument."
    echo "Usage: $0 <logfile>"
    exit 1
fi

LOG_FILE="$1"

# Validate that the file exists and is readable
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' does not exist."
    exit 1
fi

if [ ! -r "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' is not readable."
    exit 1
fi

# Count total number of log entries
TOTAL_ENTRIES=$(wc -l < "$LOG_FILE" | tr -d ' ')

# Count INFO, WARNING, and ERROR messages
INFO_COUNT=$(grep -c " INFO " "$LOG_FILE" 2>/dev/null || echo 0)
WARNING_COUNT=$(grep -c " WARNING " "$LOG_FILE" 2>/dev/null || echo 0)
ERROR_COUNT=$(grep -c " ERROR " "$LOG_FILE" 2>/dev/null || echo 0)

# Get the most recent ERROR message
RECENT_ERROR=$(grep " ERROR " "$LOG_FILE" | tail -1)

# Generate report file name with current date
REPORT_DATE=$(date +%Y-%m-%d)
REPORT_FILE="logsummary_${REPORT_DATE}.txt"

# Display the summary
echo "========================================="
echo "         LOG FILE ANALYSIS SUMMARY       "
echo "========================================="
echo ""
echo "Log File: $LOG_FILE"
echo ""
echo "Total Log Entries: $TOTAL_ENTRIES"
echo ""
echo "Message Counts by Level:"
echo "  - INFO:    $INFO_COUNT"
echo "  - WARNING: $WARNING_COUNT"
echo "  - ERROR:   $ERROR_COUNT"
echo ""
echo "Most Recent ERROR Message:"
if [ -n "$RECENT_ERROR" ]; then
    echo "  $RECENT_ERROR"
else
    echo "  No ERROR messages found."
fi
echo ""
echo "========================================="

# Generate the report file
{
    echo "Log Summary Report"
    echo "Generated: $(date)"
    echo "========================================="
    echo ""
    echo "Log File: $LOG_FILE"
    echo ""
    echo "Total Log Entries: $TOTAL_ENTRIES"
    echo ""
    echo "Message Counts by Level:"
    echo "  - INFO:    $INFO_COUNT"
    echo "  - WARNING: $WARNING_COUNT"
    echo "  - ERROR:   $ERROR_COUNT"
    echo ""
    echo "Most Recent ERROR Message:"
    if [ -n "$RECENT_ERROR" ]; then
        echo "  $RECENT_ERROR"
    else
        echo "  No ERROR messages found."
    fi
    echo ""
    echo "========================================="
} > "$REPORT_FILE"

echo "Report generated: $REPORT_FILE"
