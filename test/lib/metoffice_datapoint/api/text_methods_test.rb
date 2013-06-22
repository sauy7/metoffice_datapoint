# -*- encoding: utf-8 -*-
require_relative '../../../test_helper'

describe MetofficeDatapoint::Api::TextMethods do
  before do
    @client = MetofficeDatapoint.new(api_key: ENV['MODP_API_KEY'])
  end

  describe "uk extreme observations" do
    it "should be able to view the capabilities" do
      stub_request(:get, metoffice_datapoint_url('txt/wxobs/ukextremes/json/capabilities', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.ukextremes_observations_capabilities
      result.must_be_instance_of Hash
    end

    it "should be able to view the latest observations" do
      stub_request(:get, metoffice_datapoint_url('txt/wxobs/ukextremes/json/latest', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.ukextremes_latest_observations
      result.must_be_instance_of Hash
    end
  end

  describe "national parks" do
    it "should be able to view the site list" do
      stub_request(:get, metoffice_datapoint_url('txt/wxfcs/nationalpark/json/sitelist', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.nationalparks_sitelist
      result.must_be_instance_of Hash
    end

    it "should be able to view the capabilities" do
      stub_request(:get, metoffice_datapoint_url('txt/wxfcs/nationalpark/json/capabilities', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.nationalparks_capabilities
      result.must_be_instance_of Hash
    end

    it "should be able to view the forecasts for all parks" do
      stub_request(:get, metoffice_datapoint_url('txt/wxfcs/nationalpark/json/all', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.nationalparks_forecasts('all')
      result.must_be_instance_of Hash
    end

    it "should default to view the forecasts for all parks" do
      stub_request(:get, metoffice_datapoint_url('txt/wxfcs/nationalpark/json/all', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.nationalparks_forecasts
      result.must_be_instance_of Hash
    end

    it "should be able to view the forecasts for a single park" do
      stub_request(:get, metoffice_datapoint_url('txt/wxfcs/nationalpark/json/600', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.nationalparks_forecasts(600)
      result.must_be_instance_of Hash
    end
  end

  describe "regional forecast" do
    it "should be able to view the site list" do
      stub_request(:get, metoffice_datapoint_url('txt/wxfcs/regionalforecast/json/sitelist', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.regional_sitelist
      result.must_be_instance_of Hash
    end

    it "should be able to view the capabilities" do
      stub_request(:get, metoffice_datapoint_url('txt/wxfcs/regionalforecast/json/capabilities', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.regional_capabilities
      result.must_be_instance_of Hash
    end

    it "should be able to view the forecast for a single region" do
      stub_request(:get, metoffice_datapoint_url('txt/wxfcs/regionalforecast/json/500', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.regional_forecast(500)
      result.must_be_instance_of Hash
    end

    it "should raise an ArgumentError for a forecast if the location_id is not sent" do
      proc { @client.regional_forecast }.must_raise ArgumentError
    end
  end

  describe "mountain area" do
    it "should be able to view the site list" do
      stub_request(:get, metoffice_datapoint_url('txt/wxfcs/mountainarea/json/sitelist', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.mountain_area_sitelist
      result.must_be_instance_of Hash
    end

    it "should be able to view the capabilities" do
      stub_request(:get, metoffice_datapoint_url('txt/wxfcs/mountainarea/json/capabilities', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.mountain_area_capabilities
      result.must_be_instance_of Hash
    end

    it "should be able to view the forecasts for a single region" do
      stub_request(:get, metoffice_datapoint_url('txt/wxfcs/mountainarea/json/100', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.mountain_area_forecast(100)
      result.must_be_instance_of Hash
    end

    it "should raise an ArgumentError for a forecast if the location_id is not sent" do
      proc { @client.mountain_area_forecast }.must_raise ArgumentError
    end
  end

end