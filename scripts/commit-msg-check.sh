#!/bin/bash
# Hook to check the format of the commit message
commit_message=$(cat "$1")

# Check if the commit message matches the format 'DJ-<number>' (e.g., DJ-1, DJ-100)
if [[ ! $commit_message =~ ^DJ-[0-9]+$ ]]; then
    echo "❌ Error: Commit message must be in the format 'DJ-<number>' (e.g., DJ-1, DJ-100)."
    exit 1
fi

echo "✅ Commit message format is correct"
exit 0
