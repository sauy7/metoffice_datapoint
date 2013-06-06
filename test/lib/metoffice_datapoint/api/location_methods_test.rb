# -*- encoding: utf-8 -*-
require_relative '../../../test_helper'

describe MetofficeDatapoint::Api::LocationMethods do
  include MiniTest::Metadata

  before do
    @client = MetofficeDatapoint.new(api_key: API_KEY)

    if metadata[:slow] && !ENV['SLOW']
      skip "skipping slow test"
    end

    if metadata[:very_slow] && !ENV['VERY_SLOW']
      skip "skipping very slow test"
    end
  end

  describe "forecasts" do
    it "should be able to view the sitelist (stubbed)" do
      stub_request(:get, metoffice_datapoint_url('val/wxfcs/all/json/sitelist', @client.api_key)).
          to_return(status: 200, body: load_json_fixture('forecasts_sitelist_sample'))

      result = @client.forecasts_sitelist
      result.must_be_instance_of Array
    end

    it "should load correct location data (stubbed)" do
      stub_request(:get, metoffice_datapoint_url('val/wxfcs/all/json/sitelist', @client.api_key)).
          to_return(status: 200, body: load_json_fixture('forecasts_sitelist_sample'))

      result = @client.forecasts_sitelist.first
      result.must_be_instance_of MetofficeDatapoint::Mash
      [:id, :name, :latitude, :longitude].each do |attr|
        result.respond_to?(attr).must_equal true
        result[attr].wont_be_nil
      end
    end

    it "should load correct location data (slow)", :slow do
      VCR.use_cassette('forecasts_sitelist', record: :none) do
        result = @client.forecasts_sitelist.first
        [:id, :name, :latitude, :longitude].each do |attr|
          result.must_respond_to attr
          result[attr].wont_be_nil
        end
      end
    end

    ['3hourly', 'daily'].each do |temporal_resolution|
      it "should be able to view #{temporal_resolution} capabilities" do
        VCR.use_cassette("#{temporal_resolution}_forecasts_capabilities", record: :once) do
          result = @client.forecasts_capabilities(res: temporal_resolution)
          result.must_be_instance_of MetofficeDatapoint::Mash
        end
      end

      it "should load correct capabilities data" do
        VCR.use_cassette("#{temporal_resolution}_forecasts_capabilities", record: :once) do
          result = @client.forecasts_capabilities(res: temporal_resolution)
          result.respond_to?(:data_date).must_equal true
          result.data_date.must_be_instance_of DateTime
          result.res.must_equal temporal_resolution
          result.type.must_equal 'wxfcs'
          time_steps = result.time_steps
          time_steps.must_be_instance_of MetofficeDatapoint::Mash
          time_steps_array = time_steps.ts
          time_steps_array.must_be_instance_of Array
          time_steps_array.first.must_be_instance_of DateTime
        end
      end

      it "should be able to view #{temporal_resolution} forecasts for all locations (stubbed)" do
        stub_request(:get, metoffice_datapoint_url('val/wxfcs/all/json/all', @client.api_key, res: temporal_resolution)).
            to_return(status: 200, body: load_json_fixture("#{temporal_resolution}_forecasts_all_sample"))

        result = @client.forecasts('all', res: temporal_resolution)
        result.must_be_instance_of MetofficeDatapoint::Mash
      end

      it "should be able to view #{temporal_resolution} forecasts for all locations (very slow)", :very_slow do
        VCR.use_cassette("#{temporal_resolution}_forecasts_all", record: :once) do
          result = @client.forecasts('all', res: temporal_resolution)
          result.must_be_instance_of MetofficeDatapoint::Mash
        end
      end

      it "should load correct #{temporal_resolution} forecasts for a specified location" do
        VCR.use_cassette("#{temporal_resolution}_forecasts_310069", record: :once) do
          result = @client.forecasts(310069, res: temporal_resolution)
          result.must_be_instance_of MetofficeDatapoint::Mash

          wx = result.wx
          wx.must_be_instance_of MetofficeDatapoint::Mash

          param = wx.param
          param.must_be_instance_of Array
          first_param = param.first
          first_param.must_be_instance_of MetofficeDatapoint::Mash
          [:'$', :name, :units].each do |attr|
            first_param.must_respond_to attr
          end

          dv = result.dv
          dv.must_be_instance_of MetofficeDatapoint::Mash
          dv.data_date.must_be_instance_of DateTime

          location = dv.location
          location.must_be_instance_of MetofficeDatapoint::Mash
          [:continent, :country, :i, :lat, :lon, :name, :period].each do |attr|
            location.must_respond_to attr
          end

          period = location.period
          period.must_be_instance_of Array

          first_period = period.first
          first_period.must_be_instance_of MetofficeDatapoint::Mash

          rep = first_period.rep
          rep.must_be_instance_of Array

          if temporal_resolution == '3hourly'
            attrs = [:'$', :d, :f, :g, :h, :pp, :s, :t, :u, :v, :w]
            attrs.each do |attr|
              rep.first.must_respond_to attr
            end
          else
            day_attrs = [:'$', :d, :dm, :f_dm, :gn, :hn, :p_pd, :s, :u, :v, :w]
            day_rep = rep[0]
            day_attrs.each do |attr|
              day_rep.must_respond_to attr
            end
            day_rep[:'$'].must_equal 'Day'
            night_attrs = [:'$', :d, :f_nm, :gm, :hm, :nm, :p_pn, :s, :v, :w]
            night_rep = rep[1]
            night_attrs.each do |attr|
              night_rep.must_respond_to attr
            end
            night_rep[:'$'].must_equal 'Night'
          end
        end
      end
    end

    it "should default to showing daily capabilities" do
      VCR.use_cassette("daily_forecasts_capabilities", record: :once) do
        result = @client.forecasts_capabilities
        result.must_be_instance_of MetofficeDatapoint::Mash
      end
    end

    it "should default to showing daily forecasts for all locations (stubbed)" do
      stub_request(:get, metoffice_datapoint_url('val/wxfcs/all/json/all', @client.api_key, res: 'daily')).
          to_return(status: 200, body: load_json_fixture('daily_forecasts_all_sample'))

      result = @client.forecasts
      result.must_be_instance_of MetofficeDatapoint::Mash
    end
  end

  describe "observations" do
    it "should be able to view the observations_sitelist" do
      VCR.use_cassette('observations_sitelist', record: :once) do
        result = @client.observations_sitelist
        result.must_be_instance_of Array
        result.first.must_be_instance_of MetofficeDatapoint::Mash
      end
    end

    it "should load correct location data" do
      VCR.use_cassette('observations_sitelist', record: :once) do
        result = @client.observations_sitelist.first
        [:id, :name, :latitude, :longitude].each do |attr|
          result.respond_to?(attr).must_equal true
          result[attr].wont_be_nil
        end
      end
    end

    ['3hourly', 'daily'].each do |temporal_resolution|
      it "should be able to view #{temporal_resolution} capabilities" do
        skip "API returning 500"
        VCR.use_cassette("#{temporal_resolution}_observations_capabilities", record: :once) do
          result = @client.observations_capabilities(res: temporal_resolution)
          result.must_be_instance_of MetofficeDatapoint::Mash
        end
      end

      it "should load correct capabilities data" do
        skip "API returning 500"
        VCR.use_cassette("#{temporal_resolution}_observations_capabilities", record: :once) do
          result = @client.observations_capabilities(res: temporal_resolution)
          puts result.inspect
          #result.respond_to?(:data_date).must_equal true
          #result.data_date.must_be_instance_of DateTime
          #result.res.must_equal temporal_resolution
          #result.type.must_equal 'wxfcs'
          #time_steps = result.time_steps
          #time_steps.must_be_instance_of MetofficeDatapoint::Mash
          #time_steps_array = time_steps.ts
          #time_steps_array.must_be_instance_of Array
          #time_steps_array.first.must_be_instance_of DateTime
        end
      end

      it "should be able to view #{temporal_resolution} observations for all locations (stubbed)" do
        skip "Don't have the stub json yet"
        stub_request(:get, metoffice_datapoint_url('val/wxobs/all/json/all', @client.api_key, res: temporal_resolution)).
            to_return(status: 200, body: load_json_fixture("#{temporal_resolution}_observations_all_sample"))

        result = @client.observations('all', res: temporal_resolution)
        result.must_be_instance_of MetofficeDatapoint::Mash
      end


      it "should be able to view #{temporal_resolution} observations for all locations (very slow)", :very_slow do
        skip "API returning 500"
        VCR.use_cassette("#{temporal_resolution}_observations_capabilities", record: :once) do
          result = @client.observations('all', res: temporal_resolution)
          result.must_be_instance_of MetofficeDatapoint::Mash
        end
      end

      it "should be able to view #{temporal_resolution} observations for a specified location" do
        skip "API returning 500"
        VCR.use_cassette("#{temporal_resolution}_observations_3094", record: :once) do
          result = @client.observations(3094, res: temporal_resolution)
          result.must_be_instance_of MetofficeDatapoint::Mash
        end
      end
    end

    it "should default to showing daily capabilities" do
      skip "API returning 500"
      VCR.use_cassette("daily_observations_capabilities", record: :once) do
        result = @client.observations_capabilities
        result.must_be_instance_of MetofficeDatapoint::Mash
      end
    end

    it "should default to showing daily observations for all locations (stubbed)" do
      skip "Don't have the stub json yet"
      stub_request(:get, metoffice_datapoint_url('val/wxobs/all/json/all', @client.api_key, res: 'daily')).
          to_return(status: 200, body: load_json_fixture('daily_observations_all_sample'))

      result = @client.observations
      result.must_be_instance_of MetofficeDatapoint::Mash
    end
  end
end