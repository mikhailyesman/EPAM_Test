#
# Cookbook:: bookmy
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
yum_repository 'docker-ce-stable' do
  description 'Docker CE Stable'
  baseurl 'https://download-stage.docker.com/linux/centos/7/x86_64/stable'
  enabled true
  gpgcheck true
  gpgkey 'https://download-stage.docker.com/linux/centos/gpg'
  repositoryid 'docker-ce'
  action :create
end

yum_package 'docker-ce' do
  action :install
end

file '/etc/docker/daemon.json' do
        content '{ "insecure-registries" : ["192.168.10.112:5000" ] }'
        owner 'root'
        group 'root'
        mode '0755'
        action :create_if_missing
end

service 'docker' do
  action [:enable, :start]
end
