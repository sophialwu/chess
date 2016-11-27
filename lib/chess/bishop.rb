module Chess
 
  # Represents the bishop piece
  class Bishop < Piece
    attr_accessor :moves
    attr_reader :symbol

    def initialize(color, location)
      super
      @symbol = @color == "white" ? "\u{2657}" : "\u{265D}"
      @moves = possible_moves
    end

    # Returns an array with all moves the bishop can make on the board,
    # assuming the board is empty
    def possible_moves
      moves = []
      row = location[0]
      column = location[1]
      moves += northwest_moves(row, column) + northeast_moves(row, column) +
               southwest_moves(row, column) + southeast_moves(row, column)
    end

    private

    # Returns an array of northwest diagonal moves the bishop can make
    def northwest_moves(row, column)
      moves = []
      row += 1
      column -= 1
      until row > 7 || column < 0
        moves << [row, column]
        row += 1
        column -= 1
      end
      moves
    end

   # Returns an array of northeast diagonal moves the bishop can make
    def northeast_moves(row, column)
      moves = []
      row += 1
      column += 1
      until row > 7 || column > 7
        moves << [row, column]
        row += 1
        column += 1
      end
      moves
    end

    # Returns an array of southwest diagonal moves the bishop can make
    def southwest_moves(row, column)
      moves = []
      row -= 1
      column -= 1
      until row < 0 || column < 0
        moves << [row, column]
        row -= 1
        column -= 1
      end
      moves
    end

    # Returns an array of southeast diagonal moves the bishop can make
    def southeast_moves(row, column)
      moves = []
      row -= 1
      column += 1
      until row < 0 || column > 7
        moves << [row, column]
        row -= 1
        column += 1
      end
      moves
    end

  end

end