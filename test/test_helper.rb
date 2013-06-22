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
if File.exists?(File.join(File.dirname(__FILE__), 'api_key.rb'))
  require 'api_key'
else
  puts "Running without api_key.rb. Make sure ENV['MODP_API_KEY'] is set."
end

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

module MiniTest::Assertions
  def assert_array(cls, obj)
    assert_instance_of Array, obj
  end

  def assert_date(cls, obj)
    assert_instance_of Date, obj
  end

  def assert_datetime(cls, obj)
    assert_instance_of DateTime, obj
  end

  def assert_mash(cls, obj)
    assert_instance_of MetofficeDatapoint::Mash, obj
  end

  def assert_mash_attributes(attrs, obj)
    attrs.each do |attr|
      refute_nil obj[attr.to_sym]
      assert_respond_to obj, attr.to_sym
    end
  end
end

Object.infect_an_assertion :assert_array, :must_be_array
Object.infect_an_assertion :assert_date, :must_be_date
Object.infect_an_assertion :assert_datetime, :must_be_datetime
Object.infect_an_assertion :assert_mash, :must_be_mash
Object.infect_an_assertion :assert_mash_attributes, :must_be_mash_attributes

