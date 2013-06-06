# -*- encoding: utf-8 -*-
require_relative '../../test_helper'

describe MetofficeDatapoint do
  describe "VERSION" do
    it "must be defined" do
      MetofficeDatapoint::VERSION.wont_be_nil
    end
  end
end