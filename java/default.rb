#
# Cookbook:: provision
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
apt_repository 'java' do

    repo_name:'openjdk'

    uri 'ppa:webupd8team/java'

    action :add

end

apt_update 'name' do

    action :update

end

execute 'Java | Accept the Oracle license before the installation' do

         command "echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections"

end

apt_package 'oracle-java8-installer' do

    package_name 'oracle-java8-installer'

    action :install

end

apt_package 'oracle-java8-set-default' do

    package_name 'oracle-java8-set-default'

    action :install

end

bash "insert_line" do

         user "root"

         code <<-EOS

         echo "JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /etc/environment

         source /etc/environment

         EOS

end


