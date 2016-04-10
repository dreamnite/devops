describe package('httpd') do
  it { should be_installed }
end

describe file('/etc/httpd/conf.d') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
end

describe file('/etc/httpd/conf/httpd.conf') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
end

describe file('/opt/mywebapp') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'apache' }
    it { should be_grouped_into 'apache' }
end

describe file('/opt/mywebapp/index.html') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'apache' }
    it { should be_grouped_into 'apache' }
end

describe process("httpd") do
  it { should be_running }
end
