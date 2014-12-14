require 'spec_helper'

describe 'adv_windows::bitdefender', :type => 'class' do
  let(:params) { {:workFolder => 'D:\\Software'} }

  it do
    should contain_file('BitdefenderInstaller').with({
      'ensure' => 'present',
      'path'   => 'D:\\Software\\bitdefender_thindownloader.exe',
      'source' => 'puppet:///modules/adv_windows/bitdefender_thindownloader.exe'
    }).that_notifies('Exec[BitdefenderInstall]')
  end

  it do
    should contain_exec('BitdefenderInstall').with({
      'command'     => 'D:\\Software\\bitdefender_thindownloader.exe /quiet',
      'refreshonly' => true
    })
  end
end
