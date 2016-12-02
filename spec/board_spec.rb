require "spec_helper"

module Chess
  describe Board do

    describe "#initialize" do
      it "does not raise an error when initialized without arguments" do
        expect{ Board.new }.to_not raise_error
      end

      it "does raise an error when initialized with arguments" do
        expect{ Board.new("blah") }.to raise_error(ArgumentError)
      end

      let(:board) { Board.new }
      
      it "initializes an 8x8 array with chess pieces in the right places" do
        expect(board.state.size).to eql(8)
        expect(board.state.all? { |row| row.size == 8 }).to eql(true)
        expect(board.state[0][0].class).to eql(Rook)
        expect(board.state[0][1].class).to eql(Knight)
        expect(board.state[0][2].class).to eql(Bishop)
        expect(board.state[0][3].class).to eql(Queen)
        expect(board.state[0][4].class).to eql(King)
        expect(board.state[0][5].class).to eql(Bishop)
        expect(board.state[0][6].class).to eql(Knight)
        expect(board.state[0][7].class).to eql(Rook)
        expect(board.state[7][0].class).to eql(Rook)
        expect(board.state[7][1].class).to eql(Knight)
        expect(board.state[7][2].class).to eql(Bishop)
        expect(board.state[7][3].class).to eql(Queen)
        expect(board.state[7][4].class).to eql(King)
        expect(board.state[7][5].class).to eql(Bishop)
        expect(board.state[7][6].class).to eql(Knight)
        expect(board.state[7][7].class).to eql(Rook)
        expect(board.state[1].all? { |piece| piece.class == Pawn }).to eql(true)
        expect(board.state[6].all? { |piece| piece.class == Pawn }).to eql(true)
        expect(2.upto(5).all? do |row| 
                 board.state[row].all? { |square| square == nil }
               end).to eql(true)
      end
    end

    describe "#move_piece" do
      let(:board) { Board.new }

      context "given a white rook moving from location [0,0] to [4,0] on a "\
              "starting board" do
        it "moves the white rook to location [4,0]" do
          board.move_piece(0,0,4,0)
          expect(board.state[0][0]).to eql(nil)
          expect(board.state[4][0].class).to eql(Rook)
          expect(board.state[4][0].color).to eql("white")
        end
      end

      context "given a black knight moving from location [7,6] to [5,7] on a "\
              "starting board" do
        it "moves the black knight to location [5,7]" do
          board.move_piece(7,6,5,7)
          expect(board.state[7][6]).to eql(nil)
          expect(board.state[5][7].class).to eql(Knight)
          expect(board.state[5][7].color).to eql("black")
        end
      end

      context "given a black queen moving from location [7,3] to [1,3], where "\
              "a white pawn is located" do
        it "moves the black queen to location [1,3] and captures the "\
           "white pawn" do
          board.move_piece(7,6,5,7)
          expect(board.state[7][6]).to eql(nil)
          expect(board.state[5][7].class).to eql(Knight)
          expect(board.state[5][7].color).to eql("black")
        end
      end

      context "given a white pawn moving from location [1,7] to [3,7], on a "\
              "starting board" do
        it "moves the white pawn to location [3,7]" do
          board.move_piece(1,7,3,7)
          expect(board.state[1][7]).to eql(nil)
          expect(board.state[3][7].class).to eql(Pawn)
          expect(board.state[3][7].color).to eql("white")
        end
      end

    end

    describe "#valid_move?" do
      let(:board) { Board.new }

      context "given a white pawn moving from location [1,0] to [2,0] on a "\
              "starting board" do
        it "returns true" do
          expect(board.valid_move?(1,0,2,0)).to eql(true)
        end
      end

      context "given a white pawn moving from location [1,0] to [3,0] on a "\
              "starting board" do
        it "returns true" do
          expect(board.valid_move?(1,0,3,0)).to eql(true)
        end
      end

      context "given a black pawn moving from location [6,5] to [5,5] on a "\
              "starting board" do
        it "returns true" do
          expect(board.valid_move?(6,5,5,5)).to eql(true)
        end
      end

      context "given a black pawn moving from location [6,5] to [5,4] on a "\
              "starting board" do
        it "returns false" do
          expect(board.valid_move?(6,5,5,4)).to eql(false)
        end
      end

      context "given a black pawn moving from location [6,5] to [5,4] to "\
              "capture a white pawn" do
        it "returns true" do
          board.state[5][4] = Pawn.new("white", [5,4])
          expect(board.valid_move?(6,5,5,4)).to eql(true)
        end
      end

      context "given a white pawn moving from location [2,3] to [4,3] after "\
              "it has already moved already" do
        it "returns false" do
          board.move_piece(1,3,2,3)
          expect(board.valid_move?(2,3,4,3)).to eql(false)
        end
      end

      context "given a white rook moving from location [0,0] to [1,0], where "\
              "there is a white pawn" do
        it "returns false" do
          expect(board.valid_move?(0,0,1,0)).to eql(false)
        end
      end

      context "given a white rook moving from location [0,0] to [4,0], where "\
              "there is a white pawn in between" do
        it "returns false" do
          expect(board.valid_move?(0,0,4,0)).to eql(false)
        end
      end

      context "given a white rook moving from location [0,0] to [1,0], where "\
              "the new location is empty" do
        it "returns true" do
          board.state[1][0] = nil
          expect(board.valid_move?(0,0,1,0)).to eql(true)
        end
      end

      context "given a white rook moving from location [0,0] to [4,0], where "\
              "there are no pieces in between" do
        it "returns true" do
          board.state[1][0] = nil
          expect(board.valid_move?(0,0,4,0)).to eql(true)
        end
      end

      context "given a black knight moving from location [7,1] to [5,2] "\
              "on a starting board" do
        it "returns true" do
          expect(board.valid_move?(7,1,5,2)).to eql(true)
        end
      end

      context "given a black knight moving from location [7,1] to [6,3] "\
              "on a starting board" do
        it "returns false" do
          expect(board.valid_move?(7,1,6,3)).to eql(false)
        end
      end

      context "given a white bishop moving from location [0,5] to [2,7], "\
              "where this is a with pawn in between" do
        it "returns false" do
          expect(board.valid_move?(0,5,2,7)).to eql(false)
        end
      end

      context "given a white bishop moving from location [0,5] to [2,7] "\
              "with no pieces in between" do
        it "returns true" do
          board.state[1][6] = nil
          expect(board.valid_move?(0,5,2,7)).to eql(true)
        end
      end

      context "given a white queen moving from location [3,3] to [6,3] "\
              "to capture a black pawn" do
        it "returns true" do
          board.state[3][3] = Queen.new("white", [3,3])
          expect(board.valid_move?(3,3,6,3)).to eql(true)
        end
      end

      context "given a black queen moving from location [3,3] to [6,3], "\
              "where there is a black pawn" do
        it "returns false" do
          board.state[3][3] = Queen.new("black", [3,3])
          expect(board.valid_move?(3,3,6,3)).to eql(false)
        end
      end

      context "given a white king moving from location [3,3] to [5,3], "\
              "with no pieces in between" do
        it "returns false" do
          board.state[3][3] = King.new("white", [3,3])
          expect(board.valid_move?(3,3,5,3)).to eql(false)
        end
      end

      context "given a white king moving from location [3,3] to [4,3], "\
              "with no pieces in between" do
        it "returns true" do
          board.state[3][3] = King.new("white", [3,3])
          expect(board.valid_move?(3,3,4,3)).to eql(true)
        end
      end

    end

    describe "#check?" do
      let(:board) { Board.new }

      context "given a black king on a starting board" do
        it "returns false" do
          king_location = board.find_king("black").location
          expect(board.check?("black", king_location)).to eql(false)
        end
      end

      context "given a white king at [0,4] with an unobstructed path to "\
              "black queen at [4,4]" do
        it "returns true" do
          board.state[1][4] = nil
          board.state[4][4] = Queen.new("black", [4,4])
          king_location = board.find_king("white").location
          expect(board.check?("white", king_location)).to eql(true)
        end
      end

      context "given a white king at [0,4] with an obstructed path to "\
              "black queen at [4,4]" do
        it "returns false" do
          board.state[4][4] = Queen.new("black", [4,4])
          king_location = board.find_king("white").location
          expect(board.check?("white", king_location)).to eql(false)
        end
      end

      context "given a black king at [3,7] with an unobstructed path to "\
              "white rook at [3,2]" do
        it "returns true" do
          board.state[7][4] = nil
          board.state[3][7] = King.new("black", [3,7])
          board.state[3][2] = Rook.new("white", [3,2])
          king_location = board.find_king("black").location
          expect(board.check?("black", king_location)).to eql(true)
        end
      end

      context "given a white king at [5,6] with unobstructed paths to "\
              "black pawns at [6,5] and [6,7]" do
        it "returns true" do
          board.state[0][4] = nil
          board.state[5][6] = King.new("white", [5,6])
          king_location = board.find_king("white").location
          expect(board.check?("white", king_location)).to eql(true)
        end
      end

      context "given a white king at [3,4] with an unobstructed path to "\
              "black knight at [5,3]" do
        it "returns true" do
          board.state[0][4] = nil
          board.state[3][4] = King.new("white", [3,4])
          board.state[5][3] = Knight.new("black", [5,3])
          king_location = board.find_king("white").location
          expect(board.check?("white", king_location)).to eql(true)
        end
      end

      context "given a black king at [4,1] with an unobstructed path to "\
              "white king at [4,2]" do
        it "returns true" do
          board.state[7][4] = nil
          board.state[0][4] = nil
          board.state[4][1] = King.new("black", [4,1])
          board.state[4][2] = King.new("white", [4,2])
          king_location = board.find_king("black").location
          expect(board.check?("black", king_location)).to eql(true)
        end
      end

    end

    describe "#checkmate?" do
      let(:board) { Board.new }

      context "given a white king on a starting board" do
        it "returns false" do
          expect(board.checkmate?("white")).to eql(false)
        end
      end

      context "given a white king at [0,4] in check by a "\
              "black queen at [4,4], but not checkmate" do
        it "returns false" do
          board.state[1][4] = nil
          board.state[4][4] = Queen.new("black", [4,4])
          board.state[1][3] = nil
          expect(board.checkmate?("white")).to eql(false)
        end
      end

      context "given a black king at [4,1] in check by a "\
              "white king at [4,2], but not checkmate" do
        it "returns false" do
          board.state[7][4] = nil
          board.state[0][4] = nil
          board.state[4][1] = King.new("black", [4,1])
          board.state[4][2] = King.new("white", [4,2])
          expect(board.checkmate?("black")).to eql(false)
        end
      end

      context "given a black king at [3,7] in check by a "\
              "white rook at [3,2], but not checkmate" do
        it "returns false" do
          board.state[7][4] = nil
          board.state[3][7] = King.new("black", [3,7])
          board.state[3][2] = Rook.new("white", [3,2])
          expect(board.checkmate?("black")).to eql(false)
        end
      end

      context "given a black king at [7,7] in check by a "\
              "white rook at [7,1], and checkmated" do
        it "returns true" do
          board.instance_variable_set(:@state, board.state.map do |row|
            row.map { |square| nil }
          end)
          board.state[7][7] = King.new("black", [7,7])
          board.state[7][1] = Rook.new("white", [7,1])
          board.state[6][0] = Rook.new("white", [6,0])
          expect(board.checkmate?("black")).to eql(true)
        end
      end

      context "given a black king at [7,4] in check by a "\
              "white pawn at [6,3], and checkmated" do
        it "returns true" do
          board.instance_variable_set(:@state, board.state.map do |row|
            row.map { |square| nil }
          end)
          board.state[7][4] = King.new("black", [7,4])
          board.state[6][3] = Pawn.new("white", [6,3])
          board.state[6][4] = Pawn.new("white", [6,4])
          board.state[5][4] = King.new("white", [5,4])
          expect(board.checkmate?("black")).to eql(true)
        end
      end

      context "given a white king at [0,4] in check by a "\
              "black knight at [2,5], and checkmated" do
        it "returns true" do
          board.state[0][6] = nil
          board.state[1][4] = Knight.new("white", [1,4])
          board.state[1][6] = nil
          board.state[2][5] = Knight.new("black", [2,5])
          expect(board.checkmate?("white")).to eql(true)
        end
      end

      context "given a black king at [6,4] in check by a "\
              "white bishop at [4,2], and checkmated" do
        it "returns true" do
          board.instance_variable_set(:@state, board.state.map do |row|
            row.map { |square| nil }
          end)
          board.state[6][4] = King.new("black", [6,4])
          board.state[6][5] = Bishop.new("white", [6,5])
          board.state[7][5] = Bishop.new("black", [7,5])
          board.state[4][2] = Bishop.new("white", [4,2])
          board.state[4][4] = Knight.new("white", [4,4])
          board.state[4][3] = Knight.new("white", [4,3])
          board.state[7][3] = Queen.new("black", [7,3])
          expect(board.checkmate?("black")).to eql(true)
        end
      end

    end

  end
end
