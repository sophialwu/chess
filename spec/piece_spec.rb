require "spec_helper"

module Chess
  describe Piece do

    describe "#initialize" do
      it "raises an error when initialized without arguments" do
        expect{ Piece.new }.to raise_error(ArgumentError)
      end

      it "does not raise an error when initialized with a color and location" do
        expect{ Piece.new("black", [0,0]) }.to_not raise_error
      end

    end

  end
end