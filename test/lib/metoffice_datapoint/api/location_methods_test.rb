# -*- encoding: utf-8 -*-
require_relative '../../../test_helper'

describe MetofficeDatapoint::Api::LocationMethods do
  before do
    @client = MetofficeDatapoint.new(api_key: API_KEY)
  end

  describe 'forecasts' do
    it "should be able to view the site list" do
      stub_request(:get, metoffice_datapoint_url('val/wxfcs/all/json/sitelist', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.forecasts_sitelist
      result.must_be_instance_of Hash
    end

    it "should be able to view the 3hourly capabilities" do
      stub_request(:get, metoffice_datapoint_url('val/wxfcs/all/json/capabilities', @client.api_key, res: '3hourly')).
          to_return(status: 200, body: '{}')

      result = @client.forecasts_capabilities(res: '3hourly')
      result.must_be_instance_of Hash
    end

    it "should be able to view the daily capabilities" do
      stub_request(:get, metoffice_datapoint_url('val/wxfcs/all/json/capabilities', @client.api_key, res: 'daily')).
          to_return(status: 200, body: '{}')

      result = @client.forecasts_capabilities(res: 'daily')
      result.must_be_instance_of Hash
    end

    it "should default to viewing the daily capabilities" do
      stub_request(:get, metoffice_datapoint_url('val/wxfcs/all/json/capabilities', @client.api_key, res: 'daily')).
          to_return(status: 200, body: '{}').times(1)

      @client.forecasts_capabilities
    end

    it "should be able to view the 3hourly forecasts for all locations" do
      stub_request(:get, metoffice_datapoint_url('val/wxfcs/all/json/all', @client.api_key, res: '3hourly')).
          to_return(status: 200, body: '{}')

      result = @client.forecasts('all', res: '3hourly')
      result.must_be_instance_of Hash
    end

    it "should be able to view the daily forecasts for all locations" do
      stub_request(:get, metoffice_datapoint_url('val/wxfcs/all/json/all', @client.api_key, res: 'daily')).
          to_return(status: 200, body: '{}')

      result = @client.forecasts('all', res: 'daily')
      result.must_be_instance_of Hash
    end

    it "should default to viewing the daily forecasts for all locations" do
      stub_request(:get, metoffice_datapoint_url('val/wxfcs/all/json/all', @client.api_key, res: 'daily')).
          to_return(status: 200, body: '{}').times(1)

      result = @client.forecasts
      result.must_be_instance_of Hash
    end

    it "should be able to view the 3hourly forecasts for a single location" do
      stub_request(:get, metoffice_datapoint_url('val/wxfcs/all/json/1234', @client.api_key, res: '3hourly')).
          to_return(status: 200, body: '{}')

      result = @client.forecasts(1234, res: '3hourly')
      result.must_be_instance_of Hash
    end

    it "should be able to view the daily forecasts for a single location" do
      stub_request(:get, metoffice_datapoint_url('val/wxfcs/all/json/1234', @client.api_key, res: 'daily')).
          to_return(status: 200, body: '{}')

      result = @client.forecasts(1234, res: 'daily')
      result.must_be_instance_of Hash
    end

    it "should be default to viewing the daily forecasts for a single location" do
      stub_request(:get, metoffice_datapoint_url('val/wxfcs/all/json/1234', @client.api_key, res: 'daily')).
          to_return(status: 200, body: '{}').times(1)

      result = @client.forecasts(1234)
      result.must_be_instance_of Hash
    end
  end

  describe 'observations' do
    it "should be able to view the site list" do
      stub_request(:get, metoffice_datapoint_url('val/wxobs/all/json/sitelist', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.observations_sitelist
      result.must_be_instance_of Hash
    end

    it "should be able to view hourly capabilities" do
      stub_request(:get, metoffice_datapoint_url('val/wxobs/all/json/capabilities', @client.api_key, res: 'hourly')).
          to_return(status: 200, body: '{}')

      result = @client.observations_capabilities
      result.must_be_instance_of Hash
    end

    it "should be able to view all hourly observations for all locations" do
      stub_request(:get, metoffice_datapoint_url('val/wxobs/all/json/all', @client.api_key, res: 'hourly')).
          to_return(status: 200, body: '{}')

      result = @client.observations('all', res: 'hourly')
      result.must_be_instance_of Hash
    end

    it "should be able to view a single hourly observation for all locations" do
      stub_request(:get, metoffice_datapoint_url('val/wxobs/all/json/all', @client.api_key, res:'hourly', time: '2013-12-06T15:00:00Z')).
          to_return(status: 200, body: '{}')

      result = @client.observations('all', res: 'hourly', time: '2013-12-06T15:00:00Z')
      result.must_be_instance_of Hash
    end

    it "should default to viewing all hourly observations for all locations" do
      stub_request(:get, metoffice_datapoint_url('val/wxobs/all/json/all', @client.api_key, res: 'hourly')).
          to_return(status: 200, body: '{}')

      result = @client.observations
      result.must_be_instance_of Hash
    end

    it "should be able to view all hourly observations for a single location" do
      stub_request(:get, metoffice_datapoint_url('val/wxobs/all/json/1234', @client.api_key, res: 'hourly')).
          to_return(status: 200, body: '{}')

      result = @client.observations(1234, res: 'hourly')
      result.must_be_instance_of Hash
    end

    it "should be able to view a single hourly observation for a single location" do
      stub_request(:get, metoffice_datapoint_url('val/wxobs/all/json/1234', @client.api_key, res:'hourly', time: '2013-12-06T15:00:00Z')).
          to_return(status: 200, body: '{}')

      result = @client.observations(1234, res: 'hourly', time: '2013-12-06T15:00:00Z')
      result.must_be_instance_of Hash
    end

    it "should default to viewing all hourly observations for a single location" do
      stub_request(:get, metoffice_datapoint_url('val/wxobs/all/json/1234', @client.api_key, res:'hourly')).
          to_return(status: 200, body: '{}')

      result = @client.observations(1234)
      result.must_be_instance_of Hash
    end
  end
end