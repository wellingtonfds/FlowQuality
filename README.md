# SonarQube Server and SonarScan
[Sonarqube](https://www.sonarqube.org/)

The serve you go need docker-compose, follow this [tutorial](https://docs.docker.com/compose/install/)

##### Steps to init server

1. if you wish change something configuration in server, use the docker-compose.override. Copy the docker-compose.override.yml.example to 
docker-compose.override.yml and change what you want.
2. After install docker-compose init the project
    2.1 docker-compose up -d
3. To access the server use http://locahost:port  "admin" for  user and pass.
4. Importe in "Quality Profiles" all files in directory "quality-profiles"


##### Steps to scan a project

1. Acess directory "sonar-scanner/conf" and copy file "sonar-scanner.properties.example" without ".example"
2. Do config as you configured the server



