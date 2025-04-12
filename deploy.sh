#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# Source the Jenkins environment
if [ -f jenkins_env.sh ]; then
  source jenkins_env.sh
else
  echo "Error: jenkins_env.sh not found!"
  exit 1
fi

echo "Deploying artifact build/app.txt to $1 environment..."

if [ -n "$STAGING_DIR" ]; then
  echo "Target directory: $STAGING_DIR"
  # Add actual deployment commands here, e.g., rsync, scp, kubectl apply, etc.
  cp build/app.txt "$STAGING_DIR/" # Example deployment command
else
  echo "Error: STAGING_DIR not set!"
  exit 1
fi

echo "Deployment script finished for $1."
exit 0 # Indicate success
