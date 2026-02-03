#!/bin/bash

# Text Metrics Analyzer Script
# Analyzes input.txt for word statistics

INPUT_FILE="input.txt"

# Check if input.txt exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

echo "========================================="
echo "        TEXT METRICS ANALYSIS           "
echo "========================================="
echo ""

# Extract all words (convert to lowercase, remove punctuation, one word per line)
words=$(cat "$INPUT_FILE" | tr '[:upper:]' '[:lower:]' | tr -cs '[:alpha:]' '\n' | grep -v '^$')

# Get unique words
unique_words=$(echo "$words" | sort | uniq)
unique_count=$(echo "$unique_words" | wc -l | tr -d ' ')

# Find longest word
longest=""
for word in $unique_words; do
    if [ ${#word} -gt ${#longest} ]; then
        longest="$word"
    fi
done

# Find shortest word
shortest=""
for word in $unique_words; do
    if [ -z "$shortest" ] || [ ${#word} -lt ${#shortest} ]; then
        shortest="$word"
    fi
done

# Calculate average word length
total_length=0
word_count=0
for word in $words; do
    total_length=$((total_length + ${#word}))
    ((word_count++))
done

if [ $word_count -gt 0 ]; then
    average=$(echo "scale=2; $total_length / $word_count" | bc)
else
    average=0
fi

# Display results
echo "ANALYSIS RESULTS:"
echo "-----------------------------------------"
echo "  Longest word:          $longest (${#longest} characters)"
echo "  Shortest word:         $shortest (${#shortest} characters)"
echo "  Average word length:   $average characters"
echo "  Total unique words:    $unique_count"
echo ""
echo "========================================="
