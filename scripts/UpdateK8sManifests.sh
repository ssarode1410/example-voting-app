#!/bin/bash
set -e # This forces the script to exit immediately if any command fails

# Assign arguments to variables
GIT_REPO_URL=$1
NEW_IMAGE_URI=$2

# Create a temporary directory and clone the Git repo
git clone "$GIT_REPO_URL" /tmp/temp_repo
cd /tmp/temp_repo

# Update the deployment file (update the path to match your actual repo structure)
# This replaces the old image URI with the new one
sed -i "s|image:.*|image: $NEW_IMAGE_URI|g" k8s-specifications/vote-deployment.yaml

# Commit and push the changes back to Git
git config user.name "Shantanu Sarode"
git config user.email "sarode437@gmail.com"
git add .
git commit -m "Update Kubernetes manifest to image $NEW_IMAGE_URI"
git push origin main

# Cleanup
rm -rf /tmp/temp_repo