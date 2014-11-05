require 'spec_helper'

describe 'adv_windows', :type => 'class' do
  let(:params) { {:workFolder         => 'D:\\Software',
                  :defaultRegion      => 'eu-west-1',
                  :awsAccessKeyId     => 'testawsaccesskeyid',
                  :awsSecretAccessKey => 'testawssecretaccesskey',
                  :csenv              => 'Test',
                  :nrlicense          => 'testnrlicense'} }

  it 'should create the work folder' do
    should contain_file('D:\\Software').with('ensure' => 'directory')
  end

  # how to test includes? should check that timezone included

  it 'should disable ipv6' do
    should contain_class('windows_disable_ipv6').with({
      'ipv6_disable' => true,
      'ipv6_reboot'  => false
    })
  end


end
