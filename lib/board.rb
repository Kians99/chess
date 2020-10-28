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


  


end

