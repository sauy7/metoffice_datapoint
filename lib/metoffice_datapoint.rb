# -*- encoding: utf-8 -*-
require 'metoffice_datapoint/version'
require 'metoffice_datapoint/api'
require 'metoffice_datapoint/client'
require 'metoffice_datapoint/configuration'
require 'metoffice_datapoint/errors'
require 'metoffice_datapoint/mash'
require 'metoffice_datapoint/request'

# Public: Provides a simple wrapper to the UK's Met Office DataPoint API.
#  To use this gem, you'll need to register and obtain your own API Key.
#  See http://www.metoffice.gov.uk/datapoint/support/getting-started
module MetofficeDatapoint
  extend Configuration

  class << self
    # Public: Alias for MetofficeDatapoint::Client.new
    #
    # Examples
    #
    #   MetofficeDatapoint.new(api_key: 'your_api_key')
    #
    # Returns MetofficeDatapoint::Client.
    def new(options={})
      MetofficeDatapoint::Client.new(options)
    end
  end
end
