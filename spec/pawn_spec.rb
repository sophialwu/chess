require "spec_helper"

module Chess
  describe Pawn do

    describe "#possible_moves" do
      
      describe "when the white pawn is at location [1,1] and has not moved" do
        let(:pawn) { Pawn.new("white", [1,1]) }

        it "returns [[2,1],[3,1],[2,0],[2,2]]" do
          expect(pawn.possible_moves).to eql([[2,1],[3,1],[2,0],[2,2]])
        end
      end

      describe "when the white pawn is at location [2,1] and has moved" do
        let(:pawn) { Pawn.new("white", [2,1]) }

        it "returns [[3,1],[3,0],[3,2]]" do
          pawn.instance_variable_set(:@moved, true)
          expect(pawn.possible_moves).to eql([[3,1],[3,0],[3,2]])
        end
      end

      describe "when the white pawn is at location [3,0] and has moved" do
        let(:pawn) { Pawn.new("white", [3,0]) }

        it "returns [[4,0],[4,1]]" do
          pawn.instance_variable_set(:@moved, true)
          expect(pawn.possible_moves).to eql([[4,0],[4,1]])
        end
      end

      describe "when the white pawn is at location [4,7] and has moved" do
        let(:pawn) { Pawn.new("white", [4,7]) }

        it "returns [[5,7],[5,6]]" do
          pawn.instance_variable_set(:@moved, true)
          expect(pawn.possible_moves).to eql([[5,7],[5,6]])
        end
      end

      describe "when the black pawn is at location [6,6] and has not moved" do
        let(:pawn) { Pawn.new("black", [6,6]) }

        it "returns [[5,6],[4,6],[5,7],[5,5]]" do
          expect(pawn.possible_moves).to eql([[5,6],[4,6],[5,7],[5,5]])
        end
      end

      describe "when the black pawn is at location [5,6] and has moved" do
        let(:pawn) { Pawn.new("black", [5,6]) }

        it "returns [[4,6],[4,7],[4,5]]" do
          pawn.instance_variable_set(:@moved, true)
          expect(pawn.possible_moves).to eql([[4,6],[4,7],[4,5]])
        end
      end

      describe "when the black pawn is at location [4,7] and has moved" do
        let(:pawn) { Pawn.new("black", [4,7]) }

        it "returns [[3,7],[3,6]]" do
          pawn.instance_variable_set(:@moved, true)
          expect(pawn.possible_moves).to eql([[3,7],[3,6]])
        end
      end

      describe "when the black pawn is at location [3,0] and has moved" do
        let(:pawn) { Pawn.new("black", [3,0]) }

        it "returns [[2,0],[2,1]]" do
          pawn.instance_variable_set(:@moved, true)
          expect(pawn.possible_moves).to eql([[2,0],[2,1]])
        end
      end

    end

  end
end