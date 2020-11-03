require_relative 'piece'

class King < Piece

  attr_reader :name

  def initialize(color, unicode)
    super(color, unicode)
    @name = 'king'
  end

  def valid_move(start_coord, end_coord, _board, _player)
    #to_numerical[0] = start coordinate
    #to_numerical[1] = end coordinate
    to_numerical = super(start_coord, end_coord)
    moves = possible_moves(to_numerical[0])
    moves.include?(to_numerical[1])
  end


  def possible_moves(coord, movement = [1,1], pos_moves = [])

    positive_y = coord[1] + movement[1]
    negative_y = coord[1] - movement[1]
    positive_x = coord[0] + movement[0]
    negative_x = coord[0] - movement[0]

    pos_moves.push([positive_x, positive_y]) if valid_coord?(positive_x, positive_y)
    pos_moves.push([negative_x, positive_y]) if valid_coord?(negative_x, positive_y)
    pos_moves.push([coord[0], positive_y]) if valid_coord?(coord[0], positive_y)
    pos_moves.push([positive_x, coord[1]]) if valid_coord?(positive_x, coord[1])
    pos_moves.push([positive_x, negative_y]) if valid_coord?(positive_x, negative_y)
    pos_moves.push([coord[0], negative_y]) if valid_coord?(coord[0], negative_y)
    pos_moves.push([negative_x, negative_y]) if valid_coord?(negative_x, negative_y)
    pos_moves.push([negative_x, coord[1]]) if valid_coord?(negative_x, coord[1])
    
    pos_moves
  end

end
