require 'spec_helper'

describe 'adv_windows::cloudhealth', :type => 'class' do
  let(:params) { { :workFolder => 'D:\\Software' }}

  it { should contain_file('CloudHealthInstaller') }
  it { should contain_exec('CloudHealthInstall') }

end
