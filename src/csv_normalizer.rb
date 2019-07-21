require "csv"

class CsvNormalizer

  attr_accessor :input, :errors, :output
  
  def initialize(input)
    @input = input.encode("UTF-8", invalid: :replace)
    @errors = ""
    @output = ""
    @success = false
  end

  def normalize
    header, *rows = CSV.parse(input)
    header_check(header)
    self.output = CSV.generate do |csv|
      csv << header
      rows.each_with_index do |row, index|
        normalize_one_row(csv, index, row)
      end
    end
    @success = true
  rescue CSV::MalformedCSVError
    nil
  end

  EXPECTED_HEADER = "Timestamp,Address,ZIP,FullName,FooDuration,BarDuration,TotalDuration,Notes".freeze

  def header_check(header)
    header_matches = header.join(",") == EXPECTED_HEADER
    raise CSV::MalformedCSVError.new("Bad header", 1) unless header_matches
  end

  def normalize_one_row(csv, index, row)
    if row.size < 7 # allow for no notes
      self.errors << "Row #{index + 2} is invalid\n"
      return
    end
    normalizer = RowNormalizer.new(*row)
    result = normalizer.normalize
    if normalizer.successful?
      csv << result
    else
      self.errors << "Date parse error in row #{index + 2}\n"
    end
  end
end