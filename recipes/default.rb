#
# Cookbook Name:: devops
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'include_me'
web_root_dir = node['devops']['web']['root_dir']
web_port     = node['devops']['web']['port']
test_url     = node['devops']['test_url']
# ---------------------------------------------------------------------------
# We're assuming rhel/centos
# ---------------------------------------------------------------------------
return if !node[:platform_family].include?("rhel")
# ---------------------------------------------------------------------------
# Install httpd & associated service
# ---------------------------------------------------------------------------
package 'httpd' do
    action :install
end
service 'httpd' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end
# ---------------------------------------------------------------------------
# Configure httpd
# ---------------------------------------------------------------------------
template '/etc/httpd/conf/httpd.conf' do
  source 'httpd.conf.erb'
  user 'root'
  group 'root'
  mode '644'
  variables ({
      'web_port'      => web_port,
      'web_root_dir'  => web_root_dir
  })
  notifies :restart, "service[httpd]"
end
directory web_root_dir do
    user 'root'
    group 'root'
    mode '755'
    notifies :restart, "service[httpd]"
end

template "#{web_root_dir}/index.html" do
  source 'index.html.erb'
  user 'root'
  group 'root'
  mode '644'
  variables ({
      'test_url' => test_url
  })
end
# ---------------------------------------------------------------------------
# Ensure correct selinux context
# ---------------------------------------------------------------------------
package 'Install semanage' do
    package_name 'policycoreutils-python'
end
# semanage fcontext -a -e /var/www/html /opt/mywebapp
execute 'web-selinux' do
    command '/usr/sbin/semanage fcontext -a -e ${webBaseDir} ${webRootDir}'
    environment(
      'webBaseDir' => '/var/www/html',
      'webRootDir' => web_root_dir
    )
    not_if '/usr/sbin/semanage export | /bin/grep "${webBaseDir} ${webRootDir}"'
    notifies :restart, "service[httpd]"
end
