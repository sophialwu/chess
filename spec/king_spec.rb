require "spec_helper"

module Chess
  describe King do

    describe "#possible_moves" do
      
      describe "when the white king is at location [0,4]" do
        let(:king) { King.new("white", [0,4]) }

        it "returns [[1,4],[1,5],[0,5],[0,3],[1,3]]" do
          expect(king.possible_moves).to eql([[1,4],[1,5],[0,5],[0,3],[1,3]])
        end
      end

      describe "when the white king is at location [4,0]" do
        let(:king) { King.new("white", [4,0]) }

        it "returns [[5,0],[5,1],[4,1],[3,1],[3,0]]" do
          expect(king.possible_moves).to eql([[5,0],[5,1],[4,1],[3,1],[3,0]])
        end
      end

      describe "when the black king is at location [5,4]" do
        let(:king) { King.new("black", [5,4]) }

        it "returns [[6,4],[6,5],[5,5],[4,5],[4,4],[4,3],[5,3],[6,3]]" do
          expect(king.possible_moves).to eql([[6,4],[6,5],[5,5],[4,5],[4,4],
                                              [4,3],[5,3],[6,3]])
        end
      end

      describe "when the black king is at location [7,7]" do
        let(:king) { King.new("black", [7,7]) }

        it "returns [[6,7],[6,6],[7,6]]" do
          expect(king.possible_moves).to eql([[6,7],[6,6],[7,6]])
        end
      end

    end

  end
end