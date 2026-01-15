#!/bin/bash

# Task: Deploy a pre-built Django app on AWS EC2 using Docker and Nginx

# Clone the GitHub repo
git_clone() {
    echo "Cloning the App From Repo..."
    if [ ! -d "django-notes-app" ]; then
        git clone https://github.com/LondheShubham153/django-notes-app.git
    else
        echo "Code directory already exists. Skipping clone..."
    fi
}

# Install required packages
get_req() {
    echo "Installing Docker and Nginx..."
    sudo apt-get update
    sudo apt-get install -y docker.io nginx
}

# Enable and restart services
restarts() {
    echo "Restarting Docker and Nginx services..."
    sudo chown $USER /var/run/docker.sock
    sudo systemctl restart docker
    sudo systemctl restart nginx
    sudo systemctl enable docker
    sudo systemctl enable nginx
}

# Deploy the Django app
deploy() {
    echo "Deploying the Django app container..."
    cd django-notes-app || { echo "Failed to enter project directory"; exit 1; }
    docker build -t notes-app .
    docker run -d -p 8000:8000 notes-app
}


git_clone
if ! get_req; then
    echo " Dependency installation failed!"
    exit 1
fi

if ! restarts; then
    echo " Failed to configure services!"
    exit 1
fi

if ! deploy; then
    echo " Deployment failed!"
    exit 1
fi


echo "Django App successfully deployed!"



