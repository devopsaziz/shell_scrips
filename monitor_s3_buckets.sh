#!/bin/bash

# File to store previous bucket list
PREV_FILE="/tmp/s3_buckets_prev.txt"
CURRENT_FILE="/tmp/s3_buckets_current.txt"
EMAIL="azizajfar@gmail.com"

# Get current list of buckets
aws s3 ls | awk '{print $3}' > "$CURRENT_FILE"

# Compare with previous list
if [ -f "$PREV_FILE" ]; then
    NEW_BUCKETS=$(comm -13 <(sort "$PREV_FILE") <(sort "$CURRENT_FILE"))

    if [ ! -z "$NEW_BUCKETS" ]; then
        echo -e "New S3 buckets detected:\n$NEW_BUCKETS" | mail -s "AWS Alert: New S3 Bucket Created" "$EMAIL"
    fi
fi

# Save current list for next run
cp "$CURRENT_FILE" "$PREV_FILE"

