require "spec_helper"

module Chess
  describe Player do

    describe "#initialize" do
      it "raises an error when initialized without arguments" do
        expect{ Player.new }.to raise_error(ArgumentError)
      end

      it "does not raise an error when initialized with a name and color" do
        expect{ Player.new("Sally", "black") }.to_not raise_error
      end
    end

  end
end