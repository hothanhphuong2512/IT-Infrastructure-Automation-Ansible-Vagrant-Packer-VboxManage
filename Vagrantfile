# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "4640BOX"

  config.ssh.username = "admin"
  config.ssh.private_key_path = "acit_admin_id_rsa"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
  end





  config.vm.define "tododb" do |tododb|
    tododb.vm.provider "virtualbox" do |vb|
        vb.name = "TODO_DB_4640"
        vb.memory = 1024
    end
    tododb.vm.hostname = "tododb.bcit.local"
    tododb.vm.network "private_network", ip: "192.168.150.20"

	tododb.vm.provision "file", source: "./ansible", destination: "/home/admin/ansible"
	tododb.vm.provision "ansible_local" do |ansible|
	    ansible.provisioning_path = "/home/admin/ansible"
	    ansible.playbook = "/home/admin/ansible/database.yaml"
		end
	end

  config.vm.define "todowww" do |todowww|
    todowww.vm.provider "virtualbox" do |vb|
        vb.name = "TODO_WWW_4640"
        vb.memory = 1024
    end
    todowww.vm.hostname = "todowww.bcit.local"
    todowww.vm.network "private_network", ip: "192.168.150.30"
	todowww.vm.network "forwarded_port", guest: 80, host: 12080
	todowww.vm.provision "file", source: "./ansible", destination: "/home/admin/ansible"
	todowww.vm.provision "ansible_local" do |ansible|
	    ansible.provisioning_path = "/home/admin/ansible"
	    ansible.playbook = "/home/admin/ansible/www.yaml"
		end
	end

  config.vm.define "todoapp" do |todoapp|
    todoapp.vm.provider "virtualbox" do |vb|
        vb.name = "TODO_APP_4640"
        vb.memory = 1024
    end
    todoapp.vm.hostname = "todoapp.bcit.local"
    todoapp.vm.network "private_network", ip: "192.168.150.10"

	todoapp.vm.provision "file", source: "./ansible", destination: "/home/admin/ansible"
	todoapp.vm.provision "ansible_local" do |ansible|
	    ansible.provisioning_path = "/home/admin/ansible"
	    ansible.playbook = "/home/admin/ansible/app.yaml"
	end
	end

end
