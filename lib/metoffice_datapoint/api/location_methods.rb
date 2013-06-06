# -*- encoding: utf-8 -*-
module MetofficeDatapoint
  module Api
    # Public: Wrapper class around the Met Office DataPoint API endpoints
    module LocationMethods
      # Public: Returns a list of locations (also known as sites) for which 400 results are available for the daily
      #   and three-hourly forecast data feeds.
      #   You can use this to find the ID of the site that you are interested in.
      #
      # Returns a Mash of locations containing id, name, latitude and longitude attributes for each location.
      def forecasts_sitelist
        path = "val/wxfcs/all/json/sitelist"
        result = simple_query(path)
        result.locations.location
      end

      # Public: Returns the time steps available for the daily or three-hourly UK forecast data feed.
      #   You can use this data feed to check that the time step you are interested in is available before querying
      #   the relevant web service to get the data.
      #
      # options - A Hash specifying the temporal resolution of the data being requested (either '3hourly' or 'daily'
      #   by default).
      #
      # Examples:
      #   client = MetofficeDatapoint.new(api_key: 'your_api_key')
      #   client.forecasts_capabilities(res: 'daily')
      #   client.forecasts_capabilities(res: '3hourly')
      #
      # Returns a Mash of forecasts capabilities.
      def forecasts_capabilities(options = { res: 'daily' })
        path = "val/wxfcs/all/json/capabilities"
        result = simple_query(path, options)
        result.resource
      end

      # Public: Returns a forecast for the next five days including today. Forecast time steps are either daily
      #   (separate day and night), or every three-hours. As single time step can be requested by specifying the time.
      #   Data is updated hourly by the Met Office.
      #
      # location_id - An Integer corresponding to a location or the String 'all'
      # options - A Hash specifying the temporal resolution of the data being requested (either '3hourly' or 'daily'
      #   by default).
      #   The Hash may also include an optional :time key. The time step must be one of the available time steps
      #   reported by the forecasts_capabilities resource and expressed according to the ISO 8601
      #   combined date and time convention. The time can be abbreviated e.g 2012-11-19T15:00:00Z is identical
      #   to 2012-11-19T15Z.
      #
      # Returns a Mash of forecast data.
      def forecasts(location_id = 'all', options = { res: 'daily' })
        path = "val/wxfcs/all/json/#{location_id}"
        result = simple_query(path, options)
        result.site_rep
      end

      # Public: Returns a list of locations (also known as sites) for which 9 results are available for the hourly
      #   observations data feed.
      #   You can use this to find the ID of the site that you are interested in.
      #
      # Returns a Mash of locations containing the id, name, latitude and longitude for each location.
      def observations_sitelist
        path = "val/wxobs/all/json/sitelist"
        simple_query(path)
        result = simple_query(path)
        result.locations.location
      end

      # Public: Returns a summary of available time steps for the UK observations data feed.
      #   You can use this data feed to check that the time step you are interested in is available before querying
      #   the relevant web service to get the data. Data is updated hourly by the Met Office.
      #
      # options - A Hash specifying the temporal resolution of the data being requested (either '3hourly' or 'daily'
      #   by default).
      #
      # Examples:
      #   client = MetofficeDatapoint.new(api_key: 'your_api_key')
      #   client.forecasts_capabilities(res: 'daily')
      #   client.forecasts_capabilities(res: '3hourly')
      #
      # Returns a Mash of observation capabilities.
      def observations_capabilities(options = { res: 'daily' })
        path = "val/wxobs/all/json/capabilities"
        result = simple_query(path, options)
        result.resource
      end

      # Public: Returns hourly weather observations for the last 24 hours. Data is updated hourly by the Met Office.
      #
      # location_id - An Integer corresponding to a location or the String 'all'
      # options - A Hash specifying the temporal resolution of the data being requested (either '3hourly' or 'daily'
      #   by default).
      #   The Hash may also include an optional :time key. The time step must be one of the available time steps
      #   reported by the forecasts_capabilities resource and expressed according to the ISO 8601
      #   combined date and time convention. The time can be abbreviated e.g 2012-11-19T15:00:00Z is identical
      #   to 2012-11-19T15Z.
      #
      # Returns a Mash of observations.
      def observations(location_id = 'all', options = { res: 'daily' })
        path = "val/wxobs/all/json/#{location_id}"
        result = simple_query(path, options)
        result.site_rep
      end

      private

      def simple_query(path, options={})
        Mash.from_json(get(path, options))
      end
    end
  end
end