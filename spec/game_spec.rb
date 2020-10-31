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



end