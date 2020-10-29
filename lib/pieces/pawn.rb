require_relative 'piece'

class Pawn < Piece

  attr_reader :name

  def initialize(color, unicode)
    super(color, unicode)
    @name = 'pawn'
  end

  def valid_move(start_coord, end_coord, player)
    num_start = Piece.translate_to_numerical(start_coord)
    moves = possible_moves(num_start, player)
    num_end = Piece.translate_to_numerical(end_coord)
    moves.include?(num_end)
  end

  private

  def possible_moves(coord, player, pos_moves = [])
    p player.direction
    first_pos_move = coordinates(player.direction * 1, coord)
    pos_moves.push(first_pos_move)
    if coord[1] == 2 || coord[1] == 7
      second_pos_move = coordinates(player.direction * 2, coord)
      pos_moves.push(second_pos_move)
    end
    p pos_moves
    pos_moves
  end

  def coordinates(spaces, orig_coord, new_coord = [])
    new_coord[0] = orig_coord[0]
    new_coord[1] = orig_coord[1] + spaces
    new_coord
  end

end
