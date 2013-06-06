require_relative '../test_helper'

describe MetofficeDatapoint do
  before do
    MetofficeDatapoint.reset
  end

  describe '.new' do
    it "is a MetofficeDatapoint::Client" do
      MetofficeDatapoint.new.must_be_instance_of MetofficeDatapoint::Client
    end
  end

  describe 'api_key' do
    it "should be able to set the api_key" do
      MetofficeDatapoint.api_key = 'api_key'

      MetofficeDatapoint.api_key.must_equal 'api_key'
    end

    it "can be set from options" do
      client = MetofficeDatapoint.new(api_key: 'your_api_key')

      client.api_key.must_equal 'your_api_key'
    end
  end

  describe 'api_endpoint' do
    it "defaults to http://datapoint.metoffice.gov.uk/public/data/" do
      client = MetofficeDatapoint.new
      client.api_endpoint.must_equal 'http://datapoint.metoffice.gov.uk/public/data/'
    end

    it "should be able to set the api_endpoint" do
      MetofficeDatapoint.api_endpoint = 'http://www.example.org'

      MetofficeDatapoint.api_endpoint.must_equal 'http://www.example.org'
    end

    it "can be set from options" do
      client = MetofficeDatapoint.new(api_endpoint: "http://www.example.org")
      client.api_endpoint.must_equal "http://www.example.org"
    end
  end

  describe 'user_agent' do
    it "defaults to Met Office DataPoint API Ruby Gem MetofficeDatapoint::VERSION" do
      client = MetofficeDatapoint.new
      client.user_agent.must_match /Met Office DataPoint API Ruby Gem \d+\.\d+\.\d+/
    end

    it "should be able to set the api_endpoint" do
      MetofficeDatapoint.user_agent = 'My Application'

      MetofficeDatapoint.user_agent.must_equal 'My Application'
    end

    it "can be set from options" do
      client = MetofficeDatapoint.new(user_agent: 'My Application')
      client.user_agent.must_equal 'My Application'
    end
  end

  describe '.configure' do
    it "should be able to set the api_key, api_endpoint and user_agent via a configure block" do
      MetofficeDatapoint.configure do |config|
        config.api_key = 'your_api_key'
        config.api_endpoint = 'http://www.example.org'
        config.user_agent = 'My Application'
      end
      MetofficeDatapoint.api_key.must_equal 'your_api_key'
      MetofficeDatapoint.api_endpoint.must_equal 'http://www.example.org'
      MetofficeDatapoint.user_agent.must_equal 'My Application'
    end

    it "should be able to set only the api_key via a configure block" do
      MetofficeDatapoint.configure do |config|
        config.api_key = 'your_api_key'
      end
      MetofficeDatapoint.api_key.must_equal 'your_api_key'
      MetofficeDatapoint.api_endpoint.must_equal 'http://datapoint.metoffice.gov.uk/public/data/'
      MetofficeDatapoint.user_agent.must_match /Met Office DataPoint API Ruby Gem \d+\.\d+\.\d+/
    end
  end
end