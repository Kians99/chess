class Piece

  attr_reader :color, :unicode

  def initialize(color, unicode)
    @color = color
    @unicode = unicode
  end

  def translate_to_numerical(coord)
    num_val = []
    letter_to_number = { "A" => 1, "B" => 2, "C" => 3, "D" => 4, "E" => 5, "F" => 6, "G" => 7, "H" => 8}
    num_val[0] = letter_to_number[coord[0]]
    num_val[1] = coord[1].to_i
    num_val
  end


end

