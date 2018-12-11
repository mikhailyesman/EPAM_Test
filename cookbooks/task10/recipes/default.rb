#
# Cookbook:: task10
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

service 'docker' do
  action [:enable, :start]
end

if node.attribute?( 'vers' )
  puts "version: #{node['vers']}"
else
  puts 'Wrong vers'
end

begin
  h = node['host']
  p1 = node['port1']
  p2 = node['port2']

  p_lst = {}
  [ p1, p2 ].each do |p|
    begin
      Timeout.timeout(4) do
        Socket.tcp( h, p ){}
      end
      p_lst[p] = true
      puts "port #{p} is listening"
    rescue 
      p_lst[p] = false
      puts "port #{p} is free"
    end
  end

  
  
  p_start = !p_lst[p1] ? p1 : !p_lst[p2] ? p2 : 0
  p_stop = p_lst[p1] ? port1 : p_lst[p2] ? p2 : 0
  if p_start != 0
    puts "Will be start service on #{p_start}"
    if p_stop != 0
      puts "Will be stop service on #{p_stop}"
    end
  else
    puts "Error define service ports"
  end

  
  
  node.override['port_start'] = p_start if p_start != 0
  node.override['port_stop'] = p_stop if p_stop != 0
end



execute 'service_start' do
  command "docker run -d -p #{node['port_start']}:8080 --name #{node['branch']}_#{node['port_start']} #{node['server_ip']}:5000/#{node['branch']}:#{node['vers']}"
  only_if { node.attribute?('port_start') }
end

execute 'service_stop' do
  command "docker stop #{node['branch']}_#{node['port_stop']} && docker rm #{node['branch']}_#{node['port_stop']}"
  only_if { node.attribute?('port_stop') }
end

