# -*- encoding: utf-8 -*-
require 'metoffice_datapoint/configuration'
require 'metoffice_datapoint/api'
require 'metoffice_datapoint/request'

module MetofficeDatapoint
  class Client
    include Api::LocationMethods
    include MetofficeDatapoint::Request

    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    def initialize(options={})
      options = MetofficeDatapoint.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end
  end
end