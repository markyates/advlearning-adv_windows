require 'spec_helper'

describe 'adv_windows::brackets', :type => 'class' do
  let(:params) { {:workFolder => 'D:\\Software'} }

  it 'should copy the installer file' do
    should contain_file('BracketsInstaller').with({
      'ensure' => 'present',
      'path'   => 'D:\\Software\\Brackets.msi',
      'source' => 'puppet:///modules/adv_windows/Brackets.msi'
    }).that_notifies('Exec[BracketsInstall]')
  end

  it 'should execute installer' do
    should contain_exec('BracketsInstall').with({
      'command'     => 'C:\\Windows\\system32\\msiexec.exe /i D:\\Software\\Brackets.msi /qn',
      'refreshonly' => true
    })
  end
end
