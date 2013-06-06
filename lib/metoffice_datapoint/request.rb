# -*- encoding: utf-8 -*-
require 'rest_client'
require 'addressable/uri'

module MetofficeDatapoint
  module Request
    def get(path, options={})
      uri = "#{api_endpoint}#{path}?key=#{api_key}#{options_hash_to_query_string(options)}"
      RestClient.get(uri, { accept: 'application/json', user_agent: user_agent }) { |response, request, result, &block|
        case response.code
          when 200
            # 2013-06-06: Encoding is not currently UTF-8 and this can screw up multi_json's encoding
            # See https://groups.google.com/forum/#!topic/metoffice-datapoint/NypPsIAZXkg
            response.body.force_encoding('ISO-8859-1').encode('UTF-8')
          when 400
            raise MetofficeDatapoint::Errors::GeneralError, "Met Office DataPoint API: Bad request (#{response.code})"
          when 403
            raise MetofficeDatapoint::Errors::ForbiddenError, "Met Office DataPoint API: Access denied (#{response.code})"
          when 404
            raise MetofficeDatapoint::Errors::NotFoundError, "Met Office DataPoint API: Not found (#{response.code})"
          when 500
            raise MetofficeDatapoint::Errors::SystemError, "Met Office DataPoint API: Internal error. (#{response.code})"
          when 502..503
            raise MetofficeDatapoint::Errors::UnavailableError, "Met Office DataPoint API: Unavailable. (#{response.code})"
        end
      }
    end

    private

    def options_hash_to_query_string(options={})
      return "" if options.empty?
      uri = Addressable::URI.new
      uri.query_values = options
      "&#{uri.query}"
    end
  end
end