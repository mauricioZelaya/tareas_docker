#!/bin/bash

###########################################################################################
# Script to create 5 docker containers in a network called homeworknet by Mauricio Zelaya
###########################################################################################

# create network:
$ docker network create homeworknet

###############################   POSTGRES   ##############################################
# create the postgres volume:
$ docker volume create postgres_vol_mz

# run postgres with custom config
docker run -d -it --name postgresdb \
	-v postgres_vol_mz:/var/lib/postgresql/data \
	-e POSTGRES_USER=sonar \
	-e POSTGRES_PASSWORD=sonaradmin \
	--network homeworknet postgres:latest

###############################   SONARQUBE   ##############################################
# create the volumes with the following commands:
docker volume create sonarqube_data_vol_mz
docker volume create sonarqube_logs_vol_mz
docker volume create sonarqube_extensions_vol_mz

# for Linux set the recommended values for the current session by running the following commands as root on the host:
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -w fs.file-max=131072

# run the image with your database properties defined using the -e environment variable flag: 
docker run -d -it --name sonarqubetool \
-e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 \
-e SONAR_JDBC_URL=jdbc:postgresql://localhost/sonarqube?currentSchema=my_schema \
-e SONAR_JDBC_USERNAME=sonar \
-e SONAR_JDBC_PASSWORD=sonaradmin \
-v sonarqube_data_vol_mz:/opt/sonarqube/data \
-v sonarqube_extensions_vol_mz:/opt/sonarqube/extensions \
-v sonarqube_logs_vol_mz:/opt/sonarqube/logs \
--network homeworknet sonarqube:latest

############################### Jenkins ###############################
# create the jenkins volume:
docker volume create jenkins_vol_mz

# run the Jenkins image
docker run -d -it --name jenkinscicd \
	-v jenkins_vol_mz:/var/jenkins_home \
	-p 8080:8080 -p 50000:50000 \
	--network homeworknet jenkins/jenkins

############################### Sonatype Nexus 3 ###############################
# create the Sonartype Nexus 3 volume:
docker volume sonartype_vol_mz

# run the Sonatype Nexus 3 image image:
docker run -d -it --name sonartyperepository \
	-p 8081:8081 \
	-v sonartype_vol_mz:/nexus-data \
	--network homeworknet sonatype/nexus3

############################### Portainer ############################### 
# create the Portainer volume:
docker volume create portainer_vol_mz

# portainer Server Deployment:
docker run -d --name=portainerui \
	-p 8000:8000 -p 9000:9000 \
	--restart=always \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v portainer_vol_mz:/data \
	--network homeworknet portainer/portainer-ce

# portainer Agent Only Deployment:
docker run -d --name portainer_agent \
	-p 9001:9001 \
	--restart=always \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /var/lib/docker/volumes:/var/lib/docker/volumes \
	--network homeworknet portainer/agent