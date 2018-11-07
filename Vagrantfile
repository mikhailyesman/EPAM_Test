TOMCAT_COUNT = 3

$a1 = <<SCRIPT1
	yum install httpd -y
	systemctl enable httpd
	systemctl start httpd
	service httpd status
	cp /vagrant/mod_jk.so /etc/httpd/modules/
	chmod +x /etc/httpd/modules/mod_jk.so
	echo 'worker.list=lb' >> /etc/httpd/conf/workers.properties
	echo 'worker.lb.type=lb' >> /etc/httpd/conf/workers.properties
	for (( c=1; c<=$1; c++ ))
		do
		let s='c+65'
		echo 'worker.lb.balance_workers=tomcat'$c >> /etc/httpd/conf/workers.properties
		echo 'worker.tomcat'$c'.host=192.168.10.'$s >> /etc/httpd/conf/workers.properties
		echo 'worker.tomcat'$c'.port=8009' >> /etc/httpd/conf/workers.properties
		echo 'worker.tomcat'$c'.type=ajp13' >> /etc/httpd/conf/workers.properties
		done
	echo 'LoadModule jk_module modules/mod_jk.so' >> /etc/httpd/conf/httpd.conf
	echo 'JkWorkersFile conf/workers.properties' >> /etc/httpd/conf/httpd.conf
	echo 'JkShmFile /tmp/shm' >> /etc/httpd/conf/httpd.conf
	echo 'JkLogFile logs/mod_jk.log ' >> /etc/httpd/conf/httpd.conf
	echo 'JkLogLevel info' >> /etc/httpd/conf/httpd.conf
	echo 'JkMount /test* lb' >> /etc/httpd/conf/httpd.conf
	service httpd restart
SCRIPT1

$a2 = <<SCRIPT2
	yum install tomcat tomcat-webapps tomcat-admin-webapps -y
	systemctl enable tomcat
	systemctl start tomcat
	systemctl stop firewalld
	cd /usr/share/tomcat/webapps/
	ls -al
	mkdir /usr/share/tomcat/webapps/test
	echo 'TomCat'$1 >> /usr/share/tomcat/webapps/test/index.html
	chown -R tomcat:tomcat /usr/share/tomcat/webapps/test/
SCRIPT2

Vagrant.configure("2") do |config|
	config.vm.box = "bento/centos-7.5"
	config.ssh.forward_agent = true
	config.vm.define "server" do |server|
		server.vm.hostname = "server"
		server.vm.network "private_network", ip: "192.168.10.44"
		server.vm.network "forwarded_port", guest: 80, host: 8080
		server.vm.provision :shell, inline: $a1, :args => TOMCAT_COUNT
	end
	(1..TOMCAT_COUNT).each do |i|
		config.vm.define "tomcat#{i}" do |extrascfg|
			extrascfg.vm.hostname = "tomcat#{i}"
			extrascfg.vm.network :private_network, ip: "192.168.10.#{65+i}"
			extrascfg.vm.provision "shell", inline: $a2, :args => i
		end
	end
end
