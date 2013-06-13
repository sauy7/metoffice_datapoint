# -*- encoding: utf-8 -*-
require 'oj'

module MetofficeDatapoint
  module Api
    # Public: Wrapper class around the Met Office DataPoint API endpoints
    module MapOverlayMethods
      # Public: Returns when the forecast layers were issued, time steps available, and the URIs of the layers in PNG
      # format. API updates hourly.
      #
      # Returns a Hash.
      def forecast_layer
        query('layer/wxfcs/all/json/capabilities')
      end

      # Public: Returns when the observation layers were issued, time steps available, and the URIs of the layers in
      # PNG format. API updates every 15 minutes.
      #
      # Returns a Hash.
      def observation_layer
        query('layer/wxobs/all/json/capabilities')
      end

      private

      def query(path)
        Oj.load(get(path))

      end
    end
  end
end
