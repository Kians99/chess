require_relative 'piece'

class Pawn < Piece

  attr_reader :name
  attr_accessor :first_move, :first

  def initialize(color, unicode)
    super(color, unicode)
    @name = 'pawn'
    @first_move = true
    @first = true
  end

  #ADD ABILIRY TO MOVE DIAGNOLALY 

  def valid_move(start_coord, end_coord, board, player)
    #to_numerical[0] = start coordinate
    #to_numerical[1] = end coordinate
    to_numerical = super(start_coord, end_coord)
    moves = possible_moves(to_numerical[0], player, board)

    improper_move(moves, to_numerical) if self.first


    moves.include?(to_numerical[1])
  end

  def improper_move(moves, to_numerical)
    if !moves.include?(to_numerical[1])
      self.first_move = true
    else 
      self.first = false
    end
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
    pos_moves += empty_diagonal_for_passant(player.direction, coord, board)

    pos_moves 
  end

  private

  def coordinates(direction, orig_coord, new_coord = [])
    new_coord[0] = orig_coord[0]
    new_coord[1] = orig_coord[1] + direction
    new_coord
  end

  def diagonal(direction, orig_coord, board, new_coords = [])

    y = orig_coord[1] + (direction * 1)
    positive_x = orig_coord[0] + 1
    negative_x = orig_coord[0] - 1

    if valid_coord?(positive_x, y)
      pos_cord = [positive_x, y]
      new_coords.push(pos_cord) if board.chess_board[Piece.translate_to_algebraic(pos_cord)] != ' '
    end

    if valid_coord?(negative_x, y)
      other_pos_cord = [negative_x, y]  
      new_coords.push(other_pos_cord) if board.chess_board[Piece.translate_to_algebraic(other_pos_cord)] != ' '
    end
    new_coords
  end

  def helper_for_passant(pos_cord, orig_coord, board)
    translated_next_to = Piece.translate_to_algebraic([pos_cord[0], orig_coord[1]])
    chess_piece_there = board.chess_board[translated_next_to]
    if chess_piece_there != ' ' && chess_piece_there.name == 'pawn'
      return pos_cord
    end
    []
  end

  def empty_diagonal_for_passant(direction, orig_coord, board, new_coords = [])
    
    y = orig_coord[1] + (direction * 1)
    positive_x = orig_coord[0] + 1
    negative_x = orig_coord[0] - 1

    if direction == 1 && orig_coord[1] == 5

      if valid_coord?(positive_x, y)
        potential_move = helper_for_passant([positive_x, y], orig_coord, board)
        new_coords.push(potential_move) if potential_move != []
      end

      if valid_coord?(negative_x, y)
        potential_move = helper_for_passant([negative_x, y], orig_coord, board)
        new_coords.push(potential_move) if potential_move != []
      end

    elsif direction == -1 && orig_coord[1] == 4

      if valid_coord?(positive_x, y)
        potential_move = helper_for_passant([positive_x, y], orig_coord, board)
        new_coords.push(potential_move) if potential_move != []
      end

      if valid_coord?(negative_x, y)
        potential_move = helper_for_passant([negative_x, y], orig_coord, board)
        new_coords.push(potential_move) if potential_move != []
      end
    end
    new_coords
  end

end
