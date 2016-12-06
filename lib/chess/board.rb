module Chess
  # TODO: 
  # => Castling functionality
  # => Ability to move piece in between king and checking piece to avoid
  #    check (only if checking piece is a bishop, rook, or queen)
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
      new_location = [to_row, to_column]
      @state[to_row][to_column] = piece.class.new(piece.color, new_location)
      @state[from_row][from_column] = nil
      
      moved_piece = @state[to_row][to_column]
      if moved_piece.class == Pawn
        special_pawn_rules(moved_piece, from_row, to_column)
      end
                                           # Once a move has been made, disallow
      disallow_all_en_passant(piece.color) # taking en_passant on enemy pawns     
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

      return pawn_valid_move?(piece, new_location, to_column, from_column) if
             piece.class == Pawn

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

    # Returns true if for a given color and location, the location is
    # on the board and contains a piece of the color
    def valid_player_piece?(color, location)
      return false unless location.all? { |c| c.between?(0,7) }
      potential_piece = @state[location[0]][location[1]]
      potential_piece != nil && potential_piece.color == color
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

    # Helper function to move_piece that accounts for special pawn
    # rules such as en passant, promotion, and moved/not moved
    def special_pawn_rules(moved_piece, from_row, to_column)
      if en_passant_allowed?(moved_piece, from_row)
          moved_piece.allow_en_passant = true
      end

      if valid_en_passant_move?(moved_piece.color, from_row, to_column)
        @state[from_row][to_column] = nil
      end

      if promotion?(moved_piece)
        moved_piece.can_promote = true
      end

      moved_piece.moved = true
    end

    # Returns true if the pawn can be promoted
    def promotion?(pawn)
      pawn.location[0] == 0 || pawn.location[0] == 7
      # Don't need to separate by color as pawns can only move in 1 direction
    end

    # Returns true if the color pawn is making a valid en passant move
    def valid_en_passant_move?(color, from_row, to_column)
      possible_pawn = @state[from_row][to_column]

      possible_pawn.class == Pawn && possible_pawn.color != color &&
      possible_pawn.allow_en_passant == true
    end

    # Returns true if en passant is allowed on a recently moved pawn
    def en_passant_allowed?(pawn, from_row)
      return false if pawn.moved == true || 
                      (pawn.location[0] - from_row).abs != 2
      [pawn.location[1] - 1, pawn.location[1] + 1].any? do |column|
        return false unless column.between?(0,7)
        possible_pawn = @state[pawn.location[0]][column]
        possible_pawn.class == Pawn && possible_pawn.color != pawn.color
      end
    end

    # Given a color, sets @allow_en_passant to be 
    # false for all pawns of the opposing enemy color
    def disallow_all_en_passant(color)
      enemy_color = color == "black" ? "white" : "black"
      pawns_of_color = chess_pieces.select do |piece|
        piece.class == Pawn && piece.color == enemy_color
      end
      pawns_of_color.each { |pawn| pawn.allow_en_passant = false }
    end

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

    # Given a location of a piece and the set of possible moves, returns
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

    # Helper function for #valid_move? that returns true if the
    # move the pawn is trying to make is true or false on the board state
    def pawn_valid_move?(pawn, new_location, to_column, from_column)
      if to_column == from_column
        if (new_location[0] - pawn.location[0]).abs == 2
          return false if pawn.moved == true
        end
        empty_location?(new_location)
      else
        if enemy_piece_at_location?(pawn.color, new_location)
          true
        else
          valid_en_passant_move?(pawn.color, pawn.location[0], to_column)
        end
      end
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
