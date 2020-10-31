require './lib/pieces/pawn'

describe Pawn do
  describe '#possible_moves' do
    it 'Returns possible moves for white pawn in opening position' do
      pawn = Pawn.new("W", "\u2659")
      player = Player.new("W", 1, 1)
      pos_moves = pawn.possible_moves([4,2], player)
      expect(pos_moves).to eql([[4,3],[4,4]])
    end

    it 'Returns possible moves for white pawn in non-opening position' do
      pawn = Pawn.new("W", "\u2659")
      player = Player.new("W", 1, 1)
      pos_moves = pawn.possible_moves([4,4], player)
      expect(pos_moves).to eql([[4,5]])
    end

    it 'Returns possible moves for black pawn in opening position' do
      pawn = Pawn.new("B", "\u2659")
      player = Player.new("B", 2, -1)
      pos_moves = pawn.possible_moves([3,7], player)
      expect(pos_moves).to eql([[3,6],[3,5]])
    end

    it 'Returns possible moves for black pawn in non-opening position' do
      pawn = Pawn.new("B", "\u2659")
      player = Player.new("B", 2, -1)
      pos_moves = pawn.possible_moves([3,6], player)
      expect(pos_moves).to eql([[3,5]])
    end


  end
end

