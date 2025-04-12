#!/bin/bash
echo "Building..."

# Ensure the build directory exists
mkdir -p build 

# Create the app.txt file and put the required string into it
echo "Hello, Jenkins!" > build/app.txt 

# Maybe do other build steps here...
echo "Build finished."

# Exit successfully
exit 0 
