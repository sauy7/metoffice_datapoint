# -*- encoding: utf-8 -*-
require 'oj'

module MetofficeDatapoint
  module Api
    # Public: Wrapper class around the Met Office DataPoint API endpoints
    module LocationMethods
      # Public: Returns a list of around 5000 locations (also known as sites) for which daily and three-hourly forecast
      # data feeds are available.
      # You can use this to find the ID of the site that you are interested in.
      #
      # Returns a Hash
      def forecasts_sitelist
        query("val/wxfcs/all/json/sitelist")
      end

      # Public: Returns the time steps available for the daily or three-hourly UK forecast data feed.
      # You can use this data feed to check that the time step you are interested in is available before querying
      # the relevant web service to get the data.
      #
      # options - A Hash specifying the temporal resolution of the data being requested (either '3hourly' or 'daily'
      # by default).
      #
      # Examples:
      #   client = MetofficeDatapoint.new(api_key: 'your_api_key')
      #   client.forecasts_capabilities(res: 'daily')
      #   client.forecasts_capabilities(res: '3hourly')
      #
      # Returns a Hash.
      def forecasts_capabilities(options = { res: 'daily' })
        query("val/wxfcs/all/json/capabilities", options)
      end

      # Public: Returns a forecast for the next five days including today. Forecast time steps are either daily
      # (separate day and night), or every three-hours. As single time step can be requested by specifying the time.
      # Data is updated hourly by the Met Office.
      #
      # location_id - An Integer corresponding to a location or the String 'all'
      # options - A Hash specifying the temporal resolution of the data being requested (either '3hourly' or 'daily'
      # by default).
      # The Hash may also include an optional :time key. The time step must be one of the available time steps
      # reported by the forecasts_capabilities resource and expressed according to the ISO 8601
      # combined date and time convention. The time can be abbreviated e.g 2012-11-19T15:00:00Z is identical
      # to 2012-11-19T15Z.
      #
      # Returns a Hash.
      def forecasts(location_id = 'all', options = { res: 'daily' })
        query("val/wxfcs/all/json/#{location_id}", options)
      end

      # Public: Returns a list of around 140 locations (also known as sites) for which an hourly observations data feed
      # is available.
      # You can use this to find the ID of the site that you are interested in.
      #
      # Returns a Hash.
      def observations_sitelist
        query("val/wxobs/all/json/sitelist")
      end

      # Public: Returns a summary of available time steps for the UK observations data feed.
      # You can use this data feed to check that the time step you are interested in is available before querying
      # the relevant web service to get the data. Data is updated hourly by the Met Office.
      #
      # options - a Hash, currently only accepts a key of :time with a String value matching an ISO 8601 date within
      # the past 24 hours.
      #
      # Examples:
      #   client = MetofficeDatapoint.new(api_key: 'your_api_key')
      #   client.forecasts_capabilities(time: '2013-12-06Z')
      #
      # Returns a Hash.
      def observations_capabilities(options={})
        query("val/wxobs/all/json/capabilities", options.merge(res: 'hourly'))
      end

      # Public: Returns hourly weather observations for the last 24 hours. Data is updated hourly by the Met Office.
      #
      # location_id - An Integer corresponding to a location or the String 'all'
      # options - A Hash, currently only accepts a key of :time with a String value matching an ISO 8601 date within
      # the past 24 hours.
      #
      # Returns a Hash.
      def observations(location_id = 'all', options={})
        query("val/wxobs/all/json/#{location_id}", options.merge(res: 'hourly'))
      end

      private

      def query(path, options={})
        Oj.load(get(path, options))
      end
    end
  end
end