require './lib/pieces/knight'

describe Knight do
  describe '#possible_moves' do
    it 'Returns possible moves for white pawn in opening position' do
      knight = Knight.new("W", "\u2658")
      pos_moves = knight.possible_moves([7,1])
      expect(pos_moves).to contain_exactly([8,3], [6,3], [5,2])
    end

    it 'Returns possible moves for black pawn in opening position' do
      knight =  Knight.new("B", "\u265E")
      pos_moves = knight.possible_moves([2,8])
      expect(pos_moves).to contain_exactly([3,6], [1,6], [4,7])
    end

    it 'Returns possible moves for white pawn in non-opening position' do
      knight = Knight.new("W", "\u2658")
      pos_moves = knight.possible_moves([4,4])
      expect(pos_moves).to contain_exactly([5,6], [3,6], [2,5], [2,3], [6,5], [6,3], [5,2], [3,2])
    end

    it 'Returns possible moves for black pawn in non-opening position' do
      knight =  Knight.new("B", "\u265E")
      pos_moves = knight.possible_moves([7,6])
      expect(pos_moves).to contain_exactly([8,8], [6,8], [8,4], [6,4], [5,7], [5,5])
    end

  end
end
