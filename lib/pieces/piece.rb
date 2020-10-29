class Piece

  attr_reader :color, :unicode

  @@letter_to_number = { "A" => 1, "B" => 2, "C" => 3, "D" => 4, "E" => 5, "F" => 6, "G" => 7, "H" => 8}

  def initialize(color, unicode)
    @color = color
    @unicode = unicode
  end

  def self.letter_to_number
    @@letter_to_number
  end

  def self.translate_to_numerical(coord)
    num_val = []
    num_val[0] = Piece.letter_to_number[coord[0]]
    num_val[1] = coord[1].to_i
    num_val
  end

  def self.translate_to_algebraic(coord)
    Piece.letter_to_number.key(coord[0]) + coord[1].to_s
  end


end

