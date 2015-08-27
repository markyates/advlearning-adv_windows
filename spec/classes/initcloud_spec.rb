require 'spec_helper'

describe 'adv_windows', :type => 'class' do
  let(:params) { { :workFolder         => 'D:\\Software',
                   :defaultRegion      => 'eu-west-1',
                   :awsAccessKeyId     => 'accesskeyid',
                   :awsSecretAccessKey => 'accesskey',
                   :csenv              => 'test',
                   :nrlicense          => 'testnrlicense',
                   :iscloud            => true } }

  let(:facts) { { :operatingsystem => 'windows',
                  :osfamily => 'windows',
                  :kernelmajversion => '6.3' } }

  it { should contain_class('adv_windows::cloudhealth').with({
      'workfolder' => 'D:\\Software'
    })
  }
  
end
