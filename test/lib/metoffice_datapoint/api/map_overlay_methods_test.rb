# -*- encoding: utf-8 -*-
require_relative '../../../test_helper'

describe MetofficeDatapoint::Api::MapOverlayMethods do
  before do
    @client = MetofficeDatapoint.new(api_key: API_KEY)
  end

  describe "map overlays" do
    it "should be able to view the forecast layers" do
      stub_request(:get, metoffice_datapoint_url('layer/wxfcs/all/json/capabilities', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.forecast_layer
      result.must_be_instance_of Hash
    end

    it "should be able to view the observation layers" do
      stub_request(:get, metoffice_datapoint_url('layer/wxobs/all/json/capabilities', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.observation_layer
      result.must_be_instance_of Hash
    end
  end
end
