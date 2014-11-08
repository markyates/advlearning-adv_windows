require 'spec_helper'

describe 'adv_windows::awscli', :type => 'class' do
  let(:params) { { :workFolder => 'D:\\Software',
                   :defaultRegion => 'eu-west-1',
                   :awsAccessKeyId => 'testaccesskeyid',
                   :awsSecretAccessKey => 'testsecretaccesskey' } }

  let(:facts) { { :osfamily => 'windows' } }

  it 'should copy file to work folder' do
    should contain_file('AWSCLI').with({
      'ensure' => 'present',
      'path'   => 'D:\\Software\\AWSCLI64.msi',
      'source' => 'puppet:///modules/adv_windows/AWSCLI64.msi'
    }).that_notifies('Exec[AWSCLIInstall]')
  end

  it 'should execute the installer' do
    should contain_exec('AWSCLIInstall').with({
      'command'     => 'C:\\Windows\\system32\\msiexec.exe /i D:\\Software\\AWSCLI64.msi /qn INSTALLLEVEL=1',
      'refreshonly' => true
    })
  end

  it 'should set windows environment variables' do
    should contain_registry_value('HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\AWS_DEFAULT_REGION').with({
      'ensure'    => 'present',
      'type'      => 'string',
      'data'     => 'eu-west-1'
    })
    should contain_registry_value('HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\AWS_ACCESS_KEY_ID').with({
      'ensure' => 'present',
      'type'   => 'string',
      'data'  => 'testaccesskeyid'
    })
    should contain_registry_value('HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\AWS_SECRET_ACCESS_KEY').with({
      'ensure' => 'present',
      'type'   => 'string',
      'data'  => 'testsecretaccesskey'
    })
  end
end
