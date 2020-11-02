require './lib/pieces/knight'

describe Rook do 
  describe '#pos_vertical_moves' do
    it 'Returns possible moves for white rook in opening position' do
      rook = Rook.new("W", "\u2656")
      board = Board.new
      pos_moves_pos = rook.pos_vertical_moves([1, 1], board, 1)
      pos_moves_neg = rook.pos_vertical_moves([1, 1], board, -1)
      total = pos_moves_pos + pos_moves_neg
      expect(total).to contain_exactly([1,2])
    end

    it 'Returns possible moves for black rook in opening position' do
      rook = Rook.new("B", "\u265C")
      board = Board.new
      pos_moves_pos = rook.pos_vertical_moves([1, 8], board, 1)
      pos_moves_neg = rook.pos_vertical_moves([1, 8], board, -1)
      total = pos_moves_pos + pos_moves_neg
      expect(total).to contain_exactly([1,7])
    end

    it 'Returns possible moves for white rook in non-opening position' do
      rook = Rook.new("W", "\u2656")
      board = Board.new
      pos_moves_pos = rook.pos_vertical_moves([7, 5], board, 1)
      pos_moves_neg = rook.pos_vertical_moves([7, 5], board, -1)
      total = pos_moves_pos + pos_moves_neg
      expect(total).to contain_exactly([7,6], [7,7], [7,4], [7,3], [7,2])
    end

    it 'Returns possible moves for black rook in non-opening position' do
      rook = Rook.new("B", "\u265C")
      board = Board.new
      pos_moves_pos = rook.pos_vertical_moves([3, 4], board, 1)
      pos_moves_neg = rook.pos_vertical_moves([3, 4], board, -1)
      total = pos_moves_pos + pos_moves_neg
      expect(total).to contain_exactly([3,5], [3,6], [3,7], [3,3], [3,2])
    end
    
  end



end
