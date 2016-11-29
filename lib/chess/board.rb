module Chess
 
  # Represents the chess board
  class Board
    attr_reader :state

    def initialize
      @state = new_board
    end

    # Returns an 8x8 array filled with nil by default and chess pieces
    # if the space should start with a chess piece
    def new_board
      board = []
      8.times do |row|
        board << case row
        when 0
          add_back_row("white", row)
        when 1
          add_pawn_row("white", row)
        when 6
          add_pawn_row("black", row)
        when 7
          add_back_row("black", row)
        else
          Array.new(8)
        end
      end 
      board
    end

    # Returns a row of pawns as an array
    def add_pawn_row(color, row)
      pawn_row = []
      8.times { |column| pawn_row << Pawn.new(color, [row, column]) }
      pawn_row
    end

    # Returns the initial back row of the board as an array
    def add_back_row(color, row)
      backrow = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
      backrow.map.with_index { |piece, column| piece.new(color, [row, column]) }
    end

  end

end
