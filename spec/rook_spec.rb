require "spec_helper"

module Chess
  describe Rook do

    describe "#possible_moves" do
      
      describe "when the white rook is at location [0,0]" do
        let(:rook) { Rook.new("white", [0,0]) }

        it "returns [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],
                     [0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7]]" do
          expect(rook.possible_moves).to eql(
                [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],
                 [0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7]])
        end
      end

      describe "when the black rook is at location [7,0]" do
        let(:rook) { Rook.new("black", [7,0]) }

        it "returns [[6,0],[5,0],[4,0],[3,0],[2,0],[1,0],[0,0],
                     [7,0],[7,1],[7,2],[7,3],[7,4],[7,5],[7,6]]" do
          expect(rook.possible_moves).to eql(
                [[6,0],[5,0],[4,0],[3,0],[2,0],[1,0],[0,0],
                 [7,1],[7,2],[7,3],[7,4],[7,5],[7,6],[7,7]])
        end
      end

      describe "when the white rook is at location [3,3]" do
        let(:rook) { Rook.new("white", [3,3]) }

        it "returns [[2,3],[1,3],[0,3],
                     [4,3],[5,3],[6,3],[7,3],
                     [3,2],[3,1],[3,0],
                     [3,4],[3,5],[3,6],[3,7]]" do
          expect(rook.possible_moves).to eql(
                [[2,3],[1,3],[0,3],
                 [4,3],[5,3],[6,3],[7,3],
                 [3,2],[3,1],[3,0],
                 [3,4],[3,5],[3,6],[3,7]])
        end
      end

      describe "when the white rook is at location [7,7]" do
        let(:rook) { Rook.new("white", [7,7]) }

        it "returns [[6,7],[5,7],[4,7],[3,7],[2,7],[1,7],[0,7],
                     [7,6],[7,5],[7,4],[7,3],[7,2],[7,1],[7,0]]" do
          expect(rook.possible_moves).to eql(
                [[6,7],[5,7],[4,7],[3,7],[2,7],[1,7],[0,7],
                 [7,6],[7,5],[7,4],[7,3],[7,2],[7,1],[7,0]])
        end
      end

    end

  end
end
