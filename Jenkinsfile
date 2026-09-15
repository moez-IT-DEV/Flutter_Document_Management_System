pipeline {
    agent {
        docker {
            image 'ghcr.io/cirruslabs/flutter:3.29.0'
            args '--privileged -u 0 -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    options {
        disableConcurrentBuilds()
        timeout(time: 60, unit: 'MINUTES')
        timestamps()
    }

    environment {
        HOME = '/root'
        PUB_CACHE pipeline {
    agent {
        docker {
            image 'ghcr.io/cirruslabs/flutter:3.29.0'
            args '--privileged -u 0 -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    options {
        disableConcurrentBuilds()
        timeout(time: 60, unit: 'MINUTES')
        timestamps()
    }

    environment {
        HOME = '/root'
        PUB_CACHE = '/root/.pub-cache'
        DOCKER_IMAGE_GHCR = "ghcr.io/moez-it-dev/flutter_document_management_system"
        DOCKER_IMAGE_HUB  = "moezdocker/flutter-dms"
        IMAGE_VERSION     = "${BUILD_NUMBER}"
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

        stage('Build APK') {
            when { branch 'main' }
            steps {
                sh 'flutter build apk --release --split-per-abi'
                stash includes: 'build/app/outputs/flutter-apk/*.apk', name: 'apk-build'
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
                    def dockerImageGHCR = "${DOCKER_IMAGE_GHCR}:${IMAGE_VERSION}"
                    def dockerImageGHCRSha = "${DOCKER_IMAGE_GHCR}:${IMAGE_VERSION}-${env.GIT_COMMIT?.take(7)}"
                    def dockerImageHub = "${DOCKER_IMAGE_HUB}:${IMAGE_VERSION}"

                    sh "docker build -t ${dockerImageGHCR} -f Dockerfile ."

                    docker.withRegistry('https://ghcr.io', '565422e5-4781-42fa-acab-960f06ddba7a') {
                        sh "docker tag ${dockerImageGHCR} ${dockerImageGHCRSha}"
                        sh "docker push ${dockerImageGHCR}"
                        sh "docker push ${dockerImageGHCRSha}"
                    }

                    docker.withRegistry('https://index.docker.io/v1/', '5f97b244-cc7f-4763-ab96-59de395b4623') {
                        sh "docker tag ${dockerImageGHCR} ${dockerImageHub}"
                        sh "docker push ${dockerImageHub}"
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
                    
                    echo "🚀 Deploying to ${namespace} from branch ${env.BRANCH_NAME}"
                    
                    withKubeConfig([credentialsId: kubeCred]) {
                        sh """
                            kubectl set image deployment/flutter-dms-web \
                                web=${DOCKER_IMAGE_GHCR}:${IMAGE_VERSION} \
                                -n ${namespace}
                            
                            kubectl rollout status deployment/flutter-dms-web -n ${namespace} --timeout=5m
                            
                            kubectl get pods -n ${namespace}
                        """
                    }
                }
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/*.apk, build/web/**', fingerprint: true
            }
        }
    }

    post {
        success { echo "🚀 Pipeline succeeded! Version: ${IMAGE_VERSION}" }
        failure { echo "❌ Pipeline failed. Check logs." }
        always {
            script {
                try { cleanWs() } catch (Exception e) { echo "Workspace cleanup skipped: ${e.message}" }
            }
        }
    }
}
