class Piece

  attr_reader :color, :unicode

  @@letter_to_number = { "A" => 1, "B" => 2, "C" => 3, "D" => 4, "E" => 5, "F" => 6, "G" => 7, "H" => 8}

  def initialize(color, unicode)
    @color = color
    @unicode = unicode
  end

  def self.letter_to_number
    @@letter_to_number
  end

  def self.translate_to_numerical(coord)
    num_val = []
    num_val[0] = Piece.letter_to_number[coord[0]]
    num_val[1] = coord[1].to_i
    num_val
  end

  def self.translate_to_algebraic(coord)
    Piece.letter_to_number.key(coord[0]) + coord[1].to_s
  end

  def valid_move(start_coord, end_coord)
    num_start = Piece.translate_to_numerical(start_coord)
    num_end = Piece.translate_to_numerical(end_coord)
    [num_start, num_end]
  end

  def valid_coord?(x_val, y_val)
    x_val.between?(1, 8) && y_val.between?(1, 8)
  end

  def piece_in_the_way?(coord, board)

    translate = Piece.translate_to_algebraic(coord)
    board.chess_board[translate] != ' '
  end

  def pos_vertical_moves(start_coord, board, direction)

    pos_moves = []

    7.times do |i|
      new_coord = []
      new_coord[0] = start_coord[0]
      new_coord[1] = start_coord[1] + ((i + 1) * direction)
      if valid_coord?(new_coord[0], new_coord[1]) 
        pos_moves.push(new_coord)
        return pos_moves if piece_in_the_way?(new_coord, board)
      else 
        return pos_moves
      end
    end
    pos_moves
  end

  def pos_horizontal_moves(start_coord, board, direction)

    pos_moves = []

    7.times do |i|
      new_coord = []
      new_coord[1] = start_coord[1]
      new_coord[0] = start_coord[0] + ((i + 1) * direction)
      if valid_coord?(new_coord[0], new_coord[1]) 
        pos_moves.push(new_coord)
        return pos_moves if piece_in_the_way?(new_coord, board)
      else 
        return pos_moves
      end
    end
    pos_moves
  end

  #Add funtion that cleans the possible inputs
  #add function that checks to see what kind of piece
  #is already at the avaible inputs


end

