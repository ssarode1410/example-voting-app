#!/bin/bash
set -x
set -e # This ensures the script stops immediately if any command fails

# 1. Capture the full ECR Image URI passed from the Jenkins pipeline
# Example input: 162876227471.dkr.ecr.us-east-1.amazonaws.com/argocd/evoting-app:7
NEW_IMAGE_URI=$1

# 2. Extract the application name to target the correct YAML file
APP_NAME=$(basename "$NEW_IMAGE_URI" | cut -d':' -f1)

# 3. Your Authenticated GitHub Repository URL
# Jenkins injects GIT_USERNAME and GIT_PASSWORD securely at runtime via withCredentials
REPO_URL="https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/ssarode1410/example-voting-app.git"

# 4. Clone the repository to a temporary workspace
git clone "$REPO_URL" /tmp/temp_repo
cd /tmp/temp_repo

# 5. Update the Kubernetes manifest file dynamically
sed -i "s|image:.*|image: $NEW_IMAGE_URI|g" "k8s-specifications/${APP_NAME}-deployment.yaml"

# 6. Stage, commit, and push the updated manifest back to GitHub
git add .
git config user.name "Jenkins Pipeline"
git config user.email "jenkins@shantanu.localdomain"
git commit -m "Update Kubernetes manifest to new ECR image: $NEW_IMAGE_URI"
git push

# 7. Cleanup the temporary workspace
rm -rf /tmp/temp_repo