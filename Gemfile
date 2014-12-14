source 'https://rubygems.org'

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 3.7']
end

gem 'rake'
gem 'rspec'
gem 'rspec-puppet', ['>= 1.0.1']
gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper'
gem 'puppet-lint'
gem 'puppet-syntax'
gem 'metadata-json-lint'
gem 'coveralls', require: false
