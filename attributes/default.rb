#
# Cookbook Name:: devops
# Attributes:: default
#
default['devops']['port']      = 8080
default['devops']['doc_root']  = '/opt/mywebapp'
default['devops']['conf_file'] = '/etc/httpd/conf/httpd.conf'
default['devops']['test_url']  = 'https://github.com/madhujoshi/devops'
default['devops']['home_page'] = "#{node['devops']['doc_root']}/index.html"
default['devops']['owner']     = 'apache'
default['devops']['group']     = 'apache'
