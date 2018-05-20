require 'rails_helper'

describe "testing shooter" do
  before(:all) do
    @player_1 = create(:user, name: "Adam", email:"adam.n.conway@gmail.com", api_key: "123456789a", password: "password")
    @player_2 = create(:user, name: "Jimmy", email:"nelson.jimmy@gmail.com", api_key: "987654321a", password: "password")
    @player_1_board = BoardGenerator.new(4).generate
    @player_2_board = BoardGenerator.new(4).generate
    @game = create(:game, player_1_board: @player_1_board, player_2_board: @player_2_board, player_1: @player_1, player_2: @player_2)
  end

  it "Shoots but misses" do
    shot = Shooter.new(board: @player_1_board, target: "A1")
    shot.fire!

    expect(shot.message).to eq("Miss")
  end

  it "Shoots at an invalid location" do
    shot = Shooter.new(board: @player_1_board, target: "F1")

    expect{shot.fire!}.to raise_error(InvalidAttack)
  end

  it "Shoots and hits" do
    ship = create(:ship, length: 3)
    space_array = []
    space_array << @player_1_board.spaces.find_by(name: "A1")
    space_array << @player_1_board.spaces.find_by(name: "B1")
    space_array << @player_1_board.spaces.find_by(name: "C1")
    space_array.each do |space|
      space.ship = ship
      space.save
    end

    shot = Shooter.new(board: @player_1_board, target: "A1")
    shot.fire!

    expect(shot.message).to eq("Hit")
  end

  it "Shoots, hits, and sinks a ship" do
    ship = create(:ship, length: 3, damage: 2)
    space_array = []
    space_array << @player_1_board.spaces.find_by(name: "A1")
    space_array << @player_1_board.spaces.find_by(name: "B1")
    space_array << @player_1_board.spaces.find_by(name: "C1")
    space_array.each do |space|
      space.ship = ship
      space.save
    end

    shot = Shooter.new(board: @player_1_board, target: "A1")
    shot.fire!

    expect(shot.message).to eq("Hit. Battleship sunk")
  end
end
