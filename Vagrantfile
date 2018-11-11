TOMCAT_COUNT = 2

$a1 = <<SCRIPT1
	yum install java-1.8.0-openjdk-devel -y
	yum install epel-release -y
	yum install wget mc nano sudo git
	curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
	
	rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
	yum install java jenkins -y
	#yum install jenkins -y
	systemctl enable jenkins
	systemctl start jenkins
	systemctl status jenkins

	wget http://download.sonatype.com/nexus/3/latest-unix.tar.gz
	tar xvf latest-unix.tar.gz -C /opt
	cd ~
	cd /opt/nexus-3.14.0-04/
	./bin/nexus start
	netstat -tln
	ln -s /opt/nexus-3.14.0-04/bin/nexus /etc/init.d/nexus
	systemctl start nexus.service

	cat >/etc/yum.repos.d/docker.repo <<-EOF
		[dockerrepo]
		name=Docker Repository
		baseurl=https://yum.dockerproject.org/repo/main/centos/7
		enabled=1
		gpgcheck=1
		gpgkey=https://yum.dockerproject.org/gpg
		EOF
	yum install docker -y
	chkconfig docker on
	groupadd docker
	gpasswd -a vagrant docker
	usermod -aG docker jenkins
	systemctl enable docker.service
	systemctl start docker.service
	curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose


	chmod +x /usr/local/bin/docker-compose
	docker-compose --version

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
		let s='c+111'
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
	yum install epel-release -y
	yum install wget mc nano sudo java git
	adduser jenkins -d /var/jenkins_home -G wheel
	echo -e "jenkins\njenkins\n" | passwd jenkins

		cat >/etc/yum.repos.d/docker.repo <<-EOF
		[dockerrepo]
		name=Docker Repository
		baseurl=https://yum.dockerproject.org/repo/main/centos/7
		enabled=1
		gpgcheck=1
		gpgkey=https://yum.dockerproject.org/gpg
		EOF
	yum install docker -y
	chkconfig docker on
	groupadd docker
	gpasswd -a vagrant docker
	usermod -aG docker jenkins
	systemctl enable docker.service
	systemctl start docker.service
	curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
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
		server.vm.network "private_network", ip: "100.64.0.111"
		server.vm.network "forwarded_port", guest: 80, host: 1111
		server.vm.provision :shell, inline: $a1, :args => TOMCAT_COUNT
	end
	(1..TOMCAT_COUNT).each do |i|
		config.vm.define "tomcat#{i}" do |extrascfg|
			extrascfg.vm.hostname = "tomcat#{i}"
			extrascfg.vm.network :private_network, ip: "100.64.0.#{111+i}"
			extrascfg.vm.provision "shell", inline: $a2, :args => i
		end
	end
end
