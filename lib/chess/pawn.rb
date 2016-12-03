module Chess
 
  # Represents the pawn piece
  class Pawn < Piece
    attr_accessor :moves, :moved, :allow_en_passant
    attr_reader :symbol

    def initialize(color, location)
      super
      @symbol = @color == "white" ? "\u{2659}" : "\u{265F}"
      @moves = possible_moves
      @moved = false
      @allow_en_passant = false
    end

    # Returns an array with all moves the pawn can make on the board,
    # assuming the board is empty
    def possible_moves
      row = @location[0]
      column = @location[1]
      moves = []
      unless row == 7
        if @color == "white"
          moves = white_pawn_moves(row, column)
        else
          moves = black_pawn_moves(row, column)
        end
      end
      moves.select do |position|
        position.all? { |value| value.between?(0,7) }
      end
    end

    private

    # Returns the possible_moves for a white pawn
    def white_pawn_moves(row, column)
      moves = []
      moves << [row + 1, column]
      moves << [row + 2, column] unless @moved
      moves << [row + 1, column - 1]
      moves << [row + 1, column + 1]
      moves
    end

    # Returns the possible_moves for a black pawn
    def black_pawn_moves(row, column)
      moves = []
      moves << [row - 1, column]
      moves << [row - 2, column] unless @moved
      moves << [row - 1, column + 1]
      moves << [row - 1, column - 1]
      moves
    end

  end

end
