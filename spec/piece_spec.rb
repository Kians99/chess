require './lib/pieces/piece'

describe Piece do
  describe "#translate_to_numerical" do
    it "returns algebraic notation to numerical" do
      translation = Piece.translate_to_numerical('A4')
      p translation
      expect(translation).to eql([1, 4])
    end

    it "returns algebraic notation to numerical" do
      translation = Piece.translate_to_numerical('H8')
      p translation
      expect(translation).to eql([8, 8])
    end

    it "returns numerical to algebraic notation" do
      translation = Piece.translate_to_algebraic([8,8])
      expect(translation).to eql('H8')
    end

    it "returns numerical to algebraic notation" do 
      translation = Piece.translate_to_algebraic([2,5])
      expect(translation).to eql('B5')
    end
  end
end

