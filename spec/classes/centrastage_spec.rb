require 'spec_helper'

describe 'adv_windows::centrastage', :type => 'class' do
  let(:params) { {:workFolder => 'D:\\Software',
                  :csenv => 'Test'} }

  it 'should copy installer file' do
    should contain_file('CSInstaller').with({
      'ensure' => 'present',
      'path'   => 'D:\\Software\\AgentSetup_Test.exe',
      'source' => 'puppet:///modules/adv_windows/centrastage/AgentSetup_Test.exe'
    })
  end

  it 'should run the install' do
    should contain_exec('CSInstall').with({
      'command' => 'D:\\Software\\AgentSetup_Test.exe',
      'creates' => 'C:\\Program Files (x86)\\CentraStage'
    })
  end
end
