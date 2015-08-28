source 'https://rubygems.org'

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 3.7.2']
end

gem 'rake'
gem 'rspec', '~> 3.1.0'
gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git'
gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper'
gem 'puppet-lint'
gem 'puppet-syntax'
gem 'metadata-json-lint'
gem 'coveralls'
