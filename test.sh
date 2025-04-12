#!/bin/bash
echo "Testing..."
grep "Hello, Jenkins!" build/app.txt
if [ $? -eq 0 ]; then echo "Test Passed!"; exit 0; else echo "Test Failed!"; exit 1; fi
