require 'spec_helper'

describe 'adv_windows::nrserver', :type => 'class' do
  let(:params) { {:workFolder => 'D:\\Software',
                  :nrlicense => 'testlicensekey'} }

  it 'should copy the installer' do
    should contain_file('nrserverinstaller').with({
      'ensure' => 'present',
      'path'   => 'D:\\Software\\NewRelicServerMonitor_x64.msi',
      'source' => 'puppet:///modules/adv_windows/NewRelicServerMonitor_x64.msi'
    }).that_notifies('Exec[InstallServerMonitor]')
  end

  it 'should exec the copied installer' do
    should contain_exec('InstallServerMonitor').with({
      'command'     => 'msiexec.exe /i D:\\Software\\NewRelicServerMonitor_x64.msi /L*v install.log /qn NR_LICENSE_KEY=testlicensekey',
      'path'        => 'C:\\Windows\\system32',
      'refreshonly' => true
    })
  end
end
