require_relative 'piece'

class Bishop < Piece

  attr_reader :name

  def initialize(color, unicode)
    super(color, unicode)
    @name = 'bishop'
  end

  def valid_move(start_coord, end_coord, board, _player)
    
    to_numerical = super(start_coord, end_coord)
    moves = pos_diagonal_moves(to_numerical[0], board)
    p moves
    moves.include?(to_numerical[1])
    
  end

end

