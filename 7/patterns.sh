#!/bin/bash

# Word Pattern Categorizer Script
# Categorizes words by vowel/consonant patterns

INPUT_FILE="input.txt"
VOWELS_FILE="vowels.txt"
CONSONANTS_FILE="consonants.txt"
MIXED_FILE="mixed.txt"

# Check if input.txt exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

# Clear output files
> "$VOWELS_FILE"
> "$CONSONANTS_FILE"
> "$MIXED_FILE"

echo "========================================="
echo "       WORD PATTERN CATEGORIZATION      "
echo "========================================="
echo ""

# Extract all words and convert to lowercase
words=$(cat "$INPUT_FILE" | tr '[:upper:]' '[:lower:]' | tr -cs '[:alpha:]' '\n' | grep -v '^$' | sort | uniq)

vowel_count=0
consonant_count=0
mixed_count=0

for word in $words; do
    # Check if word contains only vowels
    if echo "$word" | grep -qE '^[aeiou]+$'; then
        echo "$word" >> "$VOWELS_FILE"
        ((vowel_count++))
    # Check if word contains only consonants
    elif echo "$word" | grep -qE '^[bcdfghjklmnpqrstvwxyz]+$'; then
        echo "$word" >> "$CONSONANTS_FILE"
        ((consonant_count++))
    # Check if word starts with consonant and has both vowels and consonants
    elif echo "$word" | grep -qE '^[bcdfghjklmnpqrstvwxyz]'; then
        # Verify it has both vowels and consonants
        has_vowel=$(echo "$word" | grep -c '[aeiou]')
        has_consonant=$(echo "$word" | grep -c '[bcdfghjklmnpqrstvwxyz]')
        if [ "$has_vowel" -gt 0 ] && [ "$has_consonant" -gt 0 ]; then
            echo "$word" >> "$MIXED_FILE"
            ((mixed_count++))
        fi
    fi
done

# Display results
echo "VOWELS ONLY (saved to $VOWELS_FILE):"
echo "-----------------------------------------"
if [ $vowel_count -eq 0 ]; then
    echo "  (none)"
else
    cat "$VOWELS_FILE" | while read -r word; do echo "  $word"; done
fi
echo ""

echo "CONSONANTS ONLY (saved to $CONSONANTS_FILE):"
echo "-----------------------------------------"
if [ $consonant_count -eq 0 ]; then
    echo "  (none)"
else
    cat "$CONSONANTS_FILE" | while read -r word; do echo "  $word"; done
fi
echo ""

echo "MIXED - Starts with consonant (saved to $MIXED_FILE):"
echo "-----------------------------------------"
if [ $mixed_count -eq 0 ]; then
    echo "  (none)"
else
    cat "$MIXED_FILE" | while read -r word; do echo "  $word"; done
fi
echo ""

echo "========================================="
echo "                SUMMARY                  "
echo "========================================="
echo "  Vowels only:     $vowel_count"
echo "  Consonants only: $consonant_count"
echo "  Mixed words:     $mixed_count"
echo "========================================="
