# -*- encoding: utf-8 -*-
require_relative '../../../test_helper'

describe MetofficeDatapoint::Api::LocationMethods do
  before do
    @client = MetofficeDatapoint.new(api_key: API_KEY)
  end

  describe "standalone maps" do
    it "should be able to view the surface pressure standalone map" do
      stub_request(:get, metoffice_datapoint_url('image/wxfcs/surfacepressure/json/capabilities', @client.api_key)).
          to_return(status: 200, body: '{}')

      result = @client.surface_pressure_map
      result.must_be_instance_of Hash
    end
  end
end
