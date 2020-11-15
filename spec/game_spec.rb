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

  end


  #program update_user tests. Lots of them. Look at top ten most common checkmates and
  #program a test for each one
  #also get rid of any p or puts
  #describe update_user


end



