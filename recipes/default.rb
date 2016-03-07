#
# Cookbook Name:: devops
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'include_me'
# ---------------------------------------------------------------------------
# Set variables
# ---------------------------------------------------------------------------
webRootDir = node['devops']['web']['root_dir']
webPort    = node['devops']['web']['port']
test_url   = node['devops']['test_url']
# platform specific variables
case node['platform'] # or platform_family
when 'redhat', 'centos' # or rhel
    apachePackageName = 'httpd'
    apacheConfigTemplate = 'httpd.conf.erb'
    apacheConfigFile = '/etc/httpd/conf/httpd.conf'
when 'ubuntu', 'debian' # or debian
    apachePackageName =  'apache2'
    apacheConfigTemplate = '000-default.conf.erb'
    apacheConfigFile = '/etc/apache2/sites-available/000-default.conf'
end
# ---------------------------------------------------------------------------
# Install httpd & associated service
# ---------------------------------------------------------------------------
package 'httpd' do
  package_name apachePackageName
  action :install
end
service 'httpd' do
  service_name apachePackageName
  supports :status => true, :restart => true, :reload => true
  action :enable
end
# ---------------------------------------------------------------------------
# Configure httpd
# ---------------------------------------------------------------------------
template apacheConfigFile do
  source apacheConfigTemplate
  user 'root'
  group 'root'
  mode '644'
  variables ({
      'webPort'     => webPort,
      'webRootDir'  => webRootDir
  })
  notifies :restart, "service[httpd]"
end
directory webRootDir do
    user 'root'
    group 'root'
    mode '755'
    notifies :restart, "service[httpd]"
end
template "#{webRootDir}/index.html" do #FoodCritic is confused here
  source 'index.html.erb'
  user 'root'
  group 'root'
  mode '644'
  variables ({
      'test_url' => test_url
  })
  notifies :restart, 'service[httpd]'
end
template '/etc/apache2/ports.conf' do #FoodCritic is confused here
  source 'ports.conf.erb'
  user 'root'
  group 'root'
  mode '644'
  variables ({
      'webPort' => webPort
  })
  notifies :restart, "service[httpd]"
  only_if { node['platform'].include?('ubuntu') }
end
# ---------------------------------------------------------------------------
# Exit before selinux fixes if we're not on rhel/centos
# ---------------------------------------------------------------------------
return unless node['platform_family'].include?("rhel")
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
      'webRootDir' => webRootDir
    )
    not_if '/usr/sbin/semanage export | /bin/grep "${webBaseDir} ${webRootDir}"'
    notifies :restart, "service[httpd]"
end
