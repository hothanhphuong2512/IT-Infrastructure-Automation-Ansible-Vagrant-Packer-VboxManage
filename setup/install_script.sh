#!/bin/bash

#Create todoapp if not exist

if id 'todoapp' &>/dev/null; then
        echo  'User todoapp exists'
else
        sudo useradd -m -p Password todoapp
fi

#As admin

	#Firewall

sudo firewall-cmd --zone=public --add-port=8080/tcp
sudo firewall-cmd --zone=public --add-port=80/tcp
sudo firewall-cmd --runtime-to-permanent

	#SELINUX

sudo cp -f /home/admin/setup/selinux_config /etc/selinux/config

	#Install nodejs

curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo dnf install -y nodejs
echo 'SUCESSFULLY INSTALLED NODE' $(node -v)

	#Install mongodb

sudo cp -f /home/admin/setup/mongodb-org-4.4.repo /etc/yum.repos.d/mongodb-org-4.4.repo
sudo yum install -y mongodb-org
echo 'MONGODB INSTALLED SUCESSFUL' $(mongod --version)

	#Download app

sudo dnf install git -y
sudo chmod 755 /home/todoapp/
cd /home/todoapp/
sudo mkdir app
sudo git clone https://github.com/timoguic/ACIT4640-todo-app /home/todoapp/app

sudo cp /home/admin/setup/database.js /home/todoapp/app/config/database.js 
sudo su - todoapp -c "npm install /home/todoapp/app"

sudo systemctl enable mongod
sudo systemctl start mongod
echo $(sudo systemctl status mongod)

	#Nginx and systemd

sudo cp -f /home/admin/setup/todoapp.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable todoapp
sudo systemctl start todoapp

sudo dnf install -y epel-release
sudo dnf install -y nginx
sudo cp -f /home/admin/setup/nginx.conf /etc/nginx/nginx.conf

sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx

