// Declarative Pipeline
pipeline {
    agent { label 'macos' } 

   // environment {
 //       DEPLOY_USER = 'deploy-user' 
  //  }

environment {
        STAGING_DIR = "/tmp/my-app-staging"
        PROD_DIR = "/tmp/my-app-prod"
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

        // ===== 3. Deploy Stage (Staging) =====
 stage('Deploy in Staging') {
    steps {
        echo "Starting Deploy Stage in Staging"
        // Create jenkins_env.sh file
        script {
            def envVars = [
                "STAGING_DIR=${env.STAGING_DIR}",
                "PROD_DIR=${env.PROD_DIR}"
            ]
            sh "echo '${envVars.join("\\n")}' > jenkins_env.sh"
        }
        // Add execute permission for the deploy script too!
        echo "Setting execute permission for deploy script for Staging..."
        sh 'chmod +x deploy.sh'
        //Source the file
        sh "source jenkins_env.sh"
        //Create the directory
        sh "mkdir -p ${STAGING_DIR}"
        echo "Running deploy script for Staging..."
        // Pass only the environment name
        sh './deploy.sh  Staging'
        sh "cp build/app.txt ${STAGING_DIR}/"
        echo "Deployed artifact to ${STAGING_DIR}"
        // Clean up the jenkins_env.sh file
        sh 'rm -f jenkins_env.sh'
    }
    post {
        success { echo 'Deployment successful in Staging!' }
        failure { echo 'Deployment failed in Staging!' }
    }
}

// End of Deploy Stage to Staging

           // ===== 4. Deploy Stage (Production) =====
        stage('Deploy in Production') {
            // REMOVED the 'when' block - it's not needed here
            steps {
                echo "Starting Deploy Stage in Production"
                 //sh "mkdir -p ${env.PROD_DIR}"
                    script {
            def envVars = [
                "STAGING_DIR=${env.STAGING_DIR}",
                "PROD_DIR=${env.PROD_DIR}"
            ]
                 sh "echo '${envVars.join("\\n")}' > jenkins_env.sh"
                    }
                 // Add execute permission for the deploy script too!
                 echo "Setting execute permission for deploy script for Production..."
                 sh 'chmod +x deploy.sh'
                 echo "Running deploy script for Production..."
                sh './deploy.sh Production ${env.PROD_DIR}' 
                sh "cp build/app.txt ${env.PROD_DIR}/" 
                    echo "Deployed artifact to ${env.PROD_DIR}"
            }
            post {
                success { echo 'Deployment successful in Production!' }
                failure { echo 'Deployment failed in Production!' }
            }
        } // End of Deploy Stage to Production

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

