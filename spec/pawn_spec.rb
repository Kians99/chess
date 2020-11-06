require './lib/pieces/pawn'

describe Pawn do
  describe '#possible_moves' do
    it 'Returns possible moves for white pawn in opening position' do
      pawn = Pawn.new("W", "\u2659")
      player = Player.new("W", 1, 1)
      board = Board.new
      pos_moves = pawn.possible_moves([4,2], player, board)
      expect(pos_moves).to eql([[4,3],[4,4]])
    end

    it 'Returns possible moves for white pawn in non-opening position' do
      pawn = Pawn.new("W", "\u2659")
      pawn.first_move = false
      player = Player.new("W", 1, 1)
      board = Board.new
      pos_moves = pawn.possible_moves([4,4], player, board)
      expect(pos_moves).to eql([[4,5]])
    end

    it 'Returns possible moves for black pawn in opening position' do
      pawn = Pawn.new("B", "\u2659")
      player = Player.new("B", 2, -1)
      board = Board.new
      pos_moves = pawn.possible_moves([3,7], player, board)
      expect(pos_moves).to eql([[3,6],[3,5]])
    end

    it 'Returns possible moves for black pawn in non-opening position' do
      pawn = Pawn.new("B", "\u2659")
      pawn.first_move = false
      player = Player.new("B", 2, -1)
      board = Board.new
      pos_moves = pawn.possible_moves([3,6], player, board)
      expect(pos_moves).to eql([[3,5]])
    end

    it 'Returns possible moves for capturing another piece player 1' do
      pawn = Pawn.new("W", "\u2659")
      pawn.first_move = false
      player = Player.new("W", 1, 1)
      board = Board.new
      pos_moves = pawn.possible_moves([4,1], player, board)
      expect(pos_moves).to eql([[4,2], [5,2], [3,2]])
    end


    it 'Returns possible moves for capturing another piece player 2' do
      pawn = Pawn.new("B", "\u2659")
      pawn.first_move = false
      player = Player.new("B", 2, -1)
      board = Board.new
      pos_moves = pawn.possible_moves([6,8], player, board)
      expect(pos_moves).to eql([[6,7], [7,7], [5,7]])
    end

    it 'Returns possible moves for capturing another piece player 1 one side' do
      pawn = Pawn.new("W", "\u2659")
      pawn.first_move = false
      player = Player.new("W", 1, 1)
      board = Board.new
      piece = board.chess_board['C2']
      board.chess_board['C2'] = ' '
      board.chess_board['C3'] = piece
      pos_moves = pawn.possible_moves([4,2], player, board)
      expect(pos_moves).to eql([[4,3], [3,3]])
    end

    it 'Returns possible moves for capturing another piece player 2 one side' do
      pawn = Pawn.new("B", "\u2659")
      pawn.first_move = false
      player = Player.new("B", 2, -1)
      board = Board.new
      piece = board.chess_board['D7']
      board.chess_board['D7'] = ' '
      board.chess_board['D6'] = piece
      pos_moves = pawn.possible_moves([5,7], player, board)
      expect(pos_moves).to eql([[5,6], [4,6]])
    end

    #here

    it 'Returns possible moves including white passant to the right' do
      pawn = Pawn.new("W", "\u2659")
      pawn.first_move = false
      player = Player.new("W", 1, 1)
      board = Board.new
      piece = board.chess_board['E7']
      board.chess_board['E7'] = ' '
      board.chess_board['E5'] = piece
      pos_moves = pawn.possible_moves([4,5], player, board)
      expect(pos_moves).to eql([[4,6], [5,6]])
    end

    it 'Returns possible moves including white passant to the left' do
      pawn = Pawn.new("W", "\u2659")
      pawn.first_move = false
      player = Player.new("W", 1, 1)
      board = Board.new
      piece = board.chess_board['C7']
      board.chess_board['C7'] = ' '
      board.chess_board['C5'] = piece
      pos_moves = pawn.possible_moves([4,5], player, board)
      expect(pos_moves).to eql([[4,6], [3,6]])
    end

    it 'Returns possible moves including white passant to the left and right' do
      pawn = Pawn.new("W", "\u2659")
      pawn.first_move = false
      player = Player.new("W", 1, 1)
      board = Board.new
      piece = board.chess_board['A7']
      board.chess_board['A7'] = ' '
      board.chess_board['A5'] = piece
      piece2 = board.chess_board['C7']
      board.chess_board['C7'] = ' '
      board.chess_board['C5'] = piece2
      pos_moves = pawn.possible_moves([2,5], player, board)
      expect(pos_moves).to eql([[2,6], [3,6], [1,6]])
    end

    it 'Disallows white passant if no pawn next door' do
      pawn = Pawn.new("W", "\u2659")
      pawn.first_move = false
      player = Player.new("W", 1, 1)
      board = Board.new
      piece = board.chess_board['D8']
      board.chess_board['D8'] = ' '
      board.chess_board['A5'] = piece
      pos_moves = pawn.possible_moves([2,5], player, board)
      expect(pos_moves).to eql([[2,6]])
    end

    it 'Returns possible moves including black passant to the right' do
      pawn = Pawn.new("B", "\u2659")
      pawn.first_move = false
      player = Player.new("B", 2, -1)
      board = Board.new
      piece = board.chess_board['G2']
      board.chess_board['G2'] = ' '
      board.chess_board['G4'] = piece
      pos_moves = pawn.possible_moves([6,4], player, board)
      expect(pos_moves).to eql([[6,3], [7,3]])
    end

    it 'Returns possible moves including black passant to the left' do
      pawn = Pawn.new("B", "\u2659")
      pawn.first_move = false
      player = Player.new("B", 2, -1)
      board = Board.new
      piece = board.chess_board['E2']
      board.chess_board['E2'] = ' '
      board.chess_board['E4'] = piece
      pos_moves = pawn.possible_moves([6,4], player, board)
      expect(pos_moves).to eql([[6,3], [5,3]])
    end

    it 'Returns possible moves including black passant to the left and right' do
      pawn = Pawn.new("B", "\u2659")
      pawn.first_move = false
      player = Player.new("B", 2, -1)
      board = Board.new
      piece = board.chess_board['D2']
      board.chess_board['D2'] = ' '
      board.chess_board['D4'] = piece
      piece2 = board.chess_board['B2']
      board.chess_board['B2'] = ' '
      board.chess_board['B4'] = piece2
      pos_moves = pawn.possible_moves([3, 4], player, board)
      expect(pos_moves).to eql([[3, 3], [4, 3], [2,3]])
    end

    it 'Disallows black passant if no pawn next door' do
      pawn = Pawn.new("B", "\u2659")
      pawn.first_move = false
      player = Player.new("B", 2, -1)
      board = Board.new
      piece = board.chess_board['D1']
      board.chess_board['D1'] = ' '
      board.chess_board['D4'] = piece
      pos_moves = pawn.possible_moves([3, 4], player, board)
      expect(pos_moves).to eql([[3, 3]])
    end
    

  end
end

