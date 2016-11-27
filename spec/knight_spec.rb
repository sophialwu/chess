require "spec_helper"

module Chess
  describe Knight do

    describe "#possible_moves" do
      
      describe "when the white knight is at location [0,0]" do
        let(:knight) { Knight.new("white", [0,0]) }

        it "returns [[1,2],[2,1]]" do
          expect(knight.possible_moves).to eql([[1,2],[2,1]])
        end
      end

      describe "when the black knight is at location [7,1]" do
        let(:knight) { Knight.new("black", [7,1]) }

        it "returns [[5,2],[5,0],[6,3]]" do
          expect(knight.possible_moves).to eql([[5,2],[5,0],[6,3]])
        end
      end

      describe "when the black knight is at location [3,3]" do
        let(:knight) { Knight.new("black", [3,3]) }

        it "returns [[1,4],[1,2],[2,5],[2,1],[4,5],[4,1],[5,4],[5,2]]" do
          expect(knight.possible_moves).to eql([[1,4],[1,2],[2,5],[2,1],
                                                [4,5],[4,1],[5,4],[5,2]])
        end
      end

      describe "when the white knight is at location [4,7]" do
        let(:knight) { Knight.new("white", [4,7]) }

        it "returns [[2,6],[3,5],[5,5],[6,6]]" do
          expect(knight.possible_moves).to eql([[2,6],[3,5],[5,5],[6,6]])
        end
      end

    end

  end
end
