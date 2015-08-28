require 'spec_helper'

describe 'adv_windows', :type => 'class' do
  let(:params) { { :workFolder         => 'D:\\Software',
                   :defaultRegion      => 'eu-west-1',
                   :awsAccessKeyId     => '12345',
                   :awsSecretAccessKey => 'abcde',
                   :csenv              => 'test',
                   :nrlicense          => 'testnrlicense',
                   :iscloud            => true } }

  let(:facts) { { :operatingsystem => 'windows',
                  :osfamily => 'windows',
                  :kernelmajversion => '6.3' } }

  it { should contain_file('D:\\Software') }


  it { should contain_class('chocoinst') }

  it { should contain_file('puppet.conf').with({
      'ensure'  => 'present',
      'path'    => 'C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf'
    })
  }

  it { should contain_class('adv_windows::timezone') }
  it { should contain_class('adv_windows::windowsfirewall') }

  it { should contain_class('adv_windows::msdtc') }

  it  'should install aws command line' do
    should contain_class('awscli')
  end

  it 'should install adobe brackets' do
    should contain_package('Brackets').with({
      'ensure'   => 'latest',
      'provider' => 'chocolatey',
    });
  end

  it 'should install centrastage' do
    should contain_class('adv_windows::centrastage').with({
      'csenv' => 'test'
    });
  end

  it 'should install new relic server monitor' do
    should contain_class('adv_windows::nrserver').with({
      'nrlicense'  => 'testnrlicense'
    });
  end

  it { should contain_class('adv_windows::bitdefender') }

  it { should contain_class('adv_windows::cloudhealth').with({
    'workfolder' => 'D:\\Software'
  })}

end
