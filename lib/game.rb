require_relative 'board'
require_relative 'player'
require 'yaml'

class Game

  attr_reader :board, :player1, :player2

  def initialize

    @player1 = Player.new("W", 1, 1)
    @player2 = Player.new("B", 2, -1)
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
    proper_move_format?(move) ?  move : (print 'Coordinates entered in invalid format. ')
  end

  def proper_move_format?(move)
    valid_coords = board.keys
    move.length == 5 && valid_coords.include?(move[0..1]) && valid_coords.include?(move[3..-1]) && move[0..1] != move[3..-1]
  end

  def piece_at_that_pos?(move)
    board.chess_board[move[0..1]] != ' '
  end

  def player_piece(desired_move, player)
    piece = board.chess_board[desired_move[0..1]]
      if piece != ' '
        if players_piece?(piece, player) 
          desired_move = nil
          puts "That is not your piece to move!" 
        end
      end
    desired_move 
  end

  def players_piece?(piece, player)
    piece.color != player.color
  end

  def change_piece_location(start_coord, end_coord, piece)
    board.chess_board[start_coord] = ' '
    board.chess_board[end_coord] = piece
  end

  def change_player(player)
    player.number == 1 ? self.player2 : self.player1
  end

  def tell_user_whose_turn(player)
    player.number == 1 ? ("black") : ("white")
  end

  def number_to_color(player)
    player.number == 1 ? ("white") : ("black")
  end

  def update_user(target_coord, player, piece, move)
    if target_coord == ' '
      change_piece_location(move[0..1], move[3..-1], piece)
      board.print_board
      approp_color = number_to_color(player)
      print "Great! We moved #{approp_color}'s #{piece.name} to #{move[3..-1]}. "
      puts "It is #{tell_user_whose_turn(player)}'s turn"
      change_player(player)
    elsif players_piece?(target_coord, player)
      change_piece_location(move[0..1], move[3..-1], piece)
      board.print_board
      player.add_captured_piece(target_coord.name)
      approp_color = number_to_color(player)
      print "Great! We moved #{approp_color}'s #{piece.name} to #{move[3..-1]} capturing a #{tell_user_whose_turn(player)} #{target_coord.name}. "
      puts "It is now #{tell_user_whose_turn(player)}'s turn"
      change_player(player)
    else
      color = tell_user_whose_turn(player) == "black" ? "white" : "black"
      puts "\n"
      puts "\n"
      puts "There is a #{color} piece already on #{move[3..-1]}. It is still #{color}'s turn."
      player
    end
  end

  def main_game_loop

    current_player = self.player1
    puts 'White moves first. Please enter your move:'
    #until a checkmate/stalemate occurs
    until false

      inputted_move = make_move(player1)
      inputted_move != nil ? move = self.player_piece(inputted_move, current_player) : move = nil
      

      if !move.nil?

        #USE KNIGHT AS MODEL FOR OTHER PIECES
        #MAKE SURE ALL PIECES ARE UNABLE TO MOVE PAST ANOTHER PIECE (EXCEPT FOR KNIGHT)
        #ALSO MAKE SURE PIECE CAN ONLY TAKE PIECES OF THE OTHER KIND AND SHOULD NOT BE ABLE
        #TO MOVE TO THE SAME COORD AS WHERE A PIECE OF THE SAME TYPE ALREADY IS

        if piece_at_that_pos?(move)
          
          piece = board.chess_board[move[0..1]] 
          if piece.valid_move(move[0..1], move[3..-1], board, current_player)
            
            target_coord = board.chess_board[move[3..-1]]
            
            current_player = update_user(target_coord, current_player, piece, move)
          else
            puts "Not a valid move for #{piece.name}"  
          end
          #p piece
          #check what kind of piece it is
          #See if the desired move is valid for that piece
        else
          puts "There is no piece at position #{move[0..1]}"
        end
        
        
        
      else 
        puts 'Please try again!'
      end

    end

  end
  #after everytime someone makes a move, I want to check two things
  # 1. Did the most recent move make the king in check thereby making the move illegal?
    # this is only valid if it made the other king in check
  # 2. If not, did the most recent make the *other* king in check or checkmate?
end

game = Game.new
game.start_game
