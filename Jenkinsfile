def DOCKER_REGISTRY="192.168.56.12/k8s-ops"
def DOCKER_REGISTRY_AUTH = "ac37798b-9380-4ee9-8fb8-04a6a4d8413b"
def PRO_NAME = "nginx_pro"
def K8S_NAMESPACE = "kube-ops"
def DEP_NAME = "nginx-pro"
def CONTAINER_NAME = "nginx"

node('ops-jnlp'){
  stage('Clone') {
    echo "1.Clone from https://github.com/kin08200/k8sops.git"
    git url: "https://github.com/kin08200/k8sops.git"
      script {
        build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
    }
  }
  stage('Build') {
    echo "2.Build Docker Image "
    sh "docker build -t ${DOCKER_REGISTRY}/${PRO_NAME}:${build_tag} ."
  }
  stage('Push'){
    echo "3.Push Docker Image To The Registry"
    withCredentials([usernamePassword(credentialsId: "${DOCKER_REGISTRY_AUTH}", passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
        sh "docker login -u $USERNAME -p $PASSWORD  ${DOCKER_REGISTRY}"
        sh "docker push ${DOCKER_REGISTRY}/${PRO_NAME}:${build_tag}"
    }
  }
    stage('Check'){
    def userInput = input(
        id: 'userInput',
        message: 'Choose a deploy environment',
        parameters: [
            [
                $class: 'ChoiceParameterDefinition',
                choices: "Dev\nQA\nProd",
                name: 'Env'
            ]
        ]
    )
    echo "This is a deploy step to ${userInput}"
    if (userInput == "Dev") {
            // deploy dev stuff
        } else if (userInput == "QA"){
            // deploy qa stuff
        } else {
            // deploy prod stuff
        }
    echo "4. Check deployment status on k8s"
    def is_deployed = sh (script: "kubectl get deployment  -n ${K8S_NAMESPACE} | grep -w ${DEP_NAME} |awk {'print \$(1)'}" , returnStdout: true).trim()
        if ( is_deployed ){
            stage('rolling update APP to k8s') {
                sh ("kubectl set image deployment/${DEP_NAME} ${CONTAINER_NAME}=${DOCKER_REGISTRY}/${PRO_NAME}:${build_tag} -n ${K8S_NAMESPACE}")
            }
        }
        else {
            stage('deploy APP to k8s') {
               sh "sed -i 's/<BUILD_TAG>/${build_tag}/' nginx.yaml"
               sh "kubectl apply -f nginx.yaml"
               sh "kubectl apply -f nginx-svc.yaml" 
            }
        }
    }
}
