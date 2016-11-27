require "spec_helper"

module Chess
  describe Bishop do

    describe "#possible_moves" do
      
      describe "when the white bishop is at location [0,2]" do
        let(:bishop) { Bishop.new("white", [0,2]) }

        it "returns [[1,1],[2,0],[1,3],[2,4],[3,5],[4,6],[5,7]]" do
          expect(bishop.possible_moves).to eql([[1,1],[2,0],
                                                [1,3],[2,4],[3,5],[4,6],[5,7]])
        end
      end

      describe "when the black bishop is at location [7,2]" do
        let(:bishop) { Bishop.new("black", [7,2]) }

        it "returns [[6,1],[5,0],[6,3],[5,4],[4,5],[3,6],[2,7]]" do
          expect(bishop.possible_moves).to eql([[6,1],[5,0],
                                                [6,3],[5,4],[4,5],[3,6],[2,7]])
        end
      end

      describe "when the black bishop is at location [7,7]" do
        let(:bishop) { Bishop.new("black", [7,7]) }

        it "returns [[6,6],[5,5],[4,4],[3,3],[2,2],[1,1],[0,0]]" do
          expect(bishop.possible_moves).to eql([[6,6],[5,5],[4,4],[3,3],
                                               [2,2],[1,1],[0,0]])
        end
      end

      describe "when the white bishop is at location [4,4]" do
        let(:bishop) { Bishop.new("white", [4,4]) }

        it "returns [[5,3],[6,2],[7,1],[5,5],[6,6],[7,7],
                     [3,3],[2,2],[1,1],[0,0],
                     [3,5],[2,6],[1,7]]" do
          expect(bishop.possible_moves).to eql([[5,3],[6,2],[7,1],
                                                [5,5],[6,6],[7,7],
                                                [3,3],[2,2],[1,1],[0,0],
                                                [3,5],[2,6],[1,7]])
        end
      end

      describe "when the white bishop is at location [3,0]" do
        let(:bishop) { Bishop.new("white", [3,0]) }

        it "returns [[4,1],[5,2],[6,3],[7,4],
                     [2,1],[1,2],[0,3]]" do
          expect(bishop.possible_moves).to eql([[4,1],[5,2],[6,3],[7,4],
                                                [2,1],[1,2],[0,3]])
        end
      end

      describe "when the white bishop is at location [1,6]" do
        let(:bishop) { Bishop.new("white", [1,6]) }

        it "returns [[2,5],[3,4],[4,3],[5,2],[6,1],
                     [7,0],[2,7],[0,5],[0,7]]" do
          expect(bishop.possible_moves).to eql([[2,5],[3,4],[4,3],[5,2],[6,1],
                                                [7,0],[2,7],[0,5],[0,7]])
        end
      end

    end

  end
end
