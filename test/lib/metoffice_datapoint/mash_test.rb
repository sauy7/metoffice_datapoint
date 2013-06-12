require_relative '../../test_helper'

describe MetofficeDatapoint::Mash do
  describe ".new" do
    describe "converting hashes from location methods" do
      describe "forecast mashes" do
        it "should create a locations mash containing an array of location mashes from a site list" do
          hash = Oj.load(load_json_fixture('f_sitelist_sample'))
          mash = MetofficeDatapoint::Mash.new hash

          mash.locations.location.must_be_array

          first_location = mash.locations.location.first

          first_location.must_be_mash_attributes %w(id latitude longitude name)
        end

        it "should create a resource mash containing an array of time steps of forecast capabilities" do
          hash = Oj.load(load_json_fixture('f_capabilities_daily'))
          mash = MetofficeDatapoint::Mash.new hash

          resource = mash.resource
          resource.data_date.must_be_datetime
          resource.res.must_equal 'daily'
          resource.type.must_equal 'wxfcs'

          time_steps = resource.time_steps.ts
          time_steps.must_be_array
          time_steps.first.must_be_datetime
        end

        describe "daily forecasts mash for a single location" do
          before do
            hash = Oj.load(load_json_fixture('f_3094_daily'))
            mash = MetofficeDatapoint::Mash.new hash
            @site_rep = mash.site_rep
          end

          it "should create a site_rep mash containing a wx mash with a param array" do
            params = @site_rep.wx.param
            params.must_be_array

            first_param = params.first
            first_param.must_be_mash_attributes %w(name units text)
          end

          it "should create a site_rep mash containing a dv mash of daily forecast data for a single location" do
            dv = @site_rep.dv
            dv.data_date.must_be_datetime

            location = dv.location
            location.must_be_mash_attributes %w(continent country i lat lon name)

            periods = location.period
            periods.must_be_array

            first_period = periods.first
            first_period.rep.must_be_array

            day_rep = first_period.rep[0]
            day_rep.text.must_equal "Day"
            %w(D Dm FDm Gn Hn PPd S U V W).each do |attr|
              day_rep[attr].wont_be_nil
            end

            night_rep = first_period.rep[1]
            night_rep.text.must_equal "Night"
            %w(D FNm Gm Hm Nm PPn S V W).each do |attr|
              night_rep[attr].wont_be_nil
            end
          end
        end

        describe "3hourly forecasts mashes for a single location" do
          before do
            hash = Oj.load(load_json_fixture('f_3094_3hourly'))
            mash = MetofficeDatapoint::Mash.new hash
            @site_rep = mash.site_rep
          end

          it "should create a site_rep mash containing a wx mash with a param array" do
            params = @site_rep.wx.param
            params.must_be_array

            first_param = params.first
            
            first_param.must_be_mash_attributes %w(name units text)
          end

          it "should create a site_rep mash containing a dv mash of 3hourly forecast data for a single location" do
            dv = @site_rep.dv
            dv.data_date.must_be_datetime

            location = dv.location
            location.must_be_mash_attributes %w(continent country i lat lon name)

            periods = location.period
            periods.must_be_array

            first_period = periods.first
            first_period.rep.must_be_array

            first_rep = first_period.rep[0]
            %w(D F G H Pp S T V W U text).each do |attr|
              first_rep[attr].wont_be_nil
            end
          end
        end

        describe "forecast mashes for all locations" do
          before do
            hash = Oj.load(load_json_fixture('f_all_daily_sample'))
            mash = MetofficeDatapoint::Mash.new hash
            @site_rep = mash.site_rep
          end

          it "should create a site_rep mash containing a wx mash with a param array" do
            params = @site_rep.wx.param
            params.must_be_array

            params.first.must_be_mash_attributes %w(name units text)
          end

          it "should create a site_rep mash containing a dv mash containing a location array" do
            locations = @site_rep.dv.location
            locations.must_be_array

            locations.first.must_be_mash_attributes %w(continent country i lat lon name)
          end
        end
      end

      describe "observations mashes" do
        it "should create a locations mash containing an array of location mashes from a site list" do
          hash = Oj.load(load_json_fixture('o_sitelist'))
          mash = MetofficeDatapoint::Mash.new hash

          mash.locations.location.must_be_array

          mash.locations.location.first.must_be_mash_attributes %w(id latitude longitude name)
        end

        it "should create a resource mash containing an array of time steps of observations capabilities" do
          hash = Oj.load(load_json_fixture('o_capabilities_hourly'))
          mash = MetofficeDatapoint::Mash.new hash

          resource = mash.resource
          resource.res.must_equal 'hourly'
          resource.type.must_equal 'wxobs'

          time_steps = resource.time_steps.ts
          time_steps.must_be_array
          time_steps.first.must_be_datetime
        end

        describe "hourly observation mash for a single location" do
          before do
            hash = Oj.load(load_json_fixture('o_3002_hourly'))
            mash = MetofficeDatapoint::Mash.new hash
            @site_rep = mash.site_rep
          end

          it "should create a site_rep mash containing a wx mash with a param array" do
            params = @site_rep.wx.param
            params.must_be_array

            params.first.must_be_mash_attributes %w(name units text)
          end

          it "should create a site_rep mash containing a dv mash of hourly observations data for a single location" do
            dv = @site_rep.dv
            dv.data_date.must_be_datetime
            dv.type.must_equal "Obs"

            location = dv.location
            location.must_be_mash_attributes %w(continent country i lat lon name)

            periods = location.period
            periods.must_be_array

            first_period = periods.first
            first_period.type.must_equal "Day"
            first_period.value.must_be_date

            first_period.rep.must_be_array

            first_rep = first_period.rep.first
            %w(D P S T V W text).each do |attr|
              first_rep[attr].wont_be_nil
            end
          end
        end

        describe "hourly observation mash for all locations" do
          before do
            hash = Oj.load(load_json_fixture('o_all_hourly_sample'))
            mash = MetofficeDatapoint::Mash.new hash
            @site_rep = mash.site_rep
          end

          it "should create a site_rep mash containing a wx mash with a param array" do
            params = @site_rep.wx.param
            params.must_be_array

            params.first.must_be_mash_attributes %w(name units text)
          end

          it "should create a site_rep mash containing a dv mash containing a location array" do
            locations = @site_rep.dv.location
            locations.must_be_array

            locations.first.must_be_mash_attributes %w(continent country i lat lon name)
          end
        end
      end
    end

    describe "converting hashes from text methods" do
      describe "ukextremes mashes" do
        it "should create a capabilities mash for ukextremes observations" do
          hash = Oj.load(load_json_fixture('o_ukextremes_capabilities'))
          mash = MetofficeDatapoint::Mash.new hash

          mash.uk_extremes.must_be_mash

          uk_extremes = mash.uk_extremes

          uk_extremes.extreme_date.must_be_date
          uk_extremes.issued_at.must_be_datetime
        end

        it "should create a observations mash for ukextremes latest observations" do
          hash = Oj.load(load_json_fixture('o_ukextremes_latest'))
          mash = MetofficeDatapoint::Mash.new hash

          mash.uk_extremes.must_be_mash
          uk_extremes = mash.uk_extremes

          uk_extremes.extreme_date.must_be_date
          uk_extremes.issued_at.must_be_datetime

          uk_extremes.regions.must_be_mash

          regions = uk_extremes.regions.region

          regions.must_be_array

          first_region = regions.first

          first_region.must_be_mash

          first_region.extremes.must_be_mash

          extremes = first_region.extremes.extreme

          extremes.must_be_array

          first_extreme = extremes.first
          first_extreme.must_be_mash

          first_extreme.must_be_mash_attributes %w(loc_id location_name text type uom)
        end
      end

      describe "national parks forecasts mashes" do
        it "should create a locations mash containing an array of location mashes from a site list" do
          hash = Oj.load(load_json_fixture('f_nationalpark_sitelist'))
          mash = MetofficeDatapoint::Mash.new hash

          mash.locations.location.must_be_array

          mash.locations.location.first.must_be_mash_attributes %w(id name)
        end

        it "should create a national parks forecasts mash of capabilities" do
          hash = Oj.load(load_json_fixture('f_nationalpark_capabilities'))
          mash = MetofficeDatapoint::Mash.new hash

          mash.national_park_forecasts.must_be_mash

          national_park_forecasts = mash.national_park_forecasts.national_park_forecast
          national_park_forecasts.must_be_array

          first_forecast = national_park_forecasts.first
          first_forecast.must_be_mash_attributes %w(issue_at region region_name)
          first_forecast.issue_time.must_be_datetime
        end

        it "should create a national parks forecast mash for a single park" do
          hash = Oj.load(load_json_fixture('f_nationalpark_600'))
          mash = MetofficeDatapoint::Mash.new hash

          mash.national_park_forecasts.must_be_mash

          national_park_forecasts = mash.national_park_forecasts.national_park_forecast
          national_park_forecasts.must_be_array

          first_forecast = national_park_forecasts.first
          first_forecast.must_be_mash

          first_forecast.must_be_mash_attributes %w(issue_at issuer region region_name type)

          first_forecast.issue_time.must_be_datetime

          section = first_forecast.section
          section.must_be_mash

          section.must_be_mash_attributes %w(type title para)
        end

        it "should create a national parks forecast mash for all parks" do
          hash = Oj.load(load_json_fixture('f_nationalpark_all'))
          mash = MetofficeDatapoint::Mash.new hash

          mash.national_park_forecasts.must_be_mash

          national_park_forecasts = mash.national_park_forecasts.national_park_forecast
          national_park_forecasts.must_be_array

          first_forecast = national_park_forecasts.first
          first_forecast.must_be_mash_attributes %w(issue_at issuer region region_name type)

          first_forecast.issue_time.must_be_datetime

          section = first_forecast.section
          section.must_be_mash_attributes %w(type title para)
        end
      end

      describe "regional forecasts mashes" do
        it "should create a locations mash containing an array of location mashes from a site list" do
          hash = Oj.load(load_json_fixture('f_regional_sitelist'))
          mash = MetofficeDatapoint::Mash.new hash

          mash.locations.location.must_be_array

          mash.locations.location.first.must_be_mash_attributes %w(id name)
        end

        it "should create a regional forecasts mash of capabilities" do
          hash = Oj.load(load_json_fixture('f_regional_capabilities'))
          mash = MetofficeDatapoint::Mash.new hash

          mash.regional_fcst.must_be_mash
          mash.regional_fcst.issued_at.must_be_datetime
        end

        it "should create a regional forecast mash for a single park" do
          hash = Oj.load(load_json_fixture('f_regional_500'))
          mash = MetofficeDatapoint::Mash.new hash

          regional_fcst = mash.regional_fcst
          regional_fcst.must_be_mash

          regional_fcst.created_on.must_be_datetime
          regional_fcst.issued_at.must_be_datetime
          regional_fcst.must_be_mash_attributes %w(region_id)

          fcst_periods = regional_fcst.fcst_periods
          fcst_periods.must_be_mash

          periods = fcst_periods.period
          periods.must_be_array

          first_period = periods.first
          first_period.must_be_mash

          first_period.id.wont_be_nil

          paragraphs = first_period.paragraph
          paragraphs.must_be_array

          first_paragraph = paragraphs.first
          first_paragraph.must_be_mash_attributes %w(text title)
        end
      end

      describe "mountain areas mashes" do
        it "should create a locations mash containing an array of location mashes from a site list" do
          hash = Oj.load(load_json_fixture('f_mountainarea_sitelist'))
          mash = MetofficeDatapoint::Mash.new hash

          mash.locations.location.must_be_array

          mash.locations.location.first.must_be_mash_attributes %w(id name)
        end

        it "should create a mountain areas mash of capabilities" do
          hash = Oj.load(load_json_fixture('f_mountainarea_capabilities'))
          mash = MetofficeDatapoint::Mash.new hash

          mountain_forecast_list = mash.mountain_forecast_list
          mountain_forecast_list.must_be_mash

          mountain_forecasts = mountain_forecast_list.mountain_forecast
          mountain_forecasts.must_be_array

          first_mountain_forecast = mountain_forecasts.first

          %w(data_date valid_from valid_to created_date).each do |attr|
            first_mountain_forecast[attr.to_sym].must_be_datetime
          end

          first_mountain_forecast.must_be_mash_attributes %w(uri area risk)
        end

        it "should create a mountain area forecast mash for a single mountain area" do
          hash = Oj.load(load_json_fixture('f_mountainarea_100'))
          mash = MetofficeDatapoint::Mash.new hash

          report = mash.report
          report.must_be_mash

          report.must_be_mash_attributes %w(creating_authority issued_date location outlook_day2 outlook_day3 outlook_day4 title overview validity)

          %w(creation_time valid_from valid_to).each do |attr|
            report[attr.to_sym].must_be_datetime
          end

          %w(forecast_day0 forecast_day1).each do |day|
            day = report[day.to_sym]
            day.must_be_mash_attributes %w(freezing_level hill_fog max_wind max_wind_level temp_high_level temp_low_level visibility weather)
          end

          weather_ppn = report.forecast_day0.weather_ppn
          weather_ppn.must_be_mash

          wx_periods = weather_ppn.wx_period
          wx_periods.must_be_array

          first_wx_period = wx_periods.first
          first_wx_period.must_be_mash

          first_wx_period.must_be_mash_attributes %w(period ppn_type probability weather)

          report.hazards.must_be_mash

          hazards = report.hazards.hazard
          hazards.must_be_array

          first_hazard = hazards.first
          first_hazard.must_be_mash

          first_hazard.must_be_mash_attributes %w(comments element no risk)

          issue = report.issue
          issue.must_be_mash

          issue.date.must_be_date
          issue.must_respond_to :time
        end
      end
    end

    describe "converting hashes from standalone maps methods" do
      it "should create a charts list mash for surface pressure maps" do
        hash = Oj.load(load_json_fixture('standalone'))
        mash = MetofficeDatapoint::Mash.new hash

        mash.bw_surface_pressure_chart_list.must_be_mash

        charts = mash.bw_surface_pressure_chart_list.bw_surface_pressure_chart
        charts.must_be_array

        first_chart = charts.first
        first_chart.must_be_mash

        %w(data_date valid_from valid_to).each do |attr|
          first_chart[attr.to_sym].must_be_datetime
        end

        first_chart.must_be_mash_attributes %w(data_date_time forecast_period product_uri)
      end
    end

    describe "converting hashes from map overlay methods" do
      it "should create a forecasts capabilities mash" do
        hash = Oj.load(load_json_fixture('f_layer'))
        mash = MetofficeDatapoint::Mash.new hash

        layers = mash.layers
        layers.must_be_mash

        layers.type.must_equal "Forecast"

        base_url = layers.base_url
        base_url.must_be_mash

        base_url.must_be_mash_attributes %w(for_service_time_format text)

        layers_list = layers.layer
        layers_list.must_be_array

        first_layer = layers_list.first
        first_layer.must_be_mash

        first_layer.must_respond_to :display_name

        service = first_layer.service
        service.must_be_mash_attributes %w(image_format layer_name name)

        timesteps = service.timesteps
        timesteps.must_be_mash

        timesteps.default_time.must_be_datetime

        timesteps_list = timesteps.timestep
        timesteps_list.must_be_array
      end

      it "should create a observations capabilities mash" do
        hash = Oj.load(load_json_fixture('o_layer'))
        mash = MetofficeDatapoint::Mash.new hash

        layers = mash.layers
        layers.must_be_mash

        layers.type.must_equal "Observation"

        base_url = layers.base_url
        base_url.must_be_mash

        base_url.must_be_mash_attributes %w(for_service_time_format text)

        layers_list = layers.layer
        layers_list.must_be_array

        first_layer = layers_list.first
        first_layer.must_be_mash

        first_layer.must_respond_to :display_name

        service = first_layer.service
        service.must_be_mash

        service.must_be_mash_attributes %w(image_format layer_name name)

        times = service.times
        times.must_be_mash

        times_list = times.time
        times_list.must_be_array

        first_time = times_list.first
        first_time.must_be_datetime
      end
    end
  end
end