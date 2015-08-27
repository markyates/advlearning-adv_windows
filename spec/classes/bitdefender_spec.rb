require 'spec_helper'

describe 'adv_windows::bitdefender', :type => 'class' do
  let(:params) { { :workFolder => 'D:\\Software' } }

  it { should contain_file('BitdefenderInstaller').with({
      'ensure' => 'present'
    })
  }

  it { should contain_exec('BitdefenderInstall') }

end
