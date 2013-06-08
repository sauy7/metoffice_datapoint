require_relative '../../test_helper'

describe MetofficeDatapoint::Mash do
  describe ".new" do
    describe "forecast mashes" do
      it "should create a locations mash containing an array of location mashes from a site list" do
        hash = Oj.load(load_json_fixture('f_sitelist_sample'))
        mash = MetofficeDatapoint::Mash.new hash

        mash.locations.location.must_be_instance_of Array

        first_location = mash.locations.location.first
        %w(id latitude longitude name).each do |attr|
          first_location.must_respond_to attr.to_sym
        end
      end

      it "should create a resource mash containing an array of time steps of forecast capabilities" do
        hash = Oj.load(load_json_fixture('f_capabilities_daily'))
        mash = MetofficeDatapoint::Mash.new hash

        resource = mash.resource
        resource.data_date.must_be_instance_of DateTime
        resource.res.must_equal 'daily'
        resource.type.must_equal 'wxfcs'

        time_steps = resource.time_steps.ts
        time_steps.must_be_instance_of Array
        time_steps.first.must_be_instance_of DateTime
      end

      describe "daily forecasts mash for a single location" do
        before do
          hash = Oj.load(load_json_fixture('f_3094_daily'))
          mash = MetofficeDatapoint::Mash.new hash
          @site_rep = mash.site_rep
        end

        it "should create a site_rep mash containing a wx mash with a param array" do
          params = @site_rep.wx.param
          params.must_be_instance_of Array

          first_param = params.first
          %w(name units text).each do |attr|
            first_param.must_respond_to attr.to_sym
          end
        end

        it "should create a site_rep mash containing a dv mash of daily forecast data for a single location" do
          dv = @site_rep.dv
          dv.data_date.must_be_instance_of DateTime

          location = dv.location
          %w(continent country i lat lon name).each do |attr|
            location.must_respond_to attr.to_sym
          end

          periods = location.period
          periods.must_be_instance_of Array

          first_period = periods.first
          first_period.rep.must_be_instance_of Array

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
          params.must_be_instance_of Array

          first_param = params.first
          %w(name units text).each do |attr|
            first_param.must_respond_to attr.to_sym
          end
        end

        it "should create a site_rep mash containing a dv mash of 3hourly forecast data for a single location" do
          dv = @site_rep.dv
          dv.data_date.must_be_instance_of DateTime

          location = dv.location
          %w(continent country i lat lon name).each do |attr|
            location.must_respond_to attr.to_sym
          end

          periods = location.period
          periods.must_be_instance_of Array

          first_period = periods.first
          first_period.rep.must_be_instance_of Array

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
          params.must_be_instance_of Array

          first_param = params.first
          %w(name units text).each do |attr|
            first_param.must_respond_to attr.to_sym
          end
        end

        it "should create a site_rep mash containing a dv mash containing a location array" do
          locations = @site_rep.dv.location
          locations.must_be_instance_of Array

          first_location = locations.first
          %w(continent country i lat lon name).each do |attr|
            first_location.must_respond_to attr.to_sym
          end
        end
      end
    end

    describe "observations mashes" do
      it "should create a locations mash containing an array of location mashes from a site list" do
        hash = Oj.load(load_json_fixture('o_sitelist'))
        mash = MetofficeDatapoint::Mash.new hash

        mash.locations.location.must_be_instance_of Array

        first_location = mash.locations.location.first
        %w(id latitude longitude name).each do |attr|
          first_location.must_respond_to attr.to_sym
        end
      end

      it "should create a resource mash containing an array of time steps of observations capabilities" do
        hash = Oj.load(load_json_fixture('o_capabilities_hourly'))
        mash = MetofficeDatapoint::Mash.new hash

        resource = mash.resource
        resource.res.must_equal 'hourly'
        resource.type.must_equal 'wxobs'

        time_steps = resource.time_steps.ts
        time_steps.must_be_instance_of Array
        time_steps.first.must_be_instance_of DateTime
      end

      describe "hourly observation mash for a single location" do
        before do
          hash = Oj.load(load_json_fixture('o_3002_hourly'))
          mash = MetofficeDatapoint::Mash.new hash
          @site_rep = mash.site_rep
        end

        it "should create a site_rep mash containing a wx mash with a param array" do
          params = @site_rep.wx.param
          params.must_be_instance_of Array

          first_param = params.first
          %w(name units text).each do |attr|
            first_param.must_respond_to attr.to_sym
          end
        end

        it "should create a site_rep mash containing a dv mash of hourly observations data for a single location" do
          dv = @site_rep.dv
          dv.data_date.must_be_instance_of DateTime
          dv.type.must_equal "Obs"

          location = dv.location
          %w(continent country i lat lon name).each do |attr|
            location.must_respond_to attr.to_sym
          end

          periods = location.period
          periods.must_be_instance_of Array

          first_period = periods.first
          first_period.type.must_equal "Day"
          first_period.value.must_be_instance_of Date

          first_period.rep.must_be_instance_of Array

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
          params.must_be_instance_of Array

          first_param = params.first
          %w(name units text).each do |attr|
            first_param.must_respond_to attr.to_sym
          end
        end

        it "should create a site_rep mash containing a dv mash containing a location array" do
          locations = @site_rep.dv.location
          locations.must_be_instance_of Array

          first_location = locations.first
          %w(continent country i lat lon name).each do |attr|
            first_location.must_respond_to attr.to_sym
          end
        end
      end
    end
  end
end