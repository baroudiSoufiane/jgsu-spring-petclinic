def dockerImage

pipeline {
    //agent {label 'agent-docker'}
    agent any
    parameters {
		string(name: 'GIT_BRANCH', defaultValue: 'main')
	}
	environment {
		GIT_URL = 'http://gitlab.apps.web.bpifrance.fr/DPSM/FRS/CET/ctc.git'
	}
    stages {
    	stage('CSM & Verify') {
            steps {
            	git branch : ${GIT_BRANCH}, url : ${GIT_URL}
            	echo "Build Started - ${env.JOB_NAME} ${env.BUILD_NUMBER} (${env.BUILD_URL})"
                echo "Workspace : $WORKSPACE"
                sh 'ls -l "$WORKSPACE"'
            }
        }
        stage('Build & Test') {
            steps {
                // Run Maven on a Unix agent.
                sh "./mvnw clean build"
            }
            post {
            	// If Maven was able to run the tests, even if some of the test failed, record the test results and archive the jar file.
            	always {
		            junit 'target/surefire-reports/*.xml'
		        }
		        success {
		            archiveArtifacts 'target/*.jar'
		        }
            }
        }
        stage('Quality') {
            steps {
                echo 'Error- SonarCube have not been configured yet'
            }
        }
        /**
        stage('Push') {
        	steps {
        		script {
        			dockerImage = docker.build('sobaroud/petclinic:v$BUILD_NUMBER','./');
        			docker.withRegistry('','dockerHub'){
	        			dockerImage.push();
	        		}
        		}
        	}
        }
        */
    }
    post {
	    always {
	    	emailext attachLog: true, compressLog: true, to: 'test@test', recipientProviders: [buildUser(), upstreamDevelopers()], 
	    		subject: "Job \'${JOB_NAME}\' (${BUILD_NUMBER}) is ${currentBuild.result}", body: "Please go to ${BUILD_URL} and verify the build"
    		echo "Build Completed - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}>)"
	    }
    }
}