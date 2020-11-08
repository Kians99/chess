require_relative 'piece'

class Queen < Piece

  attr_reader :name

  def initialize(color, unicode)
    super(color, unicode)
    @name = "queen"
  end

  def valid_move(start_coord, end_coord, board, _player)
    
    to_numerical = super(start_coord, end_coord)
    diagnoal_moves = pos_diagonal_moves(to_numerical[0], board)
    vertical_moves = pos_vertical_moves(to_numerical[0], board, 1) + pos_vertical_moves(to_numerical[0], board, -1)
    horizontal_moves = pos_horizontal_moves(to_numerical[0], board, 1) + pos_horizontal_moves(to_numerical[0], board, -1)
    moves = vertical_moves + horizontal_moves + diagnoal_moves
    moves.include?(to_numerical[1])
    
  end

  def possible_moves(to_numerical, _player, board, _pos_moves = [])
    
    diagnoal_moves = pos_diagonal_moves(to_numerical, board)
    vertical_moves = pos_vertical_moves(to_numerical, board, 1) + pos_vertical_moves(to_numerical, board, -1)
    horizontal_moves = pos_horizontal_moves(to_numerical, board, 1) + pos_horizontal_moves(to_numerical, board, -1)
    vertical_moves + horizontal_moves + diagnoal_moves
  end

end