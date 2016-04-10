#
# Cookbook Name:: devops
# Recipe:: default
#
# Copyright 2016, Madhu Joshi
#
# All rights reserved - Do Not Redistribute
#

# include external recipe.
include_recipe 'include_me::default'

# install appropriate package.
# XXX TODO; Update to check OS before installing right package (httpd vs apache2)
# For simplicity, assuming RedHat / CentOS based system
package 'httpd'

directory node['devops']['doc_root'] do
   recursive true
   action  :create
   owner   node['devops']['owner']
   group   node['devops']['group']
end

# Create a home page at the specified location using the template
# The template, index.html.erb is retrieved from templates directory
# and then variable substitutions are performed
# Changes to home pages don't require service restarts
template node['devops']['home_page'] do
   source   'index.html.erb'
   owner    node['devops']['owner']
   group    node['devops']['group']
   mode     '0644'
end

template node['devops']['conf_file'] do
   source   'httpd.conf.erb'
   owner    'root'
   group    'root'
   mode     '0644'
   notifies :restart, 'service[httpd]'
end

# make sure httpd service is started and enabled (restarted after reboot)
# Other resources can send restart or reload requests to this service
service 'httpd' do
   action [:start, :enable]
   supports :restart => true, :reload => true
end

