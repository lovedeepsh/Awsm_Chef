#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
user 'tomcat' do
 comment 'tomcat user'
 home '/opt/tomcat'
 shell '/bin/false'
 password '123'
end

group 'tomcat' do
 action :modify
 members 'tomcat'
 append true
end

directory "/opt/tomcat/" do
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  action :create
end


remote_file '/opt/apache-tomcat-8.5.32.tar.gz' do
 source 'http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32.tar.gz'
 owner 'tomcat'
 group 'tomcat'
end

execute 'apache-tomcat-8.5.32' do
  command 'tar xzvf apache-tomcat-8.5.32.tar.gz -C /opt/tomcat --strip-components=1'
  cwd '/opt'
#  command 'sudo mv apache-tomcat-8.5.32 /opt/tomcat' 
end


#tar_package 'http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32.tar.gz' do
# prefix '/usr/local' 
# creates '/usr/local/bin'
#end

execute 'Changing owner for tomcat subdirectories recursively' do
command <<-rajat
 chown -R tomcat:tomcat /opt/tomcat/
 chmod +x /opt/tomcat/bin/*
 rajat
end

#execute 'giving execute permission to bin folder' do
# command 'chmod +x /opt/tomcat/bin/*'
#end

bash "insert_line" do
         user "root"
         code <<-EOS
         echo "export CATALINA_HOME=/opt/tomcat" >> /root/.bashrc
         source ~/.bashrc
         EOS
end

cookbook_file '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service'
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  action :create
end

execute 'reloading daemon' do
 command 'systemctl daemon-reload'
end

service "tomcat.service" do
  action :start
end

