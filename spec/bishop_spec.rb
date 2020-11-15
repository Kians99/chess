require './lib/pieces/bishop'

describe Bishop do
  describe '#pos_diagonal_moves' do
    it 'Returns possible moves for white bishop in opening position' do
      bishop = Bishop.new("W", "\u2657")
      board = Board.new
      expected_moves = bishop.pos_diagonal_moves([6,1], board)
      expect(expected_moves).to contain_exactly([7,2], [5,2])
    end

    it 'Returns possible moves for black bishop in opening position' do
      bishop = Bishop.new("B", "\u265D")
      board = Board.new
      expected_moves = bishop.pos_diagonal_moves([6, 8], board)
      expect(expected_moves).to contain_exactly([7,7], [5,7])
    end

    it 'Returns possible moves for white bishop in non-opening position' do
      bishop = Bishop.new("W", "\u2657")
      board = Board.new
      expected_moves = bishop.pos_diagonal_moves([5, 4], board)
      expect(expected_moves).to contain_exactly([6,5], [7,6], [8,7], [4,5], [3,6], [2,7], [6,3], [7,2], [4,3], [3,2])
    end

    it 'Returns possible moves for black bishop in non-opening position' do
      bishop = Bishop.new("B", "\u265D")
      board = Board.new
      expected_moves = bishop.pos_diagonal_moves([2, 5], board)
      expect(expected_moves).to contain_exactly([3,6], [4,7], [1,6], [1,4], [3,4], [4,3], [5,2])
    end

  end
end
