class Board

  attr_accessor :chess_board

  def initialize

    letters = [*('A'..'H')]
    numbers = [*('1'..'8')]
    @chess_board = {}

    numbers.reverse.each do |number|
      letters.each do |letter|
        coordinates = letter + number
        chess_board[coordinates] = approp_piece(coordinates)
      end
    end


  end

  def approp_piece(position)
    if position[1] == "1"
      if position[0] == "A" || position[0] == "H"
        #♖
        Rook.new("W", "\u2656")

      elsif position[0] == "B" || position[0] == "G"
        #♘
        Knight.new("W", "\u2658")
       
      elsif position[0] == "C" || position[0] == "F"
        #♗
        Bishop.new("W", "\u2657")

      elsif position == "D1"
        #♕
        Queen.new("W", "\u2655")

      else
        #♔
        King.new("W", "\u2654")
        
      end
    elsif position[1] == "8"
      if position[0] == "A" || position[0] == "H"
        #♜
        Rook.new("B", "\u265C")

      elsif position[0] == "B" || position[0] == "G"
        #♞
        Knight.new("B", "\u265E")
       
      elsif position[0] == "C" || position[0] == "F"
        #♝
        Bishop.new("B", "\u265D")
        
      elsif position == "E8"
        #♚
        King.new("B", "\u265A")
        
      else
        #♛
        Queen.new("B",  "\u265B")
        
      end
    elsif position[1] == "2"
      #♙
      Pawn.new("W", "\u2659")
      

    elsif position[1] == "7"
      #♟︎
      Pawn.new("B", "\u265F")
      
    else
      " "
    end
  end


end

