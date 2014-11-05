require 'spec_helper'

describe 'adv_windows::papertrail' do
  let(:params) { {:workFolder => 'D:\\Software'} }

  it 'should copy installer and execute' do
    should contain_file('nxlog').with({
      'ensure' => 'present',
      'path'   => 'D:\\Software\\nxlog-ce-2.8.1248.msi',
      'source' => 'puppet:///modules/adv_windows/nxlog-ce-2.8.1248.msi'
    }).that_notifies('Exec[InstallPapertrail]')

    should contain_exec('InstallPapertrail').with({
      'command'     => 'msiexec.exe /i D:\\Software\\nxlog-ce-2.8.1248.msi /qb',
      'path'        => 'C:\\Windows\\system32',
      'refreshonly' => true
    })
  end

  it 'should deploy the config file' do
    should contain_file('nxlog.conf').with({
      'ensure' => 'present',
      'path'   => 'C:\\Program Files (x86)\\nxlog\\conf\\nxlog.conf',
      'source' => 'puppet:///modules/adv_windows/nxlog.conf'
    })
  end

  it 'should ensure running state of the service' do
    should contain_service('nxlog').with({
      'ensure' => 'running',
      'enable' => true
    })
  end
end
