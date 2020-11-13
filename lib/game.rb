require_relative 'board'
require_relative 'player'
require 'yaml'
#require 'marshal'

class Game

  attr_reader :board, :player1, :player2
  attr_accessor :move_number

  def initialize

    @player1 = Player.new("W", 1, 1)
    @player2 = Player.new("B", 2, -1)
    @board = Board.new
    @move_number = 0

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
    [player, 'regular']

  end

  def deep_copy(o)
    Marshal.load(Marshal.dump(o))
  end

  def location_of_king(board, player)
    board.chess_board.each do |cord, piece|
      return Piece.translate_to_numerical(cord) if piece != ' ' && piece.name == 'king' && piece.color == player.color
    end
  end

  def pawn_cleanup(translated, possible_moves)
    moves = []
    possible_moves.each do |pawn_move|
      if pawn_move[0] != translated[0]
        moves.push(pawn_move)
      end
    end
    moves
  end

  def all_pieces_attacking_king(board, player, loc_of_king, pieces_attacking_king = [])
    board.chess_board.each do |cord, chess_piece|
      next unless chess_piece != ' ' && chess_piece.color == player.color
      translated = Piece.translate_to_numerical(cord)
      if chess_piece.name == 'pawn'
        pawn_possible_moves = chess_piece.possible_moves(translated, player, board)
        cleaned_up = pawn_cleanup(translated, pawn_possible_moves)
        pieces_attacking_king.push(translated) if cleaned_up.include?(loc_of_king)
      else
        pieces_attacking_king.push(translated) if chess_piece.possible_moves(translated, player, board).include?(loc_of_king)
      end
    end
    pieces_attacking_king
  end

  def mate(all_pos_moves, loc_of_king, board, player, other_player)
    pieces_threat_king = all_pieces_attacking_king(board, player, loc_of_king) #give me the coordinates of all the pieces currently threatening loc_of_king
    can_we_kill_attacking = all_moves_one_side_can_make(board, other_player) #all possible movements that can be made by the king player's pieces 
    
    #if each of the possible moves in 'can we kill attacking' if it includes the pieces tha

    if pieces_threat_king.size > 1
      true
    elsif pieces_threat_king.size == 1
      if !can_we_kill_attacking.include?(pieces_threat_king[0])
        true 
      else #we can get the threatening piece unless the piece that attacks is the king 

        king = board.chess_board[loc_of_king]
        king_possible_moves = king.possible_moves
        the_king_save_itself = king_possible_moves.any? do |king_move|
          pieces_threat_king.include?(pos_move)
        end

       

        if the_king_save_itself

          can_we_kill_attacking.delete_at(can_we_kill_attacking.find_index(pieces_threat_king[0]))
          if !can_we_kill_attacking.include?(pieces_threat_king[0])
            all_pos_moves.include?(pieces_threat_king[0])
          else
            false
          end
        else
          false
        end

        #below is only true if it is the ONLY PIECE THAT CAN SAVE ITSEFL
        
        
        

        #could my king kill the piece?
          #If so, will it then be in check? If so, then invalid. If not then valid. 
          #if not, then definitely false
      end
    end
  end

  def all_moves_one_side_can_make(board, player, all_moves = [])
    board.chess_board.each do |cord, chess_piece|
      next unless chess_piece != ' ' && chess_piece.color == player.color

      translated = Piece.translate_to_numerical(cord)
      if chess_piece.name == 'pawn'
        pawn_possible_moves = chess_piece.possible_moves(translated, player, board)
        cleaned_up = pawn_cleanup(translated, pawn_possible_moves)
        all_moves = all_moves + cleaned_up
      else
        all_moves = all_moves + chess_piece.possible_moves(translated, player, board)
      end
    end
    all_moves
  end
  

  def check(board, player, move, piece)

    all_pos_moves = []
    board.chess_board[move[0..1]] = ' '
    board.chess_board[move[3..-1]] = piece #we make the move the current player is making
    other_player = self.change_player(player) #we get reference to the other player
    loc_of_king = location_of_king(board, other_player)    #get location of OTHER person's king
    all_pos_moves = all_moves_one_side_can_make(board, player) #all possible moves of current player
    if all_pos_moves.include?(loc_of_king) #does any of the pos moves include the other king? If so in check/checkmate
      if king_in_trouble(all_pos_moves, loc_of_king, board, player, other_player) #if true king can make no possible move
        mate(all_pos_moves, loc_of_king, board, player, other_player) ? 'mate' : 'check' #possibly a mate. Above is a req. 
      else
        'check'
      end
    else
      if king_in_trouble(all_pos_moves, loc_of_king, board, player, other_player)
        stale(all_pos_moves, loc_of_king, board, player, other_player) ? 'stale' : 'regular'
        #This MAY be a stalemate but we can't be sure
        #if stalemate then stalemate else 'regular
      else
        'regular'
      end
      #stalemate ? (return 'stale') : (return 'regular')
    end
  end

  def stale(all_pos_moves, loc_of_king, board, player, other_player) 

    king_location = Piece.translate_to_algebraic(loc_of_king)
    king = board.chess_board[king_location]
    cleaned_moves = cleaned_king_moves(king, loc_of_king, other_player)

    pieces_threatening_king = []

    cleaned_moves.each do |king_move|
      pieces_threatening_king = pieces_threatening_king + all_pieces_attacking_king(board, player, king_move)
    end
    
    pieces_threatening_king.uniq!
    other_player_pos_moves = all_moves_one_side_can_make(board, other_player)

    if pieces_threatening_king.size > 1
      true
    elsif pieces_threatening_king.size == 1
      !other_player_pos_moves.include?(pieces_threatening_king[0])
    end
  end
  

  #FIX THIS SHITTTT
  #Check out for sticky pawn fingers
  #Also check out for other pieces being able to move to get rid of the piece(s)
  #threatening the king piece.

  def cleaned_king_moves(king, loc_of_king, other_player)
    king_location = Piece.translate_to_algebraic(loc_of_king)
    all_pos_king_moves = king.possible_moves(Piece.translate_to_numerical(king_location))
    cleaned_moves = []
    all_pos_king_moves.each do |k_move|
      translation = Piece.translate_to_algebraic(k_move)
      pos_move = board.chess_board[translation]
      if pos_move == ' ' || pos_move.color != other_player.color
        cleaned_moves.push(k_move)
      end
    end
    cleaned_moves
  end

  def king_in_trouble(all_pos_moves, loc_of_king, board, player, other_player)
    
    king_location = Piece.translate_to_algebraic(loc_of_king) #location of other person's king
    king = board.chess_board[king_location] #reference to other person's king
    cleaned_moves = cleaned_king_moves(king, loc_of_king, other_player) #get possible king moves of other player

    if cleaned_moves != []
    
      cant_move = cleaned_moves.all? do |king_move|
        all_pos_moves.include?(king_move)  #are all moves that the other player's king can move places that are threatened by current player
      end

      cant_move

      #ONLY RETURN CANT_MOVE IN THIS FUNCTION DO NOT THEN CALL MATE
      #we know for a fact if cant_move is false that means that we are not in checkmate. 
      #similarily fo cant_move is false we know for a fact we cannot be in stalemate 
      #if cant_move is true there is still a possibility we are in check NOT checkmate (depends on wether
      #other pieces can then capture the attacking piece). Similarily possibility we are in regular and not stalemate

      #if !cant_move
      #  false
      #else

      #  mate(all_pos_moves, loc_of_king, board, player, other_player)

      #end
    
    else
      false
    end
  end


  

  def passant(target_coord, player, piece, move)
    starting_position = Piece.translate_to_numerical(move[0..1])
    target_move = Piece.translate_to_numerical(move[3..-1])
    y_orig = starting_position[1]
    x_orig = starting_position[0]
    loc_of_desired_piece_num = (target_move[0] == (x_orig + 1) ? [x_orig + 1, y_orig] : [x_orig - 1, y_orig])
    loc_of_desired_piece_alg = Piece.translate_to_algebraic(loc_of_desired_piece_num)
    
    


    game_state = get_game_state(self.board, player, move, piece)
    other_in_check = game_state[0]
    cur_in_check = game_state[1]

    if cur_in_check == 'check' || cur_in_check == 'mate' #im in check for making that move
      color = number_to_color(player)
      puts "\n"
      puts "\n"
      puts "This move to #{move[3..-1]} would put you (or keep you) in check. It is still #{color}'s turn."
      [player, 'regular']

    elsif other_in_check == 'mate' #they are in check mate

      change_piece_location(move[0..1], move[3..-1], piece)
      board.chess_board[loc_of_desired_piece_alg] = ' '
      board.print_board
      player.add_captured_piece('pawn')
      approp_color = number_to_color(player)
      print "Great! We moved #{approp_color}'s pawn to #{move[3..-1]} capturing #{tell_user_whose_turn(player)}'s pawn en passe. "
      print "This has checkmated #{tell_user_whose_turn(player)}. "
      puts "The game is over. #{approp_color} wins!\n"
      self.move_number = self.move_number + 1 
      player.queue_all_moves.push([move[0..1], move[3..-1], piece.name, self.move_number])
      return [player, 'mate']



    elsif other_in_check == 'check' #they are in check


      change_piece_location(move[0..1], move[3..-1], piece)
      board.chess_board[loc_of_desired_piece_alg] = ' '
      board.print_board
      player.add_captured_piece('pawn')
      approp_color = number_to_color(player)
      print "Great! We moved #{approp_color}'s pawn to #{move[3..-1]} capturing #{tell_user_whose_turn(player)}'s pawn en passe. "
      print "This has placed #{tell_user_whose_turn(player)} in check. "
      puts "It is #{tell_user_whose_turn(player)}'s turn"
      self.move_number = self.move_number + 1 
      player.queue_all_moves.push([move[0..1], move[3..-1], piece.name, self.move_number])
      return [change_player(player), 'check']

    elsif other_in_check == 'stale' 

      change_piece_location(move[0..1], move[3..-1], piece)
      board.chess_board[loc_of_desired_piece_alg] = ' '
      board.print_board
      player.add_captured_piece('pawn')
      approp_color = number_to_color(player)
      print "We moved #{approp_color}'s pawn to #{move[3..-1]} capturing #{tell_user_whose_turn(player)}'s pawn en passe. "
      print "This has caused a stalemate. "
      print "The game is over. It is a tie"
      self.move_number = self.move_number + 1 
      player.queue_all_moves.push([move[0..1], move[3..-1], piece.name, self.move_number])
      return [player, 'stale']





    elsif other_in_check == 'regular'


      change_piece_location(move[0..1], move[3..-1], piece)
      board.chess_board[loc_of_desired_piece_alg] = ' '
      board.print_board
      player.add_captured_piece('pawn')
      approp_color = number_to_color(player)
      print "Great! We moved #{approp_color}'s pawn to #{move[3..-1]} capturing #{tell_user_whose_turn(player)}'s pawn en passe. "
      puts "It is #{tell_user_whose_turn(player)}'s turn"
      self.move_number = self.move_number + 1 
      player.queue_all_moves.push([move[0..1], move[3..-1], piece.name, self.move_number])
      return [change_player(player), 'regular']

    end
  end

  def get_game_state(board, player, move, piece)
    board_deep_copy = self.deep_copy(board)
    other_in_check = self.check(board_deep_copy, player, move, piece)

    chang_player = self.change_player(player)
    second_deep_copy = self.deep_copy(self.board)
    cur_in_check = self.check(second_deep_copy, chang_player, move, piece)

    [other_in_check, cur_in_check]
  end

  def update_user(target_coord, player, piece, move)
    if target_coord == ' '
      
      if piece.name == 'pawn' && move[0..1][0] != move[3..-1][0]
        check_player_hist = change_player(player)
        last_move = check_player_hist.queue_all_moves[-1]
        x_coord_of_last_move = Piece.letter_to_number[last_move[1][0]]
        x_coord_of_current_pos = Piece.letter_to_number[move[0..1][0]]
        x_coord_of_target_pos = Piece.letter_to_number[move[3..-1][0]]
        difference = (x_coord_of_last_move - x_coord_of_current_pos).abs
        if last_move[2] == 'pawn' && difference == 1 && x_coord_of_last_move == x_coord_of_target_pos && (last_move[0][1].to_i + 2 == last_move[1][1].to_i || last_move[0][1].to_i - 2 == last_move[1][1].to_i)
          return passant(target_coord, player, piece, move)
        else
          puts "En passat is invalid—#{number_to_color(check_player_hist)} did not just move the pawn you are trying to capture."
          approp_color = number_to_color(player)
          puts "It is still #{approp_color}'s turn"
          return [player, 'regular']
        end
      end

      #HERE WE ARE 

      #check for checkmate first 
      

      game_state = get_game_state(self.board, player, move, piece)
      other_in_check = game_state[0]
      cur_in_check = game_state[1]

      #HOW ABOUT CHECKMATE
      #check for checkmate first 
      #WE ARE NOW RETURNING AN ARRAY EVERYTIME WE RETURN A PLAYER
      #are they in checkmate?

      if cur_in_check == 'check' || cur_in_check == 'mate' #im in check for making that move

        color = number_to_color(player)
        puts "\n"
        puts "\n"
        puts "This move to #{move[3..-1]} would put you (or keep you) in check. It is still #{color}'s turn."
        [player, 'regular']

      elsif other_in_check == 'mate' #they are in check mate
      
        change_piece_location(move[0..1], move[3..-1], piece)
        board.print_board
        approp_color = number_to_color(player)
        print "We moved #{approp_color}'s #{piece.name} to #{move[3..-1]}. "
        print "This has checkmated #{tell_user_whose_turn(player)}. "
        print "The game is over. #{approp_color} wins!"
        self.move_number = self.move_number + 1 
        player.queue_all_moves.push([move[0..1], move[3..-1], piece.name, self.move_number])
        return [player, 'mate']
        
      elsif other_in_check == 'check' #they are in check

        change_piece_location(move[0..1], move[3..-1], piece)
        board.print_board
        approp_color = number_to_color(player)
        print "Great! We moved #{approp_color}'s #{piece.name} to #{move[3..-1]}. "
        print "This has placed #{tell_user_whose_turn(player)} in check. "
        puts "It is #{tell_user_whose_turn(player)}'s turn"
        self.move_number = self.move_number + 1 
        player.queue_all_moves.push([move[0..1], move[3..-1], piece.name, self.move_number])
        [change_player(player), 'check']



      elsif other_in_check == 'stale' 

        change_piece_location(move[0..1], move[3..-1], piece)
        board.print_board
        approp_color = number_to_color(player)
        print "We moved #{approp_color}'s #{piece.name} to #{move[3..-1]}. "
        print "This has caused a stalemate."
        print "The game is over. It is a tie"
        self.move_number = self.move_number + 1 
        player.queue_all_moves.push([move[0..1], move[3..-1], piece.name, self.move_number])
        return [player, 'stale']
      
      elsif other_in_check == 'regular'


        change_piece_location(move[0..1], move[3..-1], piece)
        board.print_board
        approp_color = number_to_color(player)
        print "Great! We moved #{approp_color}'s #{piece.name} to #{move[3..-1]}. "
        puts "It is #{tell_user_whose_turn(player)}'s turn"
        self.move_number = self.move_number + 1 
        player.queue_all_moves.push([move[0..1], move[3..-1], piece.name, self.move_number])
        [change_player(player), 'regular']

      end

      #Make different functions for check/checkmate/stalemate
      #check for checkmate then check 
      #function that tests to see if king is in check/checkmate
      #function that can reset if the king is in fact check/checkmate
      #does this expose the player's king who is making the move?

    elsif players_piece?(target_coord, player)

      return pawn_forward_capture(target_coord, player, piece, move) if piece.name == 'pawn' && move[0..1][0] == move[3..-1][0]
      
      
      
      game_state = get_game_state(self.board, player, move, piece)
      other_in_check = game_state[0]
      cur_in_check = game_state[1]

      




      if cur_in_check == 'check' || cur_in_check == 'mate' #im in check for making that move
        color = number_to_color(player)
        puts "\n"
        puts "\n"
        puts "This move to #{move[3..-1]} would put you (or keep you) in check. It is still #{color}'s turn."
        [player, 'regular']


      elsif other_in_check == 'mate' #they are in check mate

        change_piece_location(move[0..1], move[3..-1], piece)
        board.print_board
        player.add_captured_piece(target_coord.name)
        approp_color = number_to_color(player)
        print "Great! We moved #{approp_color}'s #{piece.name} to #{move[3..-1]} capturing #{tell_user_whose_turn(player)}'s #{target_coord.name}. "
        print "This has checkmated #{tell_user_whose_turn(player)}. "
        print "The game is over. #{approp_color} wins!"
        self.move_number = self.move_number + 1 
        player.queue_all_moves.push([move[0..1], move[3..-1], piece.name, self.move_number])
        return [player, 'mate']
        
      elsif other_in_check == 'check' #they are in check

        change_piece_location(move[0..1], move[3..-1], piece)
        board.print_board
        player.add_captured_piece(target_coord.name)
        approp_color = number_to_color(player)
        print "Great! We moved #{approp_color}'s #{piece.name} to #{move[3..-1]} capturing #{tell_user_whose_turn(player)}'s #{target_coord.name}. "
        print "This has placed #{tell_user_whose_turn(player)} in check. "
        puts "It is #{tell_user_whose_turn(player)}'s turn"
        self.move_number = self.move_number + 1 
        player.queue_all_moves.push([move[0..1], move[3..-1], piece.name, self.move_number])
        return [change_player(player), 'check']



      elsif other_in_check == 'stale' 




        change_piece_location(move[0..1], move[3..-1], piece)
        board.print_board
        player.add_captured_piece(target_coord.name)
        approp_color = number_to_color(player)
        print "We moved #{approp_color}'s #{piece.name} to #{move[3..-1]} capturing #{tell_user_whose_turn(player)}'s #{target_coord.name}. "
        print "This has caused a stalemate."
        print "The game is over. It is a tie"
        self.move_number = self.move_number + 1 
        player.queue_all_moves.push([move[0..1], move[3..-1], piece.name, self.move_number])
        return [player, 'stale']
      
      elsif other_in_check == 'regular'



        change_piece_location(move[0..1], move[3..-1], piece)
        board.print_board
        player.add_captured_piece(target_coord.name)
        approp_color = number_to_color(player)
        print "Great! We moved #{approp_color}'s #{piece.name} to #{move[3..-1]} capturing #{tell_user_whose_turn(player)}'s #{target_coord.name}. "
        puts "It is #{tell_user_whose_turn(player)}'s turn"
        self.move_number = self.move_number + 1 
        player.queue_all_moves.push([move[0..1], move[3..-1], piece.name, self.move_number])
        return [change_player(player), 'regular']

      end


    else
      color = tell_user_whose_turn(player) == "black" ? "white" : "black"
      puts "\n"
      puts "\n"
      puts "There is a #{color} piece already on #{move[3..-1]}. It is still #{color}'s turn."
      [player, 'regular']
    end
  end

  def main_game_loop
    current_player = self.player1
    puts 'White moves first. Please enter your move:'
    #until a checkmate/stalemate occurs



    #game_status can equal 'mate' 'check' 'stalemate' or 'regular
    game_status = 'regular'


    until game_status == 'mate' || game_status == 'stale'
      
      inputted_move = make_move(player1)
      move = (!inputted_move.nil? ? self.player_piece(inputted_move, current_player) : nil)
      if !move.nil?
        if piece_at_that_pos?(move)
          piece = board.chess_board[move[0..1]]
          
          


          if piece.valid_move(move[0..1], move[3..-1], board, current_player) && game_status == 'regular'
            target_coord = board.chess_board[move[3..-1]]
            player_and_state = update_user(target_coord, current_player, piece, move)
            current_player = player_and_state[0]
            game_status = player_and_state[1]

          elsif piece.valid_move(move[0..1], move[3..-1], board, current_player) && game_status == 'check'
            target_coord = board.chess_board[move[3..-1]]
            player_and_state = update_user(target_coord, current_player, piece, move)
            current_player = player_and_state[0]
            game_status = player_and_state[1]

            

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

game = Game.new
game.start_game
