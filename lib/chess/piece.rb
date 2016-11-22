module Chess
 
  # Represents a single chess piece on the chess board
  class Piece
    attr_accessor :location
    attr_reader :color

    def initialize(color, location)
      @color = color
      @location = location
    end

  end

end
