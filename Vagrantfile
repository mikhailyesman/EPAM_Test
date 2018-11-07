Vagrant.configure("2") do |config|
  config.ssh.forward_agent = true
  config.vm.define :server1 do |server1|
    server1.vm.box = "bento/centos-7.5"      
    server1.vm.host_name = "server1"
    server1.vm.network "private_network", ip: "192.168.10.44"
    server1.vm.provision "shell", inline: <<-SHELL 
      echo "192.168.10.44	server1" >> /etc/hosts
      echo "192.168.10.66	server2" >> /etc/hosts
      yum install git –y -y
      echo "  \n"
      echo "super\n"
      git --version
      cd /home/vagrant/
      git clone https://github.com/mikhailyesman/Task_Test2.git
      cd /home/vagrant/Task_Test2
      git checkout -b task2 origin/task2
      ping -c 5 server2
      cat /home/vagrant/Task_Test2/new_file.txt
    SHELL
  end

  config.vm.define :server2 do |server2|
    server2.vm.box = "bento/centos-7.5"      
    server2.vm.host_name = "server2"
    server2.vm.network "private_network", ip: "192.168.10.66"
    server2.vm.provision "shell", inline: <<-SHELL 
      echo "192.168.10.44	server1" >> /etc/hosts
      echo "192.168.10.66	server2" >> /etc/hosts
      ping -c 5 server1
    SHELL
  end
  

end
