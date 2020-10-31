class Player

  attr_reader :color, :number, :direction, :captured_pieces

  def initialize(color, number, direction)
    @color = color
    @number = number
    @direction = direction
    @captured_pieces = []
  end

  def add_captured_piece(piece)
    captured_pieces.push(piece)
  end

  def make_guess
    gets.chomp
  end
end
