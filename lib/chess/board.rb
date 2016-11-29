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

    # Moves the piece located at [from_row, from_column]
    # to the new location at [to_row, to_column]
    def move_piece(from_row, from_column, to_row, to_column)
      piece = @state[from_row][from_column]
      type = piece.class
      color = piece.color
      @state[to_row][to_column] = type.new(color, piece.location)
      @state[from_row][from_column] = nil
    end

    # Returns a stringifed version of the board
    def to_s
      board = "\n"
      background = [248,250,210]
      @state.reverse.each_with_index do |row, i|
        board += "#{(8 - i)} "
        row.each do |square|
          if square == nil
            board += Paint["   ", nil, background]
          else
            board += Paint[" #{square.symbol} ", nil, background]
          end
          background = switch_background(background)
        end
        board += "\n"
        background = switch_background(background)
      end
      board += "   a  b  c  d  e  f  g  h "
    end

    # Returns white when argument given is gray and 
    # returns gray when argument given is white
    def switch_background(color)
      color == [248,250,210] ? [215,188,149] : [248,250,210]
    end


    private

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
