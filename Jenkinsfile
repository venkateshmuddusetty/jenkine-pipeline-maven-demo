properties([pipelineTriggers([githubPush()])])
pipeline {
    agent any
    environment {
        registryUrl = "hidpdeveastusbotacr.azurecr.io"
        
        }
    
    
        stages {
          stage( 'Unit_test') {
                steps {
                 sh 'mvn test'
                }
            }  
            stage( 'Build') {
                steps {
                    script {
                        datas = readYaml (file : "$WORKSPACE/config.yml")
                        echo "build type is: ${datas.Build_type}"
                        
                        
                        if( "${datas.Build_type}" == "maven" )
                        {
                        sh 'mvn clean install -DskipTests=True'
                        }
                        else( "${datas.Build_type}" == "gradle" ) 
                        {    
                        sh 'gradle build'
                        }
                        
                    }
                }
            }
               stage('SonarQube analysis') {
                steps {
                    withSonarQubeEnv('sonarqube-9.0.1') {
                    sh "mvn clean install sonar:sonar"
    }
        }
        } 
       
            stage( 'Build docker image') {
                steps {
                    sh "docker build -t $registryUrl/hello:${BUILD_NUMBER} ."
                    
                }
                
            }
            stage('Upload Image to ACR') {
                steps{
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'docker_pass', usernameVariable: 'docker_user')]) {
                        sh "docker login $registryUrl -u ${docker_user} -p ${docker_pass}"
}
                    
                  //  sh 'docker tag  hello:latest $registryUrl/hello:${BUILD_NUMBER}'
                    sh 'docker push $registryUrl/hello:${BUILD_NUMBER}'
                    
                }
            }
            stage( 'Login to AKS repo') {
                steps {
                        sh 'rm -rf *'
                     withCredentials([usernamePassword(credentialsId: 'test-tken-v', passwordVariable: 'password', usernameVariable: 'username')]) {
                      //git remote set-url origin https://venkateshmuddusetty:${password}@github.com/venkateshmuddusetty/test.git
                         sh '''  
                         git config --global user.name "${username}"
                         git config --global user.email "venkat149dev@gmail.com"
                         git clone https://${password}@github.com/venkateshmuddusetty/test.git
                          '''
                     } 
                }
            }
            
            stage( 'Update to AKS repo') {
                steps {
                    sh '''
                        cd test/
                         git branch
                         rm -rf deployment.yml
                         cp -r /opt/k8s_deploy/deployment.yml ${WORKSPACE}/test/
                         sed -i "s|LATESTVERSION|$registryUrl/hello:${BUILD_NUMBER}|g" ${WORKSPACE}/test/deployment.yml
                         git add deployment.yml
                         git commit -m "Build_number"
                         git push -u origin '''
                    
                }
            } 
        }
}
