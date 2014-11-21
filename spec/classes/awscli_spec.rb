require 'spec_helper'

describe 'adv_windows::awscli', :type => 'class' do
  let(:params) { { :defaultRegion => 'eu-west-1',
                   :awsAccessKeyId => 'testaccesskeyid',
                   :awsSecretAccessKey => 'testsecretaccesskey' } }

  let(:facts) { { :osfamily => 'windows' } }

  it 'should install the awscli chocolatey package' do
    should contain_package('awscli').with({
      'ensure'   => 'present',
      'provider' => 'chocolatey'
    })
  end

  it 'should set windows environment variables' do
    should contain_registry_value('HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\AWS_DEFAULT_REGION').with({
      'ensure' => 'present',
      'type'   => 'string',
      'data'   => 'eu-west-1'
    })
    should contain_registry_value('HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\AWS_ACCESS_KEY_ID').with({
      'ensure' => 'present',
      'type'   => 'string',
      'data'   => 'testaccesskeyid'
    })
    should contain_registry_value('HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\AWS_SECRET_ACCESS_KEY').with({
      'ensure' => 'present',
      'type'   => 'string',
      'data'   => 'testsecretaccesskey'
    })
  end
end
