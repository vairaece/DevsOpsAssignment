// Declarative Pipeline
pipeline {
    // Agent directive: Where should the pipeline run?
    // 'any' means Jenkins can use any available agent (master or slave).
    // We can specify labels to target specific slaves.
    agent { label 'macos' } // Run on any agent with the 'macos' label (our slave)

    // Environment variables available to all stages
    environment {
        // Example: Could define paths or credentials here (use Jenkins credentials store for secrets!)
        DEPLOY_USER = 'deploy-user' // Example user
    }

    // Stages: Logical groupings of steps
    stages {
        // ===== 1. Build Stage =====
        stage('Build') {
            steps {
                // Steps are the actual commands/actions
                echo "Starting Build Stage on node: ${env.NODE_NAME}"
                // Get the code from the Git repository
                checkout scm

                // Create necessary directories
                sh 'mkdir -p build' // Ensure build directory exists

                // ***** FIX: Add execute permission *****
                echo "Setting execute permission for build script..."
                sh 'chmod +x build.sh' 

                // Now execute the build script
                echo "Running build script..."
                sh './build.sh'

                // Archive artifacts (files produced by the build)
                // These can be downloaded later or used by downstream jobs/stages
                // Make sure the path is correct based on what build.sh creates
                archiveArtifacts artifacts: 'build/app.txt', fingerprint: true 
            }
            // Post-build actions for this stage
            post {
                success {
                    echo 'Build successful!'
                }
                failure {
                    echo 'Build failed!'
                    // Could add notifications here (email, Slack, etc.)
                }
            }
        } // End of Build Stage

        // ===== 2. Test Stage =====
        stage('Test') {
            // Only run tests if the build was successful
            when {
                expression { success() } // Check if previous stages were successful
            }
            steps {
                echo "Starting Test Stage"
                // Execute the test script
                // Use 'catchError' to handle failures gracefully
                catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                    sh './test.sh'
                }
                // Example: Archive test results (if using a standard format like JUnit)
                // junit 'path/to/test-results.xml'
            }
            post {
                success {
                    echo 'Tests passed!'
                }
                unstable { // If catchError set buildResult to UNSTABLE
                     echo 'Tests passed, but build marked as unstable.'
                }
                failure {
                    echo 'Tests failed!'
                    // Notify developers
                }
            }
        } // End of Test Stage

        // ===== 3. Deploy Stage (Placeholder) =====
        // This stage is often more complex, involving copying files to servers,
        // restarting services, interacting with cloud providers, etc.
        stage('Deploy') {
            // Only deploy if build and test were successful
            when {
                expression { success() }
            }
            steps {
                echo "Starting Deploy Stage"
                // This is where you'd put your actual deployment logic
                // For now, we just run our placeholder script
                sh './deploy.sh PlaceholderEnvironment' // Pass environment name
            }
            post {
                success {
                    echo 'Deployment successful!'
                }
                failure {
                    echo 'Deployment failed!'
                }
            }
        } // End of Deploy Stage

    } // End of stages

    // ===== Post Actions (Run after all stages) =====
    post {
        always {
            echo 'Pipeline finished.'
            // Clean up workspace maybe?
            // cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
            // mail to: 'team@example.com', subject: "SUCCESS: Pipeline ${env.JOB_NAME} [${env.BUILD_NUMBER}]"
        }
        failure {
            echo 'Pipeline failed!'
            // mail to: 'team@example.com', subject: "FAILURE: Pipeline ${env.JOB_NAME} [${env.BUILD_NUMBER}]"
        }
        unstable {
            echo 'Pipeline unstable (e.g., tests failed but were caught).'
        }
        changed {
             echo 'Pipeline status changed from previous run.'
        }
    } // End of post actions

} // End of pipeline
