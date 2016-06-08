#
# Cookbook Name:: devops
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

document_root	=	node[:devops][:webserver][:document_root]
port			=	node[:devops][:webserver][:port]
test_url		=	node[:devops][:test_url]


directory document_root

file "#{document_root}/index.html" do
	content "This website created by Chef for the Devops skill test located at #{test_url}"
end

package 'httpd'

template '/etc/httpd/conf.d/000_test_url.conf' do
	source '000_test_url.conf.erb'
	variables( :document_root => document_root, :port => (port || 8080) )
end

service 'httpd' do
	action [:start, :enable]
end
