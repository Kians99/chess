require './lib/pieces/piece'

describe Piece do
  describe "#translate_to_numerical" do
    it "returns algebraic notation to numerical" do
      piece = Piece.new("B", "\u2655")
      translation = piece.translate_to_numerical('A4')
      p translation
      expect(translation).to eql([1, 4])
    end

    it "returns algebraic notation to numerical" do
      piece = Piece.new("B", "\u2655")
      translation = piece.translate_to_numerical('H8')
      p translation
      expect(translation).to eql([8, 8])
    end

  end
end

