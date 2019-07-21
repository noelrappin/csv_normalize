class ZipNormalizer

  attr_accessor :input

  def initialize(input)
    @input = input || ""
  end

  def normalize
    input.rjust(5, "0")
  end
end