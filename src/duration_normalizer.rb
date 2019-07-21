class DurationNormalizer
  attr_accessor :input

  def initialize(input)
    @input = input
  end

  # We're not using the ISO format here, so ActiveSupport#Duration
  # is overkill, we'll just do a simple parse
  def normalize
    return 0 if input.blank?
    @output ||= begin
      hours, minutes, seconds = input.split(":")
      if minutes.nil? && seconds.nil? # format is just "32.23"
        seconds = hours
        hours = nil
      elsif seconds.nil? # format is just "2:32.23"
        seconds = minutes
        minutes = hours
        hours = nil
      end
      (hours.to_i * 3600) + (minutes.to_i * 60) + seconds.to_f
    end
  end
end