#
# Cookbook:: maven
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

#git '/root/chef-repo/cookbooks/maven/recipes' do
# repository https://github.com/tarungoel1995/ContinuousIntegration.git
# action :checkout
#end

git 'Cloning Repo and checkout branch master to opstree<F8>' do
  repository 'https://github.com/tarungoel1995/ContinuousIntegration.git'
  revision 'master'
  destination '/home/vagrant/deployment'
  action :checkout
end

package 'maven' do
 action :install
end

execute 'building package' do
 command 'mvn package install'
 cwd '/home/vagrant/deployment/Spring3HibernateApp/'
end
