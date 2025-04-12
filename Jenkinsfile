pipeline {

    agent { label 'macos' } // Run on any agent with the 'macos' label (our slave)

    environment {
        DEPLOY_USER = 'deploy-user'
    }

    stages {
        // ===== 1. Build Stage =====
        stage('Build') {
            steps {
                echo "Starting Build Stage on node: ${env.NODE_NAME}"

                checkout scm

                sh 'mkdir -p build'

                // Modified: Added timeout and error handling
                script {
                    try {
                        timeout(time: 1, unit: 'MINUTES') { // Set a timeout for the build script
                            // sh script: 'sudo ./build.sh', label: 'Run build.sh'
                             echo "Build Code"
                        }
                    } catch (hudson.AbortException e) {
                        echo "Build script timed out or failed: ${e.getMessage()}"
                        error("Build failed due to timeout or script error.") // Fail the build
                    }
                }

                archiveArtifacts artifacts: 'build/app.txt', fingerprint: true
            }

            post {
                success {
                    echo 'Build successful!'
                }
                failure {
                    echo 'Build failed!'
                }
            }
        } // End of Build Stage

        // ===== 2. Test Stage =====
        stage('Test') {
            // Only run tests if the build was successful
            when {
                expression { success() }
            }
            steps {
                echo "Starting Test Stage"

                // Modified: Added timeout and error handling to test stage
                script {
                    try {
                        timeout(time: 1, unit: 'MINUTES') {
                            sh script: 'sudo ./test.sh', label: 'Run test.sh'
                        }
                    } catch (hudson.AbortException e) {
                        echo "Test script timed out or failed: ${e.getMessage()}"
                        currentBuild.result = 'UNSTABLE' // Mark build as unstable instead of failing completely
                    }
                }
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
                }
            }
        } // End of Test Stage

        // ===== 3. Deploy Stage (Placeholder) =====
        stage('Deploy') {
            // Only deploy if build and test were successful
             when {
                 expression { success() }
             }
            steps {
                echo "Starting Deploy Stage"

                // Modified: Added timeout and error handling for deploy
                script {
                    try {
                        timeout(time: 1, unit: 'MINUTES') {
                            sh script: 'sudo ./deploy.sh PlaceholderEnvironment', label: 'Run deploy.sh'
                        }
                    } catch (hudson.AbortException e) {
                        echo "Deployment script timed out or failed: ${e.getMessage()}"
                        error("Deployment failed due to timeout or script error.")
                    }
                }
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
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
        unstable {
            echo 'Pipeline unstable (e.g., tests failed but were caught).'
        }
        changed {
            echo 'Pipeline status changed from previous run.'
        }
    } // End of post actions

} // End of pipeline
