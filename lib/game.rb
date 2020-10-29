require_relative 'board'
require_relative 'player'
require 'yaml'

class Game

  attr_reader :board, :player1, :player2

  def initialize

    @player1 = Player.new("W", 1)
    @player2 = Player.new("B", 2)
    @board = Board.new

  end

  def start_game
    puts "\nHi! Welcome to Chess. Player 1 is white and will go first. Here is the printed board:"
    board.print_board
    puts "\nPlease use the standard style of algebraic notation to move a piece. For example, one would type \"B1 C3\" to move the knight currently on \"B1\" to \"C3\". If the same coordinate is entered, like 
\"A3 A3\" then that input will be considered invalid.\n\n"
    self.main_game_loop
  end

  def make_move(player)
    move = player.make_guess
    proper_move_format?(move) ?  move : (print 'Coordinates entered in invalid format.')
  end

  def proper_move_format?(move)
    valid_coords = board.keys
    move.length == 5 && valid_coords.include?(move[0..1]) && valid_coords.include?(move[3..-1]) && move[0..1] != move[3..-1]
  end

  def piece_at_that_pos?(move)
    !(board.chess_board[move[0..1]] == " ")
  end

  def main_game_loop

    current_player = self.player1
    puts 'White moves first. Please enter your move:'
    #until a checkmate/stalemate occurs
    until false

      move = make_move(player1)

      if !move.nil?

        if piece_at_that_pos?(move)
          puts "PIECE"
          #piece = board.chess_board[move[0..1]]
          #p piece
          #check what kind of piece it is
          #See if the desired move is valid for that piece
        else
          puts "There is no piece at position #{move[0..1]}"
        end
        
        
        
      else 
        puts ' Please try again!'
      end

      #current_player.number == 1 ? current_player = self.player2 : current_player = self.player1

    end

  end
  #after everytime someone makes a move, I want to check two things
  # 1. Did the most recent move make the king in check thereby making the move illegal?
    # this is only valid if it made the other king in check
  # 2. If not, did the most recent make the *other* king in check or checkmate?
end

game = Game.new
game.start_game