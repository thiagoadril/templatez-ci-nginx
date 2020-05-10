def FOLDER_APP_NAME

pipeline {
    agent any

    stages { 
		stage('INIT') {
            steps{
                script{
                    FOLDER_APP_NAME="app"
                }
            }                
        }

		/*
		 *	[CLEAN - (START)]
		 */
		stage('CLEAR (START)') {
			steps {
				echo "-----------------------------------"
				echo 'Initial cleaning running....'
				script {
					fileOperations([folderDeleteOperation("${FOLDER_APP_NAME}/ci")])
				}
				echo '-----------------------------------'
			}
		}

		/*
		 *	[IO (FILES)]
		 */
		stage('IO (FILES)') {
		    steps  {
				echo '-----------------------------------'
				echo 'IO starting...'
				script {
					fileOperations([folderCopyOperation(destinationFolderPath: "${FOLDER_APP_NAME}/ci/image/deploy", sourceFolderPath: "${FOLDER_APP_NAME}/nginx")])
					fileOperations([fileCopyOperation(excludes: '', flattenFiles: true, includes: "${FOLDER_APP_NAME}/Dockerfile*", targetLocation: "${FOLDER_APP_NAME}/ci/image")])
				}
				echo '-----------------------------------'
			}
        }
		
		/*
		 *	[IMAGES]
		 */
        stage('IMAGES') {
            steps {
				echo '-----------------------------------'
				echo 'Generating app image...'
				script {
					if(env.BRANCH_NAME.contains('master')) {
						docker.withTool('Default') {
							def baseimage = docker.image('nginx:1.17.9-alpine')
							baseimage.pull()
							def image = docker.build("company_template_nginx_${env.BRANCH_NAME.replace('feature/','').replace('release/','').toLowerCase()}:${env.BUILD_ID}","${FOLDER_APP_NAME}/ci/image/")
							image.tag("latest");
						}
					} else {
						docker.withTool('Default') {
							def baseimage = docker.image('nginx:1.17.9-alpine')
							baseimage.pull()
							def image = docker.build("company_template_nginx_${env.BRANCH_NAME.replace('feature/','').replace('release/','').toLowerCase()}","${FOLDER_APP_NAME}/ci/image/")
							image.tag("latest");
						}
					}
				}
				echo '-----------------------------------'
            }
        }
		
		/*
		 *	[ENVIRONMENT]
		 */
		stage('ENVIRONMENT') {
			steps {
				echo '-----------------------------------'
				echo 'Configure application environment...'
				script {
					docker.withTool('Default') {
						
						def imagesuffix  = "${env.BRANCH_NAME.replace('feature/','').replace('release/','').toLowerCase()}"
						def image = docker.image('docker/compose:1.23.2')
						image.pull()
						
						withDockerContainer(args: '--entrypoint=\'\'', image: 'docker/compose:1.23.2', toolName: 'Default') {
							withEnv(["IMAGE_SUFFIX=${imagesuffix}"]) {
								switch(env.BRANCH_NAME) {
								  case "master":
								    sh 'NETWORK_NAME=template_app_nginx_production && chmod 777 ./docker/scripts/configure-network.sh && sh ./docker/scripts/configure-network.sh'
									sh 'cp docker/env/docker-env-production.env .env'
									sh "docker-compose -f docker/compose/docker-compose.yaml -f docker/compose/docker-compose-production.yaml --project-name template_app_nginx_${imagesuffix} up -d"
									break
								  case "staging":
								  	sh 'NETWORK_NAME=template_app_nginx_staging && chmod 777 ./docker/scripts/configure-network.sh && sh ./docker/scripts/configure-network.sh'
									sh 'cp docker/env/docker-env-staging.env .env'
									sh "docker-compose -f docker/compose/docker-compose.yaml -f docker/compose/docker-compose-staging.yaml --project-name template_app_nginx_staging up -d"
									break
								  case "testing":
								  	sh 'NETWORK_NAME=template_app_nginx_testing && chmod 777 ./docker/scripts/configure-network.sh && sh ./docker/scripts/configure-network.sh'
									sh 'cp docker/env/docker-env-testing.env .env'
									sh "docker-compose -f docker/compose/docker-compose.yaml -f docker/compose/docker-compose-testing.yaml --project-name template_app_nginx_testing up -d"
									break
								  case "develop":
								  	sh 'NETWORK_NAME=template_app_nginx_development && chmod 777 ./docker/scripts/configure-network.sh && sh ./docker/scripts/configure-network.sh'
									sh 'cp docker/env/docker-env-development.env .env'
									sh "docker-compose -f docker/compose/docker-compose.yaml -f docker/compose/docker-compose-development.yaml --project-name template_app_nginx_development up -d"
									break;
								}
							}
						}
					}
				}
				echo '-----------------------------------'
			}
		}
		
		/*
		 *	[CLEAN (END)]
		 */
		stage('CLEAN (END)') {
			steps {
				echo '-----------------------------------'
				echo 'End cleaning running....'
				script {
					fileOperations([folderDeleteOperation("${FOLDER_APP_NAME}/ci")])
				}
				echo '-----------------------------------'
			}
		}		
    }
}