# -*- encoding: utf-8 -*-
require 'oj'

module MetofficeDatapoint
  module Api
    # Public: Wrapper class around the Met Office DataPoint API endpoints
    module StandaloneMapsMethods
      # Public: Returns when the current surface pressure charts were issued, the time steps available, and the URIs of
      # the surface pressure synoptic analysis and forecast charts in GIF format. API is updated twice daily.
      #
      # Returns a Hash.
      def surface_pressure_map
        query('image/wxfcs/surfacepressure/json/capabilities')
      end

      private

      def query(path)
        Oj.load(get(path))
      end
    end
  end
end
