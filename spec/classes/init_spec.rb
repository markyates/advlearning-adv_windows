require 'spec_helper'

describe 'adv_windows' do
  let(:params) { {:workFolder => 'D:\\Software',
                  :defaultRegion => 'eu-west-1',
                  :awsAccessKeyId => 'accesskeyid',
                  :awsSecretAccessKey => 'accesskey',
                  :csenv => 'test',
                  :nrlicense => 'testnrlicense',
                  :pthost => 'logs.example.com',
                  :ptport => '1234'} }

end
