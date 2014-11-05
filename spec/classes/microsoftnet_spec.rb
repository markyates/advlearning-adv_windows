require 'spec_helper'

describe 'adv_windows::microsoftnet' do

  it 'should install .NET 3.5' do
    should contain_dism('NetFx3ServerFeatures').with({
      'ensure' => 'present'
      }).that_comes_before('Dism[NetFx3]')
    should contain_dism('NetFx3').with({'ensure' => 'present'})
  end

  it 'should install .NET 4' do
    should contain_dism('NetFx4ServerFeatures').with({
      'ensure' => 'present'
      }).that_comes_before('Dism[NetFx4]')
    should contain_dism('NetFx4').with({
      'ensure' => 'present'
      }).that_comes_before('Dism[NetFx4Extended-ASPNET45]')
    should contain_dism('NetFx4Extended-ASPNET45').with({'ensure' => 'present'})
  end
end
