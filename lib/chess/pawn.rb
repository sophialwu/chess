module Chess
 
  # Represents the pawn piece
  class Pawn < Piece
    attr_accessor :moves, :moved

    def initialize(color, location)
      super
      @moves = possible_moves
      @moved = false
    end

    # Returns an array with all moves the pawn can make on the board,
    # assuming the board is empty
    def possible_moves
      row = @location[0]
      column = @location[1]
      unless row == 7
        if @color == "white"
          return white_pawn_moves(row, column)
        else
          return black_pawn_moves(row, column)
        end
      end
    end

    private

    # Returns the possible_moves for a white pawn
    def white_pawn_moves(row, column)
      moves = []
      moves << [row + 1, column]
      moves << [row + 2, column] unless @moved
      moves << [row + 1, column - 1] unless column == 0
      moves << [row + 1, column + 1] unless column == 7
      moves
    end

    # Returns the possible_moves for a black pawn
    def black_pawn_moves(row, column)
      moves = []
      moves << [row - 1, column]
      moves << [row - 2, column] unless @moved
      moves << [row - 1, column + 1] unless column == 7
      moves << [row - 1, column - 1] unless column == 0
      moves
    end

  end

end
