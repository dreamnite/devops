#
# Cookbook Name:: devops
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'devops::default' do
  context 'When all attributes are default, on a Centos 7.2 platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end
    	
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
