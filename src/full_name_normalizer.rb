class FullNameNormalizer

  attr_accessor :input

  def initialize(input)
    @input = input || ""

  end

  # ruby's upcase method handles Unicode characters
  def normalize
    input.upcase
  end
end