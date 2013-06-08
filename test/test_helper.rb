# -*- encoding: utf-8 -*-
$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end
require 'minitest/autorun'
require 'minitest/focus'
require 'webmock/minitest'
require 'addressable/uri'
require 'metoffice_datapoint'
require 'api_key'

if ENV['RM_INFO']
  require 'minitest/reporters'
  Minitest::Reporters.use!
else
  require 'minitest/wscolor'
end

def options_hash_to_query_string(options={})
  return "" if options.empty?
  uri = Addressable::URI.new
  uri.query_values = options
  "&#{uri.query}"
end

def metoffice_datapoint_url(resource, api_key, options={})
  "http://datapoint.metoffice.gov.uk/public/data/#{resource}?key=#{api_key}#{options_hash_to_query_string(options)}"
end

def load_json_fixture(filename)
  filename = File.join('test', 'fixtures', "json", "#{filename}.json")
  IO.read(filename)
end

