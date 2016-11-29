module Chess
 
  # Represents the chess board
  class Board
    attr_reader :state

    def initialize
      @state = new_board
    end

    # Returns an 8x8 array filled with the default chess board pieces and
    # nil if the square is empty
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
      piece.moved = true if type == Pawn # No longer can move 2 spaces
      @state[to_row][to_column] = type.new(color, piece.location)
      @state[from_row][from_column] = nil
    end

    # Returns true if the move is valid (given a from and to location)
    # => The starting position of the move is an actual piece (not empty square)
    # => The move is valid for that piece type
    # => No pieces on path between starting and new location
    # => Piece is moving to a location that is empty or occupied by the enemy
    def valid_move?(from_row, from_column, to_row, to_column)
      piece = @state[from_row][from_column]
      return false if piece == nil

      new_location = [to_row, to_column]
      return false unless piece.possible_moves.include? new_location

      if piece.class == Pawn && to_column != from_column
        return enemy_piece_at_location?(piece.color, new_location)
      end

      return false unless empty_location?([to_row, to_column]) || 
                          enemy_piece_at_location?(piece.color, new_location)

      unless piece.class == Knight || piece.class == King
        return no_pieces_in_between?(from_row, from_column, to_row, to_column)
      end

      true
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

    # Given two points on the board, returns true if there are no
    # pieces in between and false otherwise
    def no_pieces_in_between?(from_row, from_column, to_row, to_column)
      if from_row == to_row
        column = from_column < to_column ? from_column : to_column
        ending_column = column == from_column ? to_column : from_column
        column += 1
        until column == ending_column
          return false unless @state[from_row][column] == nil
          column += 1
        end
        true
      elsif from_column == to_column
        row = from_row < to_row ? from_row : to_row
        ending_row = row == from_row ? to_row : from_row
        row += 1
        until row == ending_row
          return false unless @state[row][from_column] == nil
          row += 1
        end
        true
      else
        no_pieces_in_between_diagonal?(from_row, from_column, to_row, to_column)
      end
    end

    # Given two points on the board that form a diagonal, returns true
    # if there are no pieces in between and false otherwise 
    def no_pieces_in_between_diagonal?(from_row, from_column, to_row, to_column)
      row = from_row
      column = from_column
      if to_row > from_row && to_column > from_column
        row += 1
        column += 1
        until row == to_row
          return false unless @state[row][column] == nil
          row += 1
          column += 1
        end
      elsif to_row > from_row && to_column <= from_column
        row += 1
        column += 1
        until row == to_row
          return false unless @state[row][column] == nil
          row += 1
          column -= 1
        end
      elsif to_row <= from_row && to_column <= from_column
        row -= 1
        column -= 1
        until row == to_row
          return false unless @state[row][column] == nil
          row -= 1
          column -= 1
        end
      elsif to_row <= from_row && to_column > from_column
        row -= 1
        column += 1
        until row == to_row
          return false unless @state[row][column] == nil
          row -= 1
          column += 1
        end
      end
      true
    end

    # Returns true if the location is empty
    def empty_location?(location)
      return @state[location[0]][location[1]] == nil
    end

    # Given your color piece and a location to move, 
    # returns true if there is an enemy piece at that location
    def enemy_piece_at_location?(color, location)
      return false if @state[location[0]][location[1]] == nil
      @state[location[0]][location[1]].color != color
    end

    # Returns white when argument given is gray and 
    # returns gray when argument given is white
    def switch_background(color)
      color == [248,250,210] ? [215,188,149] : [248,250,210]
    end

  end

end
