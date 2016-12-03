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
      return false unless piece.moves.include? new_location

      if piece.class == Pawn
        if to_column == from_column
          return empty_location?([to_row, to_column])
        else
          return enemy_piece_at_location?(piece.color, new_location)
        end
      end

      return false unless empty_location?([to_row, to_column]) || 
                          enemy_piece_at_location?(piece.color, new_location)

      unless piece.class == Knight || piece.class == King
        return no_pieces_in_between?(from_row, from_column, to_row, to_column)
      end

      true
    end

    # Given the color, returns that color's king that is on the board
    def find_king(color)
      king = chess_pieces.select do |piece| 
        piece.class == King && piece.color == color
      end[0]
    end

    # Given a color and location of the color's king,  
    # returns true if the king is checked
    def check?(color, king_location)
      !pieces_checking_king(color, king_location).empty?
    end

    # Given a color, returns true if the color's king is checkmated
    def checkmate?(color)
      king = find_king(color)
      return false unless check?(color, king.location)

      checking_pieces = pieces_checking_king(color, king.location)
      if checking_pieces.length == 1
        return false if escape_checkmate_by_kill?(color, checking_pieces[0])
      end
      
      moves = all_valid_moves(king.location, king.moves)

      moves.all? do |move|
        current_state = Marshal.load(Marshal.dump(@state))
        @state[king.location[0]][king.location[1]] = nil # To test out the
        @state[move[0]][move[1]] = King.new(color, move) # king's move

        in_check = check?(color, move)
        @state = current_state # Set state back to actual current state

        in_check
      end
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

    # Returns true if given a color and enemy piece that is checking the
    # king, a friendly piece can kill the enemy piece, removing the check
    def escape_checkmate_by_kill?(color, checking_piece)
      friendly_pieces = chess_pieces.select { |piece| piece.color == color }
      friendly_pieces.any? do |piece|
        return false if piece.class == King
        valid_moves = all_valid_moves(piece.location, piece.moves)
        valid_moves.include? checking_piece.location
      end
    end

    # Returns an array of any pieces that are checking the given color's king
    def pieces_checking_king(color, king_location)
      enemy_pieces(color).select do |piece|
        valid_move?(piece.location[0], piece.location[1], 
                    king_location[0], king_location[1])
      end
    end

    # Given a color, returns all the enemy pieces (not the given color)
    def enemy_pieces(color)
      chess_pieces.select { |piece| piece.color != color }
    end

    # Given a location of a piece and it set of possible moves, returns
    # an array of all valid moves for that piece given the board state
    def all_valid_moves(location, moves)
      moves.select do |move|
        valid_move?(location[0], location[1], move[0], move[1])
      end
    end

    # Returns an array of all the chess pieces currently on the board
    def chess_pieces
      pieces = @state.map do |row|
        row.select { |piece| piece != nil }
      end.flatten
    end

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
        column -= 1
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
