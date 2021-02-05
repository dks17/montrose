# frozen_string_literal: true

require "spec_helper"

describe Montrose::Utils do
  include Montrose::Utils

  it "return current_time" do
    Time.freeze do
      expect(current_time).to eq(Time.current)
    end
  end

  describe "#as_time" do
    it "parses Strings" do
      time_string = Time.now.to_s
      as_time(time_string).class.must_equal Time
      as_time(time_string).must_equal Time.parse(time_string)
    end

    it "returns unmodified ActiveSupport::TimeWithZone objects" do
      Time.use_zone("Beijing") do
        time_with_zone = Time.zone.now
        time_with_zone.class.must_equal ActiveSupport::TimeWithZone
        as_time(time_with_zone).must_equal time_with_zone
      end
    end

    it "casts to_time if available" do
      as_time(Date.today).must_equal Date.today.to_time
    end
  end

  describe "#parse_time" do
    it { parse_time("Sept 1, 2015 12:00PM").must_equal Time.parse("Sept 1, 2015 12:00PM") }
    it "uses Time.zone if available" do
      Time.use_zone("Hawaii") do
        time = parse_time("Sept 1, 2015 12:00PM")
        time.month.must_equal 9
        time.day.must_equal 1
        time.year.must_equal 2015
        time.hour.must_equal 12
        time.utc_offset.must_equal(-10.hours)
      end
    end
  end

  describe "#days_in_month" do
    non_leap_year = 2015
    leap_year = 2016
    it { days_in_month(1).must_equal 31 }
    it { days_in_month(2, non_leap_year).must_equal 28 }
    it { days_in_month(2, leap_year).must_equal 29 }
    it { days_in_month(3).must_equal 31 }
    it { days_in_month(4).must_equal 30 }
    it { days_in_month(5).must_equal 31 }
    it { days_in_month(6).must_equal 30 }
    it { days_in_month(7).must_equal 31 }
    it { days_in_month(8).must_equal 31 }
    it { days_in_month(9).must_equal 30 }
    it { days_in_month(10).must_equal 31 }
    it { days_in_month(11).must_equal 30 }
    it { days_in_month(12).must_equal 31 }
  end

  describe "#days_in_year" do
    it { days_in_year(2005).must_equal 365 }
    it { days_in_year(2004).must_equal 366 }
    it { days_in_year(2000).must_equal 366 }
    it { days_in_year(1900).must_equal 365 }
  end
end
