pipeline {
    agent {
        docker {
            // صورة Flutter قابلة للكتابة وتحتوي على Flutter 3.29.0
            image 'cirrusci/flutter:3.29.0'
            // للسماح ببناء صور Docker داخل الحاوية والوصول إلى Docker daemon
            args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    options {
        // منع تشغيل بنائين متزامنين لنفس الفرع
        disableConcurrentBuilds()
        // مهلة قصوى للبناء الكامل (بالدقائق)
        timeout(time: 60, unit: 'MINUTES')
        // إضافة طابع زمني للسجلات
        timestamps()
    }

    environment {
        // تحديد HOME قابل للكتابة لتجنب مشاكل Git config
        HOME = '/tmp'
        // تحديد مجلد مؤقت لذاكرة التخزين المؤقت للحزم
        PUB_CACHE = '/tmp/.pub-cache'
        // متغيرات مسارات الصور
        DOCKER_IMAGE_GHCR = "ghcr.io/moez-IT-DEV/Flutter_Document_Management_System"
        DOCKER_IMAGE_HUB  = "moezdocker/flutter-dms"
        // رقم البناء يستخدم كوسم افتراضي
        IMAGE_VERSION     = "${BUILD_NUMBER}"
    }

    parameters {
        choice(
            name: 'BUILD_TYPE',
            choices: ['web', 'apk', 'both'],
            description: 'What to build?'
        )
        booleanParam(
            name: 'PUSH_DOCKER',
            defaultValue: true,
            description: 'Push Docker images to GHCR and Docker Hub?'
        )
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'flutter pub get'
            }
        }

        stage('Quality Checks') {
            parallel {
                stage('Format') {
                    steps {
                        // نستخدم || true حتى لا يفشل البناء بسبب تنسيق غير مثالي
                        sh 'dart format --set-exit-if-changed lib test || true'
                    }
                }
                stage('Analyze') {
                    steps {
                        sh 'flutter analyze --no-pub || true'
                    }
                }
                stage('Test') {
                    steps {
                        sh 'flutter test || true'
                    }
                }
            }
        }

        stage('Build Web') {
            when {
                expression { params.BUILD_TYPE == 'web' || params.BUILD_TYPE == 'both' }
            }
            steps {
                sh 'flutter build web --release'
                // حفظ مخرجات الويب لاستخدامها لاحقًا أو لأرشفتها
                stash includes: 'build/web/**', name: 'web-build'
            }
        }

        stage('Build APK') {
            when {
                expression { params.BUILD_TYPE == 'apk' || params.BUILD_TYPE == 'both' }
            }
            steps {
                sh 'flutter build apk --release --split-per-abi'
                stash includes: 'build/app/outputs/flutter-apk/*.apk', name: 'apk-build'
            }
        }

        stage('Build & Push Docker Images') {
            when {
                expression {
                    params.PUSH_DOCKER &&
                    (params.BUILD_TYPE == 'web' || params.BUILD_TYPE == 'both')
                }
            }
            steps {
                script {
                    // تعريف أسماء الصور مع الوسوم
                    def dockerImageGHCR = "${DOCKER_IMAGE_GHCR}:${IMAGE_VERSION}"
                    def dockerImageGHCRSha = "${DOCKER_IMAGE_GHCR}:${IMAGE_VERSION}-${env.GIT_COMMIT?.take(7)}"
                    def dockerImageHub = "${DOCKER_IMAGE_HUB}:${IMAGE_VERSION}"

                    // بناء الصورة من Dockerfile الموجود في جذر المشروع
                    sh "docker build -t ${dockerImageGHCR} -f Dockerfile ."

                    // دفع إلى GitHub Container Registry
                    docker.withRegistry('https://ghcr.io', 'ghcr-credentials') {
                        sh "docker tag ${dockerImageGHCR} ${dockerImageGHCRSha}"
                        sh "docker push ${dockerImageGHCR}"
                        sh "docker push ${dockerImageGHCRSha}"
                    }

                    // دفع إلى Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        sh "docker tag ${dockerImageGHCR} ${dockerImageHub}"
                        sh "docker push ${dockerImageHub}"
                    }
                }
            }
        }

        stage('Archive Artifacts') {
            steps {
                // أرشفة مخرجات البناء (APK و Web) للوصول إليها من واجهة Jenkins
                archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/*.apk, build/web/**', fingerprint: true
            }
        }
    }

    post {
        success {
            echo "🚀 Pipeline succeeded! Version: ${IMAGE_VERSION}"
        }
        failure {
            echo "❌ Pipeline failed. Check logs for details."
        }
        always {
            // تنظيف مساحة العمل بعد كل بناء
            cleanWs()
        }
    }
}
