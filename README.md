# docker-dell-omsa
Dockerized OpenManage server administrator (OMSA) with custom credentials.

## Install

* Install Docker and Docker Compose
* Configure the `docker-compose-example.yml`
* Rename the `docker-compose-example.yml` to `docker-compose.yml`
* `docker-compose up -d`
* Login to the webinterface with the credentials `root` and your custom defined password

## Environment variables

* `PASSWORD` The passwort for the webinterface login. The username stays `root`
