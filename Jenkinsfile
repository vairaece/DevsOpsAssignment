
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

             
                sh 'sudo ./build.sh'

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
                
                catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                    sh 'sudo ./test.sh'
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
           // when {
           //     expression { success() }
        //    }
            steps {
                echo "Starting Deploy Stage"
             
                sh 'sudo  ./deploy.sh PlaceholderEnvironment' 
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
