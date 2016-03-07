require 'serverspec'
require 'pathname'
set :backend, :exec
#include Serverspec::Helper::Exec

describe 'devops::default' do
  it 'webserver is listening on port 8080' do
    expect(port(8080)).to be_listening
  end
end

describe port(8080) do
  it { should be_listening }
end

describe command('curl localhost:8080') do
  its(:stdout) {
    should match /This website created by Chef for the Devops skill test located at https:\/\/github.com\/.*\/devops/
  }
end
