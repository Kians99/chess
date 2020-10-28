require_relative 'pieces/bishop'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'
require_relative 'pieces/king'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'pieces/piece'

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

  def keys
    chess_board.keys
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

  def print_board
    all_pieces = chess_board.values
    value = 8
    total_count = 0
    puts "\n"
    puts "\n"
    8.times do |i|
      
      8.times do |j|
        top_of_row(j)
      end
    

      if i != 9
        print "\n"
        print "#{value}"
        value -= 1
        8.times do |i|
          if all_pieces[total_count] != ' '
            middle_of_row(i, all_pieces[total_count].unicode)
            total_count += 1
          else
            middle_of_row(i, ' ')
            total_count += 1
          end
        end
        puts "\n"
      end
    end

    8.times do |i| 
      top_of_row(i)
    end

    puts "\n"
    letters = [*('A'..'H')]

    letters.each do |letter|
      if letter == 'A'
        print "    #{letter}"
      else
        print "   #{letter}"
      end
    end

    puts "\n"
    puts "\n"

  end


  private 

  #CHECK HERE
  def top_of_row(i)
    if i == 0
      print '  +---'
      elsif i == 7
        print '+---+'
      else
        print '+---'
      end
  end

  #CHECK HERE
  def middle_of_row(i, type)
    if i == 0
      print " | #{type} "
    elsif i == 7
      print "| #{type} |"
    else
      print "| #{type} "
    end
  end
end

board = Board.new
p board.chess_board
board.print_board
