#!/bin/bash
source jenkins_env.sh  # Source the Jenkins environment
echo "Deploying artifact build/app.txt to $1 environment..."
if [ -n "$2" ]; then
  echo "Target directory: $2"
  # Add actual deployment commands here, e.g., rsync, scp, kubectl apply, etc.
  # Example: cp build/app.txt "$2/"
else
  echo "No target directory specified."
fi
echo "Deployment script finished for $1."
exit 0 # Indicate success
