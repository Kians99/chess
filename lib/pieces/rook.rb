require_relative 'piece'

class Rook < Piece

  attr_reader :name

  def initialize(color, unicode)
    super(color, unicode)
    @name = 'rook'
  end

  def valid_move(start_coord, end_coord, board, _player)
    
    to_numerical = super(start_coord, end_coord)
    vertical_moves = pos_vertical_moves(to_numerical[0], board, 1) + pos_vertical_moves(to_numerical[0], board, -1)
    horizontal_moves = pos_horizontal_moves(to_numerical[0], board, 1) + pos_horizontal_moves(to_numerical[0], board, -1)
    moves = vertical_moves + horizontal_moves
    moves.include?(to_numerical[1])
    
  end

  def possible_moves(to_numerical, _player, board, _pos_moves = [])
    
    vertical_moves = pos_vertical_moves(to_numerical, board, 1) + pos_vertical_moves(to_numerical, board, -1)
    
    
    horizontal_moves = pos_horizontal_moves(to_numerical, board, 1) + pos_horizontal_moves(to_numerical, board, -1)
    
    
    vertical_moves + horizontal_moves
  end

end