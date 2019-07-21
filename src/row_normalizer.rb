class RowNormalizer

  # the assumption here is that the caller to this class is going
  # to send and receive an of strings and that the calling
  # class would be the one to handle CSV logistics
  
  # Also, this effectively hardcodes the nature of the columns.
  # The requirements don't say anything about this CSV changing,
  # so I felt that was a safe assumption

  attr_accessor :timestamp, :address, :zip, :full_name, :foo_duration,
                :bar_duration, :total_duration, :notes

  # This is a lot of arguments for a class, and normally I'd
  # make them keywords or pass a hash, but since these are in the
  # order of the CSV, I thought it'd be easier to take them in as
  # an array
  def initialize(timestamp, address, zip, full_name, foo_duration,
                 bar_duration, total_duration, notes)
    @timestamp = timestamp
    @address = address
    @zip = zip
    @full_name = full_name
    @foo_duration = foo_duration
    @bar_duration = bar_duration
    @total_duration = total_duration
    @notes = notes
  end

  # the ones I've pulled into methods are the ones that need to
  # be referred too, not just used
  def foo_duration_seconds
    @foo_duration_seconds ||= DurationNormalizer.new(foo_duration).normalize
  end

  def bar_duration_seconds
    @bar_duration_seconds ||= DurationNormalizer.new(bar_duration).normalize
  end

  def time_transformed
    @time_transformed ||= TimestampNormalizer.new(timestamp).normalize
  end

  def normalize
    [
      time_transformed,
      address,
      ZipNormalizer.new(zip).normalize,
      FullNameNormalizer.new(full_name).normalize,
      foo_duration_seconds,
      bar_duration_seconds,
      foo_duration_seconds + bar_duration_seconds,
      notes
    ]
  end

  def successful?
    time_transformed.present?
  end
  
end