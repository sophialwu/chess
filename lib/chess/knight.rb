module Chess
 
  # Represents the knight piece
  class Knight < Piece
    attr_accessor :moves
    attr_reader :symbol

    def initialize(color, location)
      super
      @symbol = @color == "white" ? "\u{2658}" : "\u{265E}"
      @moves = possible_moves
    end

    def possible_moves
      x, y = location
      moves = [[x - 2, y + 1], [x - 2, y - 1],
               [x - 1, y + 2], [x - 1, y - 2],
               [x + 1, y + 2], [x + 1, y - 2],
               [x + 2, y + 1], [x + 2, y - 1]]

      moves.select do |position| 
        position.all? { |value| value.between?(0,7) }
      end
    end

  end

end