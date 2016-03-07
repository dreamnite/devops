require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.platform = 'ubuntu'  # (default: nil)
  config.version = '14.04'  # (default: nil)
end

describe 'devops::default' do
  let (:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['devops']['test_url'] = "https://github.com/MikeMorrow/devops"
      node.set['devops']['web']['root_dir'] = "/opt/mywebapp"
      node.set['devops']['web']['port'] = "8080"
    end.converge(described_recipe)
  end

  # Chefspec needs to converge
  it '0. converges successfully' do
    chef_run
  end
  # 1. This cookbook should install and configure an apache web server
  it '1. installs apache web server' do
    expect(chef_run).to install_package('apache2')
  end
  it '1. enables apache web server' do
    expect(chef_run).to enable_service('apache2')
  end
  it '1. configures apache web server' do
    expect(chef_run).to create_template('/etc/apache2/sites-available/000-default.conf')
  end
  # 2. The webserver should listen on a configurable port, with a default of 8080
  it '2. listen on a configurable port, default 8080' do
    expect(chef_run).to render_file('/etc/apache2/sites-available/000-default.conf')
      .with_content(/<VirtualHost \*:8080>/)
    expect(chef_run).to render_file('/etc/apache2/ports.conf').with_content(/Listen 8080/)
  end
  # 3. The document root should be configurable and point to /opt/mywebapp by default.
  it '3. create configurable document root, default /opt/mywebapp' do
    expect(chef_run).to create_directory('/opt/mywebapp')
  end
  it '3. set configurable document root, default /opt/mywebapp' do
    expect(chef_run).to render_file('/etc/apache2/sites-available/000-default.conf')
      .with_content(/<Directory "\/opt\/mywebapp">/)
  end
  # 4. The cookbook should include a node attribute ['devops']['test_url'] which
  #    should point to your fork of the repository on github by default.
  it "4. ['devops']['test_url'] set to default" do
    node = chef_run.node
    expect(node['devops']['test_url']).to eq("https://github.com/MikeMorrow/devops")
  end
  # 5. The webserver should serve an index.html
  it "5. serve index.html" do
    node = chef_run.node
    expect(chef_run).to render_file("#{node['devops']['web']['root_dir']}/index.html")
  end
  # 6. he website should display the following text, replacing test_url with the value of node['devops']['test_url']:
  # This website created by Chef for the Devops skill test located at <test_url>
  it "6. verfify index.html contents" do
    node = chef_run.node
    expect(chef_run).to render_file("#{node['devops']['web']['root_dir']}/index.html")
      .with_content("This website created by Chef for the Devops skill test located at #{node['devops']['test_url']}")
  end
  # 7. Include the default recipe from https://github.com/dreamnite/include_me
  it 'should include the include_me default recipe' do
   expect(chef_run).to include_recipe 'include_me::default'
  end
end
