require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'simplecov'
require 'coveralls'

at_exit { RSpec::Puppet::Coverage.report! }
Coveralls.wear!
