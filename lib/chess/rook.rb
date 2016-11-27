module Chess
 
  # Represents the rook piece
  class Rook < Piece
    attr_accessor :moves

    def initialize(color, location)
      super
      @symbol = @color == "white" ? "\u{2656}" : "\u{265C}"
      @moves = possible_moves
    end

    # Returns an array with all moves the rook can make on the board,
    # assuming the board is empty
    def possible_moves
      moves = []
      row = location[0]
      column = location[1]
      moves += down_moves(row, column) + up_moves(row, column) +
               left_moves(row, column) + right_moves(row, column)
    end

    private

    # Returns an array of all down movements the rook can make
    def down_moves(row, column)
      moves = []
      row -= 1
      until row < 0
        moves << [row, column]
        row -= 1
      end
      moves
    end

    # Returns an array of all up movements the rook can make
    def up_moves(row, column)
      moves = []
      row += 1
      until row > 7
        moves << [row, column]
        row += 1
      end
      moves
    end

    # Returns an array of all left movements the rook can make
    def left_moves(row, column)
      moves = []
      column -= 1
      until column < 0
        moves << [row, column]
        column -= 1
      end
      moves
    end

    # Returns an array of all right movements the rook can make
    def right_moves(row, column)
      moves = []
      column += 1
      until column > 7
        moves << [row, column]
        column += 1
      end
      moves
    end

  end

end