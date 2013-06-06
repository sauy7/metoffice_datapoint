require_relative '../../test_helper'

describe MetofficeDatapoint::Mash do
  describe ".from_json" do
    it "should convert a json string to a Mash" do
      json_string = "{\"name\":\"Josh Kalderimis\"}"
      mash = MetofficeDatapoint::Mash.from_json(json_string)

      mash.has_key?('name').must_equal true
      mash.name.must_equal 'Josh Kalderimis'
    end
  end
end