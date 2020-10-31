require './lib/game'

describe Game do
  describe "ensures proper coordinate input" do
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

  



  end
end