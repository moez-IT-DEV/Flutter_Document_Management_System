pipeline {
    agent {
        docker {
            image 'ghcr.io/cirruslabs/flutter:3.29.0'
            args '--privileged --network=host -u 0 -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    options {
        disableConcurrentBuilds()
        timeout(time: 40, unit: 'MINUTES')
        timestamps()
    }

    environment {
        HOME = '/root'
        PUB_CACHE = '/root/.pub-cache'
        DOCKER_IMAGE_GHCR = "ghcr.io/moez-it-dev/flutter_document_management_system"
        DOCKER_IMAGE_HUB  = "moezdocker/flutter-dms"
        IMAGE_VERSION     = "${BUILD_NUMBER}"
        KUBECTL_VERSION   = "v1.29.0"
    }

    stages {

        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Install Docker CLI') {
            steps {
                sh '''
                    if ! command -v docker &> /dev/null; then
                        apt-get update -qq
                        apt-get install -y -qq docker.io
                    fi
                    docker --version
                '''
            }
        }

        stage('Install kubectl') {
            steps {
                sh '''
                    if ! command -v kubectl &> /dev/null; then
                        echo "📦 Installing kubectl..."
                        curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
                        chmod +x kubectl
                        mv kubectl /usr/local/bin/kubectl
                    fi
                    kubectl version --client
                '''
            }
        }

        stage('Install Dependencies') {
            steps { sh 'flutter pub get' }
        }

        stage('Quality Checks') {
            parallel {
                stage('Format')  { steps { sh 'dart format --set-exit-if-changed lib test || true' } }
                stage('Analyze') { steps { sh 'flutter analyze --no-pub || true' } }
                stage('Test')    { steps { sh 'flutter test || true' } }
            }
        }

        stage('Build Web') {
            steps {
                sh 'flutter build web --release'
                stash includes: 'build/web/**', name: 'web-build'
            }
        }

        stage('Build & Push Docker Images') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                }
            }
            steps {
                script {
                    def imageFull = "${DOCKER_IMAGE_GHCR}:${IMAGE_VERSION}"
                    def imageSha  = "${DOCKER_IMAGE_GHCR}:${IMAGE_VERSION}-${env.GIT_COMMIT?.take(7)}"
                    def imageHub  = "${DOCKER_IMAGE_HUB}:${IMAGE_VERSION}"

                    withEnv([
                        "IMAGE_FULL=${imageFull}",
                        "IMAGE_SHA=${imageSha}",
                        "IMAGE_HUB=${imageHub}"
                    ]) {
                        echo "🐳 Building Docker image: ${imageFull}"
                        sh 'docker build -t ${IMAGE_FULL} -f Dockerfile .'

                        docker.withRegistry('https://ghcr.io', '565422e5-4781-42fa-acab-960f06ddba7a') {
                            sh 'docker tag ${IMAGE_FULL} ${IMAGE_SHA}'
                            sh 'docker push ${IMAGE_FULL}'
                            sh 'docker push ${IMAGE_SHA}'
                        }

                        docker.withRegistry('https://index.docker.io/v1/', '5f97b244-cc7f-4763-ab96-59de395b4623') {
                            sh 'docker tag ${IMAGE_FULL} ${IMAGE_HUB}'
                            sh 'docker push ${IMAGE_HUB}'
                        }
                    }
                    
                    echo "✅ Docker images pushed successfully"
                }
            }
        }

        stage('Preload Image to Minikube') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                }
            }
            steps {
                script {
                    def imageFull = "${DOCKER_IMAGE_GHCR}:${IMAGE_VERSION}"
                    withEnv(["IMAGE_FULL=${imageFull}"]) {
                        sh '''
                            set -e
                            
                            echo "📥 Saving image: ${IMAGE_FULL}"
                            docker save "${IMAGE_FULL}" -o /tmp/flutter-dms-image.tar
                            
                            echo "🔍 Finding Minikube container..."
                            MINIKUBE_CTR=$(docker ps --format '{{.Names}}' | grep -E '^minikube$' | head -1)
                            
                            if [ -z "${MINIKUBE_CTR}" ]; then
                                echo "⚠️  Minikube container not found - skipping preload"
                                rm -f /tmp/flutter-dms-image.tar
                                exit 0
                            fi
                            
                            echo "📦 Copying image to Minikube container: ${MINIKUBE_CTR}"
                            docker cp /tmp/flutter-dms-image.tar "${MINIKUBE_CTR}:/tmp/image.tar"
                            
                            echo "🔄 Loading image into Minikube..."
                            if docker exec "${MINIKUBE_CTR}" sh -c 'command -v ctr' > /dev/null 2>&1; then
                                docker exec "${MINIKUBE_CTR}" ctr -n k8s.io images import /tmp/image.tar
                                echo "✅ Image loaded via containerd"
                            elif docker exec "${MINIKUBE_CTR}" sh -c 'command -v docker' > /dev/null 2>&1; then
                                docker exec "${MINIKUBE_CTR}" docker load -i /tmp/image.tar
                                echo "✅ Image loaded via docker"
                            else
                                echo "❌ No container runtime found in Minikube"
                                exit 1
                            fi
                            
                            echo "🧹 Cleanup..."
                            docker exec "${MINIKUBE_CTR}" rm -f /tmp/image.tar || true
                            rm -f /tmp/flutter-dms-image.tar
                            
                            echo "✅ Image preloaded successfully to Minikube"
                        '''
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                }
            }
            steps {
                script {
                    def namespace = (env.BRANCH_NAME == 'main') ? 'prod' : 'dev'
                    def kubeCred  = (env.BRANCH_NAME == 'main') ? 'kubeconfig-prod' : 'kubeconfig-dev'
                    def imageFull = "${DOCKER_IMAGE_GHCR}:${IMAGE_VERSION}"
                    
                    echo "🚀 Deploying to ${namespace} from branch ${env.BRANCH_NAME}"
                    echo "🔑 Using credential: ${kubeCred}"
                    
                    withEnv([
                        "NS=${namespace}",
                        "IMAGE_FULL=${imageFull}"
                    ]) {
                        withKubeConfig([credentialsId: kubeCred]) {
                            sh '''
                                echo "📋 Verifying kubectl connectivity..."
                                kubectl version --client
                                kubectl cluster-info
                                
                                echo "🎯 Updating deployment image..."
                                kubectl set image deployment/flutter-dms-web \
                                    web="${IMAGE_FULL}" \
                                    -n "${NS}"
                                
                                echo "⏳ Waiting for rollout (max 15 minutes)..."
                                kubectl rollout status deployment/flutter-dms-web -n "${NS}" --timeout=15m
                                
                                echo "📦 Current Pods:"
                                kubectl get pods -n "${NS}"
                                
                                echo "✅ Deployment complete!"
                            '''
                        }
                    }
                }
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'build/web/**', fingerprint: true
            }
        }
    }

    post {
        success { echo "🚀 Pipeline succeeded! Version: ${IMAGE_VERSION}" }
        failure { echo "❌ Pipeline failed. Check logs." }
        always {
            script {
                try { cleanWs() } catch (Exception e) { 
                    echo "Workspace cleanup skipped: ${e.message}" 
                }
            }
        }
    }
}
