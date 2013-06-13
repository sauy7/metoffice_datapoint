# -*- encoding: utf-8 -*-
require 'oj'

module MetofficeDatapoint
  module Api
    # Public: Wrapper class around the Met Office DataPoint API endpoints
    module TextMethods
      # Public: Returns when the regional extremes observations data feed was last updated, and the period it covers.
      #
      # Returns a Hash.
      def ukextremes_observations_capabilities
        query('txt/wxobs/ukextremes/json/capabilities')
      end

      # Public: Returns the regional observed extremes of weather across the UK for the day of issue. API is
      # updated daily.
      #
      # Returns a Hash.
      def ukextremes_latest_observations
        query('txt/wxobs/ukextremes/json/latest')
      end

      # Public: Returns a list of locations the National Park forecast data feed provides data for. You can use this to
      # find the ID of the site that you are interested in.
      #
      # Returns a Hash.
      def nationalparks_sitelist
        query('txt/wxfcs/nationalpark/json/sitelist')
      end

      # Public: Returns when the data for each of the National Park forecasts was updated. You can use this to check
      # when the forecasts have updated rather than fetching the National Park forecasts repeatedly.
      #
      # Returns a Hash.
      def nationalparks_capabilities
        query('txt/wxfcs/nationalpark/json/capabilities')
      end

      # Public: Returns a text forecast for a National Park. API is updated twice daily, early morning and early
      # afternoon.
      #
      # Returns a Hash.
      def nationalparks_forecasts(location_id='all')
        query("txt/wxfcs/nationalpark/json/#{location_id}")
      end

      # Public: Returns a list of locations the regional forecast data feed provides data for. You can use this to find
      # the ID of the site that you are interested in.
      #
      # Returns a Hash.
      def regional_sitelist
        query('txt/wxfcs/regionalforecast/json/sitelist')
      end

      # Public: Returns when the regional forecast was updated. You can use this to check when the forecasts have
      # updated rather than fetching the regional forecasts repeatedly.
      #
      # Returns a Hash.
      def regional_capabilities
        query('txt/wxfcs/regionalforecast/json/capabilities')
      end

      # Public: Returns regional forecast text. API is updated twice daily, AM and PM, normally early morning and early
      # afternoon.
      #
      # location_id - An Integer corresponding to a region.
      #
      # Returns a Hash.
      def regional_forecast(location_id)
        query("txt/wxfcs/regionalforecast/json/#{location_id}")
      end

      # Public: Returns a list of locations the mountain area forecast data feed provides data for. You can use this to
      # find the ID of the site that you are interested in.
      #
      # Returns a Hash.
      def mountain_area_sitelist
        query('txt/wxfcs/mountainarea/json/sitelist')
      end

      # Public: Returns the forecast creation dates, valid from and to dates, and the general risk for each mountain
      # area.
      #
      # Returns a Hash.
      def mountain_area_capabilities
        query('txt/wxfcs/mountainarea/json/capabilities')
      end

      # Public: Returns a mountain area forecast covering the four day period after its issue date. API is updated at
      # least once a day but may be updated more often.
      #
      # location_id - An Integer corresponding to a mountain area.
      #
      # Returns a Hash.
      def mountain_area_forecast(location_id)
        query("txt/wxfcs/mountainarea/json/#{location_id}")
      end

      private

      def query(path, options={})
        Oj.load(get(path, options))
      end
    end
  end
end
