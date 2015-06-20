require 'spec_helper'

describe 'adv_windows', :type => 'class' do
  let(:params) { { :workFolder         => 'D:\\Software',
                   :defaultRegion      => 'eu-west-1',
                   :awsAccessKeyId     => 'accesskeyid',
                   :awsSecretAccessKey => 'accesskey',
                   :csenv              => 'test',
                   :nrlicense          => 'testnrlicense',
                   :pthost             => 'logs.example.com',
                   :ptport             => '1234' } }

  let(:facts) { { :operatingsystem => 'windows',
                  :osfamily => 'windows',
                  :kernelmajversion => '6.3' } }

  it { should contain_exec('execPolicy') }
  it { should contain_exec('chocoInst') }
  it { should contain_class('adv_windows::timezone') }
  it { should contain_class('adv_windows::microsoftnet') }
  it { should contain_class('adv_windows::msdtc') }


  should contain_class('adv_windows::awscli')

  it 'should install adobe brackets' do
    should contain_package('Brackets').with({
      'ensure'   => 'present',
      'provider' => 'chocolatey',
    }).that_requires('Class[chocolatey_sw]');
  end

  it 'should install centrastage' do
    should contain_class('adv_windows::centrastage').with({
      'csenv'      => 'test'
    });
  end

  it 'should install new relic server monitor' do
    should contain_class('adv_windows::nrserver').with({
      'nrlicense'  => 'testnrlicense'
    });
  end

  it 'should install papertrail' do
    should contain_class('adv_windows::papertrail').with({
      'host' => 'logs.example.com',
      'port' => '1234',
    }).that_requires('Class[chocolatey_sw]');
  end

end
