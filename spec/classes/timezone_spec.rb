require 'spec_helper'

describe 'adv_windows::timezone', :type => 'class' do
  context "Should exec the timezone cmd template"do
    it {
      should contain_exec('Configure timezone').with({
        'provider' => 'powershell'
      })
    }
  end
end
