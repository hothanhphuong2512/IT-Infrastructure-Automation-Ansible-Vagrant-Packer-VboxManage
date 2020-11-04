# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "4640BOX"

  config.ssh.username = "admin"
  config.ssh.private_key_path = "files/acit_admin_id_rsa"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
  end

  config.vm.define "tododb" do |tododb|
    tododb.vm.provider "virtualbox" do |vb|
        vb.name = "TODO_DB_4640"
        vb.memory = 1536
    end
    tododb.vm.hostname = "tododb.bcit.local"
    tododb.vm.network "private_network", ip: "192.168.150.20"
    tododb.vm.provision "file", source: "./files/mongodb-org-4.4.repo", destination: "/tmp/mongodb-org-4.4.repo"
    tododb.vm.provision "shell", inline: <<-SHELL
        mv /tmp/mongodb-org-4.4.repo /etc/yum.repos.d/mongodb-org-4.4.repo
        dnf install -y mongodb-org tar 
        dnf whatprovides mongorestore


        sed -r -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf
        wget https://student:BCIT2020@acit4640.y.vu/docs/module06/resources/mongodb_ACIT4640.tgz
        tar zxf mongodb_ACIT4640.tgz
        mongorestore -d acit4640 ACIT4640 

        systemctl daemon-reload                                                                                                                                                                                     
        systemctl enable mongod
        systemctl start mongod

        firewall-cmd --zone=public --add-port=27017/tcp
        firewall-cmd --runtime-to-permanent

        SHELL
    
  end

  config.vm.define "todonginx" do |todonginx|
    todonginx.vm.provider "virtualbox" do |vb|
        vb.name = "TODO_NGINX_4640"
        vb.memory = 2048
    end
    todonginx.vm.hostname = "todonginx.bcit.local"
    todonginx.vm.network "private_network", ip: "192.168.150.30"
    todonginx.vm.network "forwarded_port", guest: 80, host: 8080
    todonginx.vm.provision "file", source: "./files/nginx.conf", destination: "/tmp/nginx.conf"
    todonginx.vm.provision "shell", inline: <<-SHELL
      
      dnf install -y nginx  
      mv /tmp/nginx.conf /etc/nginx/nginx.conf
      systemctl enable nginx 
      systemctl start nginx  

    SHELL


  end

  config.vm.define "todoapp" do |todoapp|
    todoapp.vm.provider "virtualbox" do |vb|
        vb.name = "TODO_APP_4640"
        vb.memory = 2048
    end
    todoapp.vm.hostname = "todoapp.bcit.local"
    todoapp.vm.network "private_network", ip: "192.168.150.10"
    todoapp.vm.provision "file", source:"./files/database.js", destination: "/tmp/database.js"
    todoapp.vm.provision "file", source:"./files/todoapp.service", destination: "/tmp/todoapp.service"
  
    todoapp.vm.provision "shell", inline: <<-SHELL
      curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -                                                                                                                                                
      dnf install -y nodejs                                                                                                                                                                                       
      dnf install -y epel-release                                                                                                                                                                                                                                                                                                                                                                  
      dnf install git -y

      useradd todoapp
      sudo chmod 755 /home/todoapp/                                                                                                                                                                               
      sudo -u todoapp git clone https://github.com/timoguic/ACIT4640-todo-app.git /home/todoapp/app
      sudo -u todoapp npm install --prefix /home/todoapp/app

      mv /tmp/database.js /home/todoapp/app/config/database.js
      mv /tmp/todoapp.service /etc/systemd/system/todoapp.service
      
      firewall-cmd --zone=public --add-port=8080/tcp

      systemctl enable todoapp.service  
      systemctl start todoapp.service   

    SHELL
  end






end
