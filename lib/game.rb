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
          puts "That is not your piece to move." 
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

  def pawn_forward_capture(target_coord, player, piece, move)

    color = tell_user_whose_turn(player) == "black" ? "white" : "black"
    puts "\n"
    puts "\n"
    puts "The pawn is only able to capture other pieces diaganolly. It is still #{color}'s turn."
    player

  end
  

  def passant(target_coord, player, piece, move)

    translate_next_to = Piece.translate_to_numerical(move[0..1])

    target_move = Piece.translate_to_numerical(move[3..-1])

    y_orig = translate_next_to[1]
    x_orig = translate_next_to[0]

    loc_of_desired_piece_num = (target_move[0] == (x_orig + 1) ? [x_orig + 1, y_orig] : [x_orig - 1, y_orig])


    loc_of_desired_piece_alg = Piece.translate_to_algebraic(loc_of_desired_piece_num)
    change_piece_location(move[0..1], move[3..-1], piece)
    board.chess_board[loc_of_desired_piece_alg] = ' '
    board.print_board
    player.add_captured_piece('pawn')
    approp_color = number_to_color(player)
    print "Great! We moved #{approp_color}'s pawn to #{move[3..-1]} capturing #{tell_user_whose_turn(player)}'s pawn en passe. "
    puts "It is now #{tell_user_whose_turn(player)}'s turn."
    player.queue_all_moves.push([move[0..1], move[3..-1], piece.name])
    change_player(player)
  end

  def update_user(target_coord, player, piece, move)
    if target_coord == ' '

      if piece.name == 'pawn' && move[0..1][0] != move[3..-1][0]

        check_player_hist = change_player(player)
        last_move = check_player_hist.queue_all_moves[-1]
        x_coord_of_last_move = Piece.letter_to_number[last_move[1][0]]
        x_coord_of_current_pos = Piece.letter_to_number[move[0..1][0]]
        difference = (x_coord_of_last_move - x_coord_of_current_pos).abs
        if last_move[2] == 'pawn' && difference == 1 && (last_move[0][1].to_i + 2 == last_move[1][1].to_i || last_move[0][1].to_i - 2 == last_move[1][1].to_i)
          return passant(target_coord, player, piece, move)
        else
          puts "En passat is invalid as #{number_to_color(check_player_hist)} did not just move pawn."
          approp_color = number_to_color(player)
          puts "It is still #{approp_color}'s turn"
          return player
        end
      end

      change_piece_location(move[0..1], move[3..-1], piece)
      board.print_board
      approp_color = number_to_color(player)
      print "Great! We moved #{approp_color}'s #{piece.name} to #{move[3..-1]}. "
      puts "It is #{tell_user_whose_turn(player)}'s turn"
      player.queue_all_moves.push([move[0..1], move[3..-1], piece.name])
      change_player(player)

    elsif players_piece?(target_coord, player)

      return pawn_forward_capture(target_coord, player, piece, move) if piece.name == 'pawn' && move[0..1][0] == move[3..-1][0]

      change_piece_location(move[0..1], move[3..-1], piece)
      board.print_board
      player.add_captured_piece(target_coord.name)
      approp_color = number_to_color(player)
      print "Great! We moved #{approp_color}'s #{piece.name} to #{move[3..-1]} capturing #{tell_user_whose_turn(player)}'s #{target_coord.name}. "
      puts "It is now #{tell_user_whose_turn(player)}'s turn."
      player.queue_all_moves.push([move[0..1], move[3..-1], piece.name])
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
      move = (!inputted_move.nil? ? self.player_piece(inputted_move, current_player) : nil)
      if !move.nil?
        if piece_at_that_pos?(move)
          piece = board.chess_board[move[0..1]] 
          if piece.valid_move(move[0..1], move[3..-1], board, current_player)
            target_coord = board.chess_board[move[3..-1]]
            current_player = update_user(target_coord, current_player, piece, move)
          else
            puts "Not a valid move for #{piece.name}"  
          end
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

#game = Game.new
#game.start_game
