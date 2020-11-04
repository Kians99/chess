require './lib/pieces/king'

describe King do
  describe '#possible_moves' do
    it 'Returns possible moves for white king in opening position' do
      king = King.new("W", "\u2654")
      expected_moves = king.possible_moves([5,1])
      expect(expected_moves).to contain_exactly([6,1], [6,2], [5,2], [4,2], [4,1])
    end

    it 'Returns possible moves for black king in opening position' do
      king = King.new("B", "\u265A")
      expected_moves = king.possible_moves([5,8])
      expect(expected_moves).to contain_exactly([6,8], [6,7], [5,7], [4,8], [4,7])
    end

    it 'Returns possible moves for white king in non-opening position' do
      king = King.new("W", "\u2654")
      expected_moves = king.possible_moves([6,5])
      expect(expected_moves).to contain_exactly([6,6], [7,6], [5,6], [7,5], [5,5], [6,4], [5,4], [7,4])
    end

    it 'Returns possible moves for black king in non-opening position' do
      king = King.new("B", "\u265A")
      expected_moves = king.possible_moves([1,4])
      expect(expected_moves).to contain_exactly([1,5], [1,3], [2,5], [2,3], [2,4])
    end

  end


end

