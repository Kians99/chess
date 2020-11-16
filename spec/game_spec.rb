require './lib/game'

describe Game do
  describe '#proper_move_format?' do
    it "disallows lowercase coordinates" do
      game = Game.new
      expect(game.proper_move_format?("a6 b7")).to eql(false)
    end

    it "disallows coodinates with the second number being too large" do
      game = Game.new
      expect(game.proper_move_format?("A6 B17")).to eql(false)
    end

    it "disallows coodinates with the first number being too large" do
      game = Game.new
      expect(game.proper_move_format?("A20 B1")).to eql(false)
    end

    it "disallows coodinates with no space between them" do
      game = Game.new
      expect(game.proper_move_format?("A2B1")).to eql(false)
    end

    it "disallows coodinates with no space between them" do
      game = Game.new
      expect(game.proper_move_format?("A2B1")).to eql(false)
    end

    it "disallows coodinates with symbols" do
      game = Game.new
      expect(game.proper_move_format?("A@ B1")).to eql(false)
    end

    it "Allows valid coodinate" do
      game = Game.new
      expect(game.proper_move_format?("A2 B1")).to eql(true)
    end

    it "Allows valid coodinate" do
      game = Game.new
      expect(game.proper_move_format?("H7 H1")).to eql(true)
    end
  end

  describe '#player_piece' do
    it "Allows player white to move white piece" do
      game = Game.new
      player = Player.new("W", 1, 1)
      result = game.player_piece("D1", player)
      expect(result).not_to eql(nil)
    end

    it "Allows player black to move black piece" do
      game = Game.new
      player = Player.new("B", 2, -1)
      result = game.player_piece("F8", player)
      expect(result).not_to eql(nil)
    end


    it "Disallows player black to move white piece" do
      game = Game.new
      player = Player.new("B", 2, -1)
      result = game.player_piece("A2", player)
      expect(result).to eql(nil)
    end

    it "Disallows player white to move black piece" do
      game = Game.new
      player = Player.new("W", 1, 1)
      result = game.player_piece("A7", player)
      expect(result).to eql(nil)
    end

    it "Returns coordinate input if coordinate is empty" do
      game = Game.new
      player = Player.new("W", 1, 1)
      result = game.player_piece("C5", player)
      expect(result).to eql("C5")
    end

  end

  describe '#piece_at_that_pos?' do
    it "Returns true for piece at that position" do 
      game = Game.new
      actual = game.piece_at_that_pos?("B2")
      expect(actual).to eql(true)
    end

    it "Returns false for piece at that position" do 
      game = Game.new
      actual = game.piece_at_that_pos?("E6")
      expect(actual).to eql(false)
    end
  end

  describe '#update_user' do 
    it 'moves piece to empty spot for white piece' do
      game = Game.new
      target_coord = ' '
      player = game.player1
      piece =  Knight.new("W", "\u2658")
      move = "B1 C3"
      other_player = game.update_user(target_coord, player, piece, move)

      
      expect(game.player2).to eql(other_player[0])
    end

    it 'moves piece to empty spot for black piece' do
      game = Game.new
      target_coord = ' '
      player = game.player2
      piece =  Knight.new("B", "\u265E")
      move = "B8 C6"
      other_player = game.update_user(target_coord, player, piece, move)
      expect(game.player1).to eql(other_player[0])
    end

    it 'white captures black piece' do
      game = Game.new
      piece = Knight.new("W", "\u2658")
      game.change_piece_location('B1','D6', piece)
      target_coord = game.board.chess_board['F7']
      player = game.player1
      move = 'D6 F7'
      other_player = game.update_user(target_coord, player, piece, move)
      expect(game.player2).to eql(other_player[0])
    end

    it 'black captures white piece' do
      game = Game.new
      piece =  Knight.new("B", "\u265E")
      game.change_piece_location('B8','F3', piece)
      target_coord = game.board.chess_board['G1']
      player = game.player2
      move = 'F3 G1'
      other_player = game.update_user(target_coord, player, piece, move)
      expect(game.player1).to eql(other_player[0])
    end

    it 'white moves to a place with white already there' do
      game = Game.new 
      piece = Knight.new("W", "\u2658") 
      target_coord = game.board.chess_board['D2'] 
      player = game.player1
      move = 'B1 D2'
      other_player = game.update_user(target_coord, player, piece, move)
      expect(game.player1).to eql(other_player[0])
    end

    it 'black moves to a place with black already there' do
      game = Game.new 
      piece =  Knight.new("B", "\u265E")
      target_coord = game.board.chess_board['E7'] 
      player = game.player2
      move = 'G8 E7'
      other_player = game.update_user(target_coord, player, piece, move)
      expect(game.player2).to eql(other_player[0])
    end
      
  end

  describe '#check' do 
    it 'White moves for regular game state' do
      game = Game.new
      piece = Pawn.new("W", "\u2659")
      #game.board.chess_board['E7'] 
      game.check(game.board, game.player1, 'A2 A4', piece)
      expect(game.check(game.board, game.player1, 'A2 A4', piece)).to eql('regular')
    end

    it 'Black moves for regular game state' do

      game = Game.new
      piece = Pawn.new("B", "\u2659")
      game.check(game.board, game.player2, 'C7 C5', piece)
      expect(game.check(game.board, game.player2, 'C7 C5', piece)).to eql('regular')

    end
  end

  describe '#update_user' do
    it 'Returns checkmate fools mate' do 
      game = Game.new
      all_moves = ['F2 F3', 'E7 E5', 'G2 G4'] 
      game.make_all_these_moves(all_moves)
      target_coord = game.board.chess_board['H4']
      player = game.player2
      piece = game.board.chess_board['D8']
      move = 'D8 H4'
      puts "\n"
      puts "\n"
      puts "Fool's Mate"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      expect(game_state).to eql([player, 'mate'])
    end

    it 'Returns check almost fools mate' do 
      game = Game.new
      all_moves = ['F2 F3', 'E7 E5', 'A2 A4'] 
      game.make_all_these_moves(all_moves)
      target_coord = game.board.chess_board['H4']
      player = game.player2
      piece = game.board.chess_board['D8']
      move = 'D8 H4'
      puts "\n"
      puts "\n"
      puts "Almost Fool's Mate"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      expect(game_state).to eql([game.player1, 'check_other'])
    end

    it 'Returns checkmate fools mate' do 
      game = Game.new
      all_moves = ['E2 E4', 'F7 F6', 'D2 D4', 'G7 G5'] 
      game.make_all_these_moves(all_moves)
      target_coord = game.board.chess_board['H5']
      player = game.player1
      piece = game.board.chess_board['D1']
      move = 'D1 H5'
      puts "\n"
      puts "\n"
      puts "Reversed Fool's Mate"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([player, 'mate'])
    end

    it 'Returns check almost fools mate' do 
      game = Game.new
      all_moves = ['E2 E4', 'F7 F6', 'D2 D4', 'A7 A5']
      game.make_all_these_moves(all_moves)
      target_coord = game.board.chess_board['H5']
      player = game.player1
      piece = game.board.chess_board['D1']
      move = 'D1 H5'
      puts "\n"
      puts "\n"
      puts "Almmost reversed Fool's Mate"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([game.player2, 'check_other'])
    end

    it 'Returns checkmate scholars mate' do 
      game = Game.new
      all_moves = ['E2 E4', 'E7 E5', 'F1 C4', 'B8 C6', 'D1 H5', 'G8 F6'] 
      game.make_all_these_moves(all_moves)
      target_coord = game.board.chess_board['F7']
      player = game.player1
      piece = game.board.chess_board['H5']
      move = 'H5 F7'
      puts "\n"
      puts "\n"
      puts "Scholar's Mate"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([player, 'mate'])
    end

    it 'Returns check almost scholars mate' do 
      game = Game.new
      all_moves = ['E2 E4', 'E7 E5', 'A2 A4', 'B8 C6', 'D1 H5', 'G8 F6'] 
      game.make_all_these_moves(all_moves)
      target_coord = game.board.chess_board['F7']
      player = game.player1
      piece = game.board.chess_board['H5']
      move = 'H5 F7'
      puts "\n"
      puts "\n"
      puts "Almost Scholar's Mate"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([game.player2, 'check_other'])
    end

    it 'Returns checkmate Dutch defense' do 
      game = Game.new
      all_moves = ['D2 D4', 'F7 F5', 'C1 G5', 'H7 H6', 'G5 H4', 'G7 G5', 'E2 E4', 'G5 H4']
      game.make_all_these_moves(all_moves)
      target_coord = game.board.chess_board['H5']
      player = game.player1
      piece = game.board.chess_board['D1']
      move = 'D1 H5' 
      puts "\n"
      puts "\n"
      puts "Ducth Defense"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([player, 'mate'])
    end

    it 'Returns check almost Dutch defense' do 
      game = Game.new
      all_moves = ['D2 D4', 'F7 F5', 'C1 G5', 'H7 H6', 'G5 H4', 'G7 G5', 'E2 E4', 'H8 H7']
      game.make_all_these_moves(all_moves)
      target_coord = game.board.chess_board['H5']
      player = game.player1
      piece = game.board.chess_board['D1']
      move = 'D1 H5' 
      puts "\n"
      puts "\n"
      puts "Almost Ducth Defense"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([game.player2, 'check_other'])
    end

    it 'Returns check almost Dutch defense another variation' do 
      game = Game.new
      all_moves = ['D2 D4', 'F7 F5', 'C1 G5', 'H7 H6', 'G5 H4', 'G7 G5', 'E2 E4', 'H8 H7', 'D1 H5', 'H7 F7']
      game.make_all_these_moves(all_moves)
      target_coord = game.board.chess_board['F7']
      player = game.player1
      piece = game.board.chess_board['H5']
      move = 'H5 F7'
      puts "\n"
      puts "\n"
      puts "Almost Ducth Defense Another Variation"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([game.player2, 'check_other'])
    end

    it 'Returns checkmate smothered mate' do 
      game = Game.new
      all_moves = ['E2 E4', 'C7 C6', 'D2 D4', 'D7 D5', 'B1 C3', 'D5 E4', 'C3 E4', 'B8 D7', 'D1 E2', 'G8 F6']
      game.make_all_these_moves(all_moves)
      target_coord = game.board.chess_board['D6']
      player = game.player1
      piece = game.board.chess_board['E4']
      move = 'E4 D6'
      puts "\n"
      puts "\n"
      puts "smothered mate"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([player, 'mate'])
    end

    it 'Returns check almost smothered mate' do 
      game = Game.new
      all_moves = ['E2 E4', 'C7 C6', 'D2 D4', 'D7 D5', 'B1 C3', 'D5 E4', 'C3 E4', 'B8 D7', 'D1 D2', 'G8 F6']
      game.make_all_these_moves(all_moves)
      target_coord = game.board.chess_board['D6']
      player = game.player1
      piece = game.board.chess_board['E4']
      move = 'E4 D6'
      puts "\n"
      puts "\n"
      puts "smothered mate"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([game.player2, 'check_other'])
    end

    it 'Returns checkmate smothered mate part two' do 
      game = Game.new
      all_moves = ['D8 E4']
      game.board.chess_board['G2'] = ' '
      game.board.chess_board['G1'] = ' '
      game.board.chess_board['H1'] = ' '
      game.make_all_these_moves(all_moves)
      target_coord = game.board.chess_board['F3']
      player = game.player2
      piece = game.board.chess_board['B8']
      move = 'B8 F3'
      puts "\n"
      puts "\n"
      puts "smothered mate part two"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([player, 'mate'])
    end

    it 'Returns check almost smothered mate part two' do 
      game = Game.new
      all_moves = ['B8 D4']
      game.board.chess_board['G2'] = ' '
      game.board.chess_board['G1'] = ' '
      game.board.chess_board['H1'] = ' '
      game.make_all_these_moves(all_moves)
      target_coord = game.board.chess_board['E2']
      player = game.player2
      piece = game.board.chess_board['D8']
      move = 'D8 E2'
      puts "\n"
      puts "\n"
      puts "smothered mate almost part two"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([game.player1, 'check_other'])
    end

    it 'Returns checkmate back rank' do

      game = Game.new
      letters = [*('A'..'H')]
      numbers = [*('1'..'8')]
      numbers.reverse.each do |number|
        letters.each do |letter|
          coordinates = letter + number
          game.board.chess_board[coordinates] = ' '
        end
      end

      king_one = King.new("B", "\u265A")
      king_two = King.new("W", "\u2654")
      rook_one = Rook.new("W", "\u2656")
      rook_two = Rook.new("W", "\u2656")
      game.board.chess_board['A6'] = rook_one
      game.board.chess_board['B7'] = rook_two
      game.board.chess_board['H8'] = king_one
      game.board.chess_board['D1'] = king_two
      target_coord = game.board.chess_board['A8']
      player = game.player1
      piece = game.board.chess_board['A6']
      move = 'A6 A8'
      puts "\n"
      puts "\n"
      puts "back rank mate"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([player, 'mate'])
    end

    it 'Returns check back rank' do

      game = Game.new
      letters = [*('A'..'H')]
      numbers = [*('1'..'8')]
      numbers.reverse.each do |number|
        letters.each do |letter|
          coordinates = letter + number
          game.board.chess_board[coordinates] = ' '
        end
      end

      king_one = King.new("B", "\u265A")
      king_two = King.new("W", "\u2654")
      rook_one = Rook.new("W", "\u2656")
      rook_two = Rook.new("W", "\u2656")
      game.board.chess_board['A6'] = rook_one
      game.board.chess_board['B7'] = rook_two
      game.board.chess_board['H8'] = king_one
      game.board.chess_board['D1'] = king_two
      target_coord = game.board.chess_board['G8']
      player = game.player1
      piece = game.board.chess_board['A6']
      move = 'A6 G8'
      puts "\n"
      puts "\n"
      puts "back rank mate"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([game.player2, 'check_other'])
    end

    it 'Returns check back rank capture' do

      game = Game.new
      letters = [*('A'..'H')]
      numbers = [*('1'..'8')]
      numbers.reverse.each do |number|
        letters.each do |letter|
          coordinates = letter + number
          game.board.chess_board[coordinates] = ' '
        end
      end

      king_one = King.new("B", "\u265A")
      king_two = King.new("W", "\u2654")
      rook_one = Rook.new("W", "\u2656")
      rook_two = Rook.new("W", "\u2656")
      bishop = Bishop.new("B", "\u265D")
      game.board.chess_board['A6'] = rook_one
      game.board.chess_board['B7'] = rook_two
      game.board.chess_board['H8'] = king_one
      game.board.chess_board['D1'] = king_two
      game.board.chess_board['G8'] = bishop
      target_coord = game.board.chess_board['G8']
      player = game.player1
      piece = game.board.chess_board['A6']
      move = 'A6 G8'
      puts "\n"
      puts "\n"
      puts "back rank mate"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([game.player2, 'check_other'])
    end

    it 'Returns checkmate two pawn' do

      game = Game.new
      letters = [*('A'..'H')]
      numbers = [*('1'..'8')]
      numbers.reverse.each do |number|
        letters.each do |letter|
          coordinates = letter + number
          game.board.chess_board[coordinates] = ' '
        end
      end

      king_one = King.new("B", "\u265A")
      king_two = King.new("W", "\u2654")
      pawn_one = Pawn.new("W", "\u2659")
      pawn_one.first = false
      pawn_one.first_move = false
      pawn_two = Pawn.new("W", "\u2659")
      pawn_two.first = false
      pawn_two.first_move = false


      game.board.chess_board['D6'] = pawn_one
      game.board.chess_board['E8'] = king_one
      game.board.chess_board['E7'] = pawn_two
      game.board.chess_board['E6'] = king_two
      target_coord = game.board.chess_board['D7'] 
      player = game.player1
      piece = game.board.chess_board['D6']
      move = 'D6 D7'
      puts "\n"
      puts "\n"
      puts "back rank mate"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([player, 'mate'])
    end

    it 'Returns checkmate back rank two' do

      game = Game.new
      letters = [*('A'..'H')]
      numbers = [*('1'..'8')]
      numbers.reverse.each do |number|
        letters.each do |letter|
          coordinates = letter + number
          game.board.chess_board[coordinates] = ' '
        end
      end

      king_one = King.new("B", "\u265A")
      king_two = King.new("W", "\u2654")
      pawn_one = Pawn.new("B", "\u265F")
      pawn_one.first = false
      pawn_one.first_move = false
      pawn_two = Pawn.new("B", "\u265F")
      pawn_two.first = false
      pawn_two.first_move = false
      pawn_three = Pawn.new("B", "\u265F")
      pawn_three.first = false
      pawn_three.first_move = false
      rook = Rook.new("W", "\u2656")
      game.board.chess_board['G7'] = pawn_one
      game.board.chess_board['F7'] = pawn_two
      game.board.chess_board['H7'] = pawn_three
      game.board.chess_board['G8'] = king_one
      game.board.chess_board['G1'] = king_two
      game.board.chess_board['A1'] = rook
      target_coord = game.board.chess_board['A8'] 
      player = game.player1
      piece = game.board.chess_board['A1']
      move = 'A1 A8'
      puts "\n"
      puts "\n"
      puts "back rank mate two"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([player, 'mate'])
    end



    it 'Returns check back rank two' do

      game = Game.new
      letters = [*('A'..'H')]
      numbers = [*('1'..'8')]
      numbers.reverse.each do |number|
        letters.each do |letter|
          coordinates = letter + number
          game.board.chess_board[coordinates] = ' '
        end
      end

      king_one = King.new("B", "\u265A")
      king_two = King.new("W", "\u2654")
      pawn_one = Pawn.new("W", "\u2659")
      pawn_one.first = false
      pawn_one.first_move = false
      pawn_two = Pawn.new("W", "\u2659")
      pawn_two.first = false
      pawn_two.first_move = false
      pawn_three = Pawn.new("W", "\u2659")
      pawn_three.first = false
      pawn_three.first_move = false
      rook = Rook.new("W", "\u2656")
      game.board.chess_board['G7'] = pawn_one
      game.board.chess_board['F7'] = pawn_two
      game.board.chess_board['H7'] = pawn_three
      game.board.chess_board['G8'] = king_one
      game.board.chess_board['G1'] = king_two
      game.board.chess_board['A1'] = rook
      target_coord = game.board.chess_board['A8'] 
      player = game.player1
      piece = game.board.chess_board['A1']
      move = 'A1 A8'
      puts "\n"
      puts "\n"
      puts "back rank mate two"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([game.player2, 'check_other'])
    end


    it 'Returns mate diagonal attack' do

      game = Game.new
      letters = [*('A'..'H')]
      numbers = [*('1'..'8')]
      numbers.reverse.each do |number|
        letters.each do |letter|
          coordinates = letter + number
          game.board.chess_board[coordinates] = ' '
        end
      end

      king_one = King.new("B", "\u265A")
      king_two = King.new("W", "\u2654")
      pawn_one = Pawn.new("B", "\u265F")
      pawn_one.first = false
      pawn_one.first_move = false
      pawn_two = Pawn.new("B", "\u265F")
      pawn_two.first = false
      pawn_two.first_move = false
      pawn_three = Pawn.new("B", "\u265F")
      pawn_three.first = false
      pawn_three.first_move = false
      rook = Rook.new("B", "\u265C")
      queen = Queen.new("W", "\u2655")
      bishop = Bishop.new("W", "\u2657")
      game.board.chess_board['G7'] = pawn_one
      game.board.chess_board['F7'] = pawn_two
      game.board.chess_board['H7'] = pawn_three
      game.board.chess_board['G8'] = king_one
      game.board.chess_board['G1'] = king_two
      game.board.chess_board['F8'] = rook
      game.board.chess_board['B2'] = queen
      game.board.chess_board['A1'] = bishop
      target_coord = game.board.chess_board['G7'] 
      player = game.player1
      piece = game.board.chess_board['B2']
      move = 'B2 G7'
      puts "\n"
      puts "\n"
      puts "diagonal mate final"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([player, 'mate'])
    end

    it 'Returns check diagonal attack' do

      game = Game.new
      letters = [*('A'..'H')]
      numbers = [*('1'..'8')]
      numbers.reverse.each do |number|
        letters.each do |letter|
          coordinates = letter + number
          game.board.chess_board[coordinates] = ' '
        end
      end

      king_one = King.new("B", "\u265A")
      king_two = King.new("W", "\u2654")
      pawn_one = Pawn.new("B", "\u265F")
      pawn_one.first = false
      pawn_one.first_move = false
      pawn_two = Pawn.new("B", "\u265F")
      pawn_two.first = false
      pawn_two.first_move = false
      pawn_three = Pawn.new("B", "\u265F")
      pawn_three.first = false
      pawn_three.first_move = false
      rook = Rook.new("B", "\u265C")
      queen = Queen.new("W", "\u2655")
      
      game.board.chess_board['G7'] = pawn_one
      game.board.chess_board['F7'] = pawn_two
      game.board.chess_board['H7'] = pawn_three
      game.board.chess_board['G8'] = king_one
      game.board.chess_board['G1'] = king_two
      game.board.chess_board['F8'] = rook
      game.board.chess_board['B2'] = queen
      
      target_coord = game.board.chess_board['G7'] 
      player = game.player1
      piece = game.board.chess_board['B2']
      move = 'B2 G7'
      puts "\n"
      puts "\n"
      puts "diagonal check final"
      game_state = game.update_user(target_coord, player, piece, move)
      puts "\n"
      puts "\n"
      expect(game_state).to eql([game.player2, 'check_other'])
    end
    


  end


  #program update_user tests. Lots of them. Look at top ten most common checkmates and
  #program a test for each one
  #also get rid of any p or puts
  #describe update_user


end



