module Chess
 
  # Represents a single player in the chess game 
  class Player
    attr_reader :name, :color

    def initialize(name, color)
      @name = name
      @color = color
    end

  end

end
