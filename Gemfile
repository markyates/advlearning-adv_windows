source 'https://rubygems.org'

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 3.3']
end

gem 'rake'
gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper'
gem 'puppet-lint'
gem 'rspec-puppet'
