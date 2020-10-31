require_relative 'piece'

class Pawn < Piece

  attr_reader :name

  def initialize(color, unicode)
    super(color, unicode)
    @name = 'pawn'
  end

  #ADD ABILIRY TO MOVE DIAGNOLALY 

  def valid_move(start_coord, end_coord, player)
    #to_numerical[0] = start coordinate
    #to_numerical[1] = end coordinate
    to_numerical = super(start_coord, end_coord)
    moves = possible_moves(to_numerical[0], player)
    moves.include?(to_numerical[1])
  end

  def possible_moves(coord, player, pos_moves = [])
    first_pos_move = coordinates(player.direction * 1, coord)
    pos_moves.push(first_pos_move)
    if coord[1] == 2 || coord[1] == 7
      second_pos_move = coordinates(player.direction * 2, coord)
      pos_moves.push(second_pos_move)
    end
    pos_moves
  end

  private

  def coordinates(direction, orig_coord, new_coord = [])
    new_coord[0] = orig_coord[0]
    new_coord[1] = orig_coord[1] + direction
    new_coord
  end

end
