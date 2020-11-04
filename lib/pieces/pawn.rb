require_relative 'piece'

class Pawn < Piece

  attr_reader :name
  attr_accessor :first_move

  def initialize(color, unicode)
    super(color, unicode)
    @name = 'pawn'
    @first_move = true
  end

  #ADD ABILIRY TO MOVE DIAGNOLALY 

  def valid_move(start_coord, end_coord, board, player)
    #to_numerical[0] = start coordinate
    #to_numerical[1] = end coordinate
    to_numerical = super(start_coord, end_coord)
    moves = possible_moves(to_numerical[0], player, board)
    moves.include?(to_numerical[1])
  end

  def possible_moves(coord, player, board, pos_moves = [])
    first_pos_move = coordinates(player.direction * 1, coord)
    pos_moves.push(first_pos_move)
    if self.first_move
      second_pos_move = coordinates(player.direction * 2, coord)
      pos_moves.push(second_pos_move)
      self.first_move = false
    end
    pos_moves += diagonal(player.direction, coord, board)

    pos_moves
  end

  private

  def coordinates(direction, orig_coord, new_coord = [])
    new_coord[0] = orig_coord[0]
    new_coord[1] = orig_coord[1] + direction
    new_coord
  end

  def diagonal(direction, orig_coord, board, new_coords = [])

    positive_y = orig_coord[1] + (direction * 1)
    positive_x = orig_coord[0] + 1
    negative_x = orig_coord[0] - 1

    if valid_coord?(positive_x, positive_y)

      pos_cord = [positive_x, positive_y]
      new_coords.push(pos_cord) if board.chess_board[Piece.translate_to_algebraic(pos_cord)] != ' '
    
    end

    if valid_coord?(negative_x, positive_y)
      other_pos_cord = [negative_x, positive_y]  
      new_coords.push(other_pos_cord) if board.chess_board[Piece.translate_to_algebraic(other_pos_cord)] != ' '
    end


    new_coords
    
  
  end

end
