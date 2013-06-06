# -*- encoding: utf-8 -*-
require_relative '../../test_helper'

describe MetofficeDatapoint::Client do
  before do
    MetofficeDatapoint.reset
  end

  it "must have an api_key" do
    client = MetofficeDatapoint::Client.new(api_key: 'your_api_key')
    client.api_key.must_equal 'your_api_key'
  end

  it "takes a default api_key from MetofficeDatapoint.api_key" do
    MetofficeDatapoint.api_key = 'your_api_key'

    client = MetofficeDatapoint::Client.new
    client.api_key.must_equal 'your_api_key'
  end

  describe 'error handling' do
    before do
      @client = MetofficeDatapoint::Client.new(api_key: 'your_api_key')
    end

    error_responses = {
        400 => MetofficeDatapoint::Errors::GeneralError,
        403 => MetofficeDatapoint::Errors::ForbiddenError,
        404 => MetofficeDatapoint::Errors::NotFoundError,
        500 => MetofficeDatapoint::Errors::SystemError,
        502 => MetofficeDatapoint::Errors::UnavailableError,
        503 => MetofficeDatapoint::Errors::UnavailableError
    }

    error_responses.each do |code, error|
      it "raises a #{error} when the API returns HTTP status of #{code}" do
        stub_request(:get, metoffice_datapoint_url('path', @client.api_key)).
            to_return(status: code, body: "")

        proc { @client.get('path') }.must_raise error
      end
    end
  end
end