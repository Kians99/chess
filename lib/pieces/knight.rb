require_relative 'piece'

class Knight < Piece

  attr_reader :name

  def initialize(color, unicode)
    super(color, unicode)
    @name = 'knight'
  end

  def valid_move(start_coord, end_coord, player)
    #to_numerical[0] = start coordinate
    #to_numerical[1] = end coordinate
    to_numerical = super(start_coord, end_coord)
    moves = possible_moves(to_numerical[0])
    moves.include?(to_numerical[1])
  end

  def possible_moves(coord, movement = [1,2], pos_moves = [])

    positive_y = coord[1] + movement[1]
    negative_y = coord[1] - movement[1]
    positive_x = coord[0] + movement[0]
    negative_x = coord[0] - movement[0]

    pos_moves.push([positive_x, positive_y]) if valid_coord?(positive_x, positive_y)
    pos_moves.push([negative_x, positive_y]) if valid_coord?(negative_x, positive_y)
    pos_moves.push([positive_x, negative_y]) if valid_coord?(positive_x, negative_y)
    pos_moves.push([negative_x, negative_y]) if valid_coord?(negative_x, negative_y)

    positive_x = coord[0] + movement[1]
    negative_x = coord[0] - movement[1]
    positive_y = coord[1] + movement[0]
    negative_y = coord[1] - movement[0]

    pos_moves.push([positive_x, positive_y]) if valid_coord?(positive_x, positive_y)
    pos_moves.push([positive_x, negative_y]) if valid_coord?(positive_x, negative_y)
    pos_moves.push([negative_x, positive_y]) if valid_coord?(negative_x, positive_y)
    pos_moves.push([negative_x, negative_y]) if valid_coord?(negative_x, negative_y)

    pos_moves
  end

end