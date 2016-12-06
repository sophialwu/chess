module Chess
 
  # Represents the chess game
  class Game

    def initialize(player1="Player 1", player2="Player 2")
      @player1 = Player.new(player1, "white")
      @player2 = Player.new(player2, "black")
      @board = Board.new
      @turn = @player1
      @rows = ["1","2","3","4","5","6","7","8"]
      @columns = ["A","B","C","D","E","F","G","H"]
    end

    # Starts the game
    def play
      puts "\nWelcome to Chess!" +
           "\nPlayer 1, you are white.\nPlayer 2, you are black."

      until gameover?
        take_turn
      end

      puts @board

      winning_color = @turn.color == "black" ? "white" : "black"
      puts "\nCheckmate!\n#{@turn.name} (#{winning_color}) wins the game!"
    end

    # Allows a player to take a turn
    def take_turn
      puts "\n" + ("-" * 60)
      puts "#{@turn.name} (#{@turn.color}), it is your turn."
      puts @board

      output_if_checked

      from_position = player_choose_piece
      to_position = player_choose_move_piece(from_position)

      until @board.valid_move?(from_position[0], from_position[1],
                               to_position[0], to_position[1])
        puts "Not a valid move! Try another move.\n\n"
        from_position = player_choose_piece
        to_position = player_choose_move_piece(from_position)
      end

      @board.move_piece(from_position[0], from_position[1],
                        to_position[0], to_position[1])

      @turn = switch_player(@turn)
    end

    # Returns true if the game is over
    def gameover?
      @board.checkmate?(@turn.color) 
    end

    private

    # Prompts player to choose the location to move the chosen piece
    # and returns the location
    def player_choose_move_piece(from_position)
      puts "Where would you like to move your piece?"
      print ">> "
      to_position = convert_location(gets.chomp)
    end

    # Prompts player to choose a chess piece to move and returns
    # the location of the piece
    def player_choose_piece
      puts "What piece would you like to move?"
      print ">> "
      from_position = convert_location(gets.chomp)
      until @board.valid_player_piece?(@turn.color, from_position)
        puts "Not a valid piece! Try again."
        print ">> "
        from_position = convert_location(gets.chomp)
      end
      from_position
    end

    # Outputs if the king is in check or not
    def output_if_checked
      if @board.check?(@turn.color, @board.find_king(@turn.color).location)
        puts "Your king is in check."
      end
    end

    # Given a location ([A-H, 1-8]), converts to [0-7, 0-7]
    def convert_location(location)
      converted_location = [@rows.index(location[1]), 
                            @columns.index(location[0].upcase)]
    end

    # Switches the turn to player 1 or player 2
    def switch_player(turn)
      turn = turn == @player1 ? @player2 : @player1
    end

  end

end