// Declarative Pipeline
pipeline {
    agent { label 'macos' } 

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
                echo "Setting execute permission for build script..."
                sh 'chmod +x build.sh' 
                echo "Running build script..."
                sh './build.sh'
                // Make sure build.sh actually creates 'build/app.txt'
                // Or adjust the path/filename if needed
                archiveArtifacts artifacts: 'build/app.txt', fingerprint: true 
            }
            post {
                success { echo 'Build successful!' }
                failure { echo 'Build failed!' }
            }
        } // End of Build Stage

        // ===== 2. Test Stage =====
        stage('Test') {
            // REMOVED the 'when' block - it's not needed here
            steps {
                echo "Starting Test Stage"
                // Add execute permission for the test script too!
                echo "Setting execute permission for test script..."
                sh 'chmod +x test.sh' 
                echo "Running test script..."
                // Use 'catchError' to handle failures gracefully
                catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                    sh './test.sh'
                }
                // junit 'path/to/test-results.xml'
            }
            post {
                success { echo 'Tests passed!' }
                unstable { echo 'Tests passed, but build marked as unstable.' }
                failure { echo 'Tests failed!' }
            }
        } // End of Test Stage

        // ===== 3. Deploy Stage (Placeholder) =====
        stage('Deploy') {
            // REMOVED the 'when' block - it's not needed here
            steps {
                echo "Starting Deploy Stage"
                 // Add execute permission for the deploy script too!
                 echo "Setting execute permission for deploy script..."
                 sh 'chmod +x deploy.sh'
                 echo "Running deploy script..."
                sh './deploy.sh PlaceholderEnvironment' 
            }
            post {
                success { echo 'Deployment successful!' }
                failure { echo 'Deployment failed!' }
            }
        } // End of Deploy Stage

    } // End of stages

       // ===== Post Actions (Run after all stages) =====
    post {
        always {
            echo 'Pipeline finished.'
            // Clean up workspace maybe?
            // cleanWs() // Note: cleanWs() might remove logs you want to inspect on failure
        }
        success {
            echo 'Pipeline completed successfully!'
            // mail to: '2023tm93621@wilp.bits-pilani.ac.in', subject: "SUCCESS: Pipeline ${env.JOB_NAME} [${env.BUILD_NUMBER}]"
        }
        failure {
            echo 'Pipeline failed!'
            // mail to: '2023tm93621@wilp.bits-pilani.ac.in', subject: "FAILURE: Pipeline ${env.JOB_NAME} [${env.BUILD_NUMBER}]"
        }
        unstable {
            echo 'Pipeline unstable (e.g., tests failed but were caught).'
        }
        changed {
             echo 'Pipeline status changed from previous run.'
        }
    } // End of post actions

} // End of pipeline

