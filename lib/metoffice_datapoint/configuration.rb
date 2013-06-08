# -*- encoding: utf-8 -*-


module MetofficeDatapoint
  module Configuration
    VALID_OPTIONS_KEYS = [
        :api_key,
        :api_endpoint,
        :user_agent
    ].freeze

    DEFAULT_API_ENDPOINT = 'http://datapoint.metoffice.gov.uk/public/data/'
    DEFAULT_USER_AGENT = "Met Office DataPoint API Ruby Gem #{MetofficeDatapoint::VERSION}".freeze

    attr_accessor(*VALID_OPTIONS_KEYS)

    def self.extended(base)
      base.reset
    end

    # Public: Allows configuration through a block.
    #
    # Yields self.
    #
    # Examples
    #   As a Rails initializer: config/initializers/metoffice_datapoint.rb
    #
    #     MetofficeDatapoint.configure do |config|
    #       config.api_key = 'api_key'
    #     end
    def configure
      yield self
    end

    def options
      VALID_OPTIONS_KEYS.inject({}) { |o,k| o.merge!(k => send(k)) }
    end

    def reset
      self.api_key = nil
      self.api_endpoint = DEFAULT_API_ENDPOINT
      self.user_agent = DEFAULT_USER_AGENT
    end
  end
end