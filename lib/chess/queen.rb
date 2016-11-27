module Chess
 
  # Represents the queen piece
  class Queen < Piece
    attr_accessor :moves

    def initialize(color, location)
      super
      @symbol = @color == "white" ? "\u{2655}" : "\u{265B}"
      @moves = possible_moves
    end

    def possible_moves
      bishop = Bishop.new(@color, @location)
      rook = Rook.new(@color, @location)
      rook.moves + bishop.moves
    end

  end

end