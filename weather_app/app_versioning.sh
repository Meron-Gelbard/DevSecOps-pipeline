#!/bin/bash

# Script for incrementing the version of the Web App.
VERSION_FILE="$1"

current_version=$(awk '{print $0}' "$VERSION_FILE")

# Split current version into an array
IFS='.' read -ra current_version_array <<< "$current_version"

# Increment the right version index:
if [ "$2" == "patch" ];
then
    current_version_array[2]=$((current_version_array[2] + 1))
elif [ "$2" == "minor" ];
then
    current_version_array[1]=$((current_version_array[1] + 1))
    current_version_array[2]=0
fi


# Join the array elements to get the new version
new_version=$(IFS='.'; echo "${current_version_array[*]}")

# Write the new version to the file
echo "$new_version" > "$VERSION_FILE"

# Output new version for use in pipeline
echo "$new_version"