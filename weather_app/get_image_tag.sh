#!/bin/bash

# # Install jq if not installed based on OS:
# if ! command -v jq &> /dev/null; then
#     sudo apt-get install -y jq
# fi

# Docker Hub repository name parameter
REPOSITORY=$1
VERSION_FILE=$2

# Get the tags from the Docker Hub API
tags=$(curl -s "https://hub.docker.com/v2/repositories/$REPOSITORY/tags/" | jq -r '.results[].name' | grep -v 'latest' | sort -V)

# Get the last tag that is not "latest"
last_non_latest_tag=$(echo "$tags" | tail -n 1)

if [ -z "$last_non_latest_tag" ]; then
    echo "No tags found or only tag is 'latest'. Setting version to 1.0.0."
    last_non_latest_tag="1.0.0"
else
    echo "Last tested version tag: $last_non_latest_tag"
fi
echo "$last_non_latest_tag" > "$VERSION_FILE"