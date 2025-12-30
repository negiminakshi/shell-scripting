#!/bin/bash

<< task
Deploy a django app and handle code for errors
task

code_clone() {

	echo "cloning the django app"
	git clone https://github.com/LondheShubham153/django-notes-app.git

}

install_requirements() {

	echo " installing dependencies"
	sudo apt-get update
	sudo apt-get install docker.io nginx -y

}

required_restart() {
   
	sudo systemctl enable docker
	sudo systemctl enable nginx
	sudo usermod -aG docker $USER 
	sudo systemctl restart docker
	sudo apt-get install docker-compose-v2

}

docker_build() {
    docker build -t notes-app .
    docker compose up --build

}


echo "*******deplyment started*********"

if ! code_clone; then
	echo "the code dir exists"
	cd django-notes-app
fi

if ! install_requirements; then
	echo "installaton failed"
	exit 1
fi

if ! required_restart; then
	echo "system fault"
	exit 1

fi
docker_build

echo "*********deployment completed**********"
