require 'spec_helper'

describe 'devops::default' do
  describe port(8080) do
  	it { should be_listening }
  end
  
  describe file('/opt/mywebapp/index.html') do
  	it { should be_file }
  end
  
  describe command('curl http://127.0.0.1:8080') do
  	its(:stdout) { should match /This website created by Chef for the Devops skill test located at https:\/\/github.com\/edromero\/devops/ }
  end
end
