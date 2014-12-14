require 'spec_helper'

describe 'adv_windows::msdtc', :type => 'class' do
  it 'should update msdtc settings' do
    should contain_exec('Configure MSDTC')
  end
end

at_exit { RSpec::Puppet::Coverage.report! }
