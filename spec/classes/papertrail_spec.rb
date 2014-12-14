require 'spec_helper'

describe 'adv_windows::papertrail' do
  let(:params) { {:host => 'logs.papertrailapp.com',
                  :port => '1234'} }

  it 'should install package nxlog with chocolatey' do
    should contain_package('nxlog').with({
      'ensure'   => 'present',
      'provider' => 'chocolatey'
    })
  end

  it 'should deploy the config file' do
    should contain_file('nxlog.conf').with({
      'ensure' => 'present',
      'path'   => 'C:\\Program Files (x86)\\nxlog\\conf\\nxlog.conf',
    }).that_requires('Package[nxlog]');
  end

  it 'should ensure running state of the service' do
    should contain_service('nxlog').with({
      'ensure' => 'running',
      'enable' => true
    }).that_requires('Package[nxlog]');
  end
end
