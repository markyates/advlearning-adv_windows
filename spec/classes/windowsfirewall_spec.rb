require 'spec_helper'

describe 'adv_windows::windowsfirewall', :type => 'class' do

  it { should contain_exec('Configure Domain Firewall') }

end
