require 'rails_helper'

describe ShipPlacer do
  before(:all) do
    @player_1 = create(:user, name: "Adam", email:"adam.n.conway@gmail.com", api_key: "123456789a", password: "password")
    @player_2 = create(:user, name: "Jimmy", email:"nelson.jimmy@gmail.com", api_key: "987654321a", password: "password")
    @player_1_board = BoardGenerator.new(4).generate
    @player_2_board = BoardGenerator.new(4).generate
    @game = create(:game, player_1_board: @player_1_board, player_2_board: @player_2_board, player_1: @player_1, player_2: @player_2)
  end
    describe "testing" do

    it "exists when provided a board and ship" do
      ship_placer = ShipPlacer.new(game: @game, ship: create(:ship), start_space: "A1", end_space: "A3", api_key: @player_1.api_key)
      expect(ship_placer).to be_a ShipPlacer
    end

    it "places the ship within a row with empty spaces" do
      ship = create(:ship, length: 3)

      a1 = @player_1_board.spaces.find_by(name: "A1")
      a2 = @player_1_board.spaces.find_by(name: "A2")
      a3 = @player_1_board.spaces.find_by(name: "A3")
      b1= @player_1_board.spaces.find_by(name: "B1")

      expect(a1.ship).to be_nil
      expect(a2.ship).to be_nil
      expect(a3.ship).to be_nil
      expect(b1.ship).to be_nil

      ShipPlacer.new(game: @game, ship: ship, start_space: "A1", end_space: "A3", api_key: @player_1.api_key).run

      expect(@player_1_board.spaces.find_by(name: "A1").ship).to eq(ship)
      expect(@player_1_board.spaces.find_by(name: "A2").ship).to eq(ship)
      expect(@player_1_board.spaces.find_by(name: "A3").ship).to eq(ship)
      expect(@player_1_board.spaces.find_by(name: "B1").ship).to be_nil
    end

    it "places the ship within a column with empty spaces" do
      ship = create(:ship, length: 3)

      a1 = @player_1_board.spaces.find_by(name: "A1")
      a2 = @player_1_board.spaces.find_by(name: "A2")
      a3 = @player_1_board.spaces.find_by(name: "A3")
      b1= @player_1_board.spaces.find_by(name: "B1")
      c1= @player_1_board.spaces.find_by(name: "C1")

      expect(a1.ship).to be_nil
      expect(a2.ship).to be_nil
      expect(a3.ship).to be_nil
      expect(b1.ship).to be_nil
      expect(c1.ship).to be_nil

      ShipPlacer.new(game: @game, ship: ship, start_space: "A1", end_space: "C1", api_key: @player_1.api_key).run

      expect(@player_1_board.spaces.find_by(name: "A1").ship).to eq(ship)
      expect(@player_1_board.spaces.find_by(name: "A2").ship).to be_nil
      expect(@player_1_board.spaces.find_by(name: "A3").ship).to be_nil
      expect(@player_1_board.spaces.find_by(name: "B1").ship).to eq(ship)
      expect(@player_1_board.spaces.find_by(name: "C1").ship).to eq(ship)
    end

    xit "doesn't place the ship if it isn't within the same row or column" do
      expect {
        ShipPlacer.new(board: board, ship: ship, start_space: "A1", end_space: "B2").run
      }.to raise_error(InvalidShipPlacement)
    end

    xit "doesn't place the ship if the space is occupied when placing in columns" do
      ShipPlacer.new(board: board, ship: ship, start_space: "A1", end_space: "B1").run
      expect {
        ShipPlacer.new(board: board, ship: ship, start_space: "A1", end_space: "B1").run
      }.to raise_error(InvalidShipPlacement)
    end

    xit "doesn't place the ship if the space is occupied when placing in rows" do
      ShipPlacer.new(board: board, ship: ship, start_space: "A1", end_space: "A2").run
      expect {
        ShipPlacer.new(board: board, ship: ship, start_space: "A1", end_space: "A2").run
      }.to raise_error(InvalidShipPlacement)
    end

    xit "doesn't place the ship if the ship is smaller than the supplied range in a row" do
      expect {
        ShipPlacer.new(board: board, ship: ship, start_space: "A1", end_space: "A3").run
      }.to raise_error(InvalidShipPlacement)
    end

    xit "doesn't place the ship if the ship is smaller than the supplied range in a column" do
      expect {
        ShipPlacer.new(board: board, ship: ship, start_space: "A1", end_space: "C1").run
      }.to raise_error(InvalidShipPlacement)
    end
  end
end
