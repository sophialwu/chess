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

  end
end