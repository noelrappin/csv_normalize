
require 'active_support/all'

class TimestampNormalizer

  attr_accessor :input, :successful

  INPUT_TIME_ZONE = "Pacific Time (US & Canada)".freeze
  OUTPUT_TIME_ZONE = "Eastern Time (US & Canada)".freeze
  
  def initialize(input) 
    @input = input
  end

  # You can assume that the sample data we provide will contain all
  # date and time format variants you will need to handle.
  #
  # All the sample timestamps are in the form "4/1/11 11:00:00 AM"
  # so I'm assuming I can use strptime on this -- plain parse
  # doesn't work because it parses the above as January 4, not
  # April 1
  #
  # The requirements have an ambiguity
  # "The Timestamp column should be assumed to be in US/Pacific time"
  # vs. "any times that are missing timezone information are in US/Pacific"
  #
  # Implies that their might be times that are missing but
  # "You can assume that the sample data we provide will contain all date and time format
  # variants you will need to handle"
  #
  # And there's nothing that has a sample timezone, so I'm going
  # to assume Pacific.
  #
  # I brought in ActiveSupport, since they've got the time zone
  # transformations already

  def normalize
    @output ||= begin
      Time.zone = INPUT_TIME_ZONE
      date = Time.zone.strptime(input, "%m/%d/%y %l:%M:%S %p")
      date = date.in_time_zone(OUTPUT_TIME_ZONE).iso8601
      @success = true
      date
    rescue ArgumentError, TypeError
      nil
    end
  end
end