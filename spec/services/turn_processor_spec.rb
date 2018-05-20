require 'rails_helper'

describe "testing turn_processor" do
  before(:each) do
    @player_1 = create(:user, name: "Adam", email:"adam.n.conway@gmail.com", api_key: "123456789a", password: "password")
    @player_2 = create(:user, name: "Jimmy", email:"nelson.jimmy@gmail.com", api_key: "987654321a", password: "password")
    @player_1_board = BoardGenerator.new(4).generate
    @player_2_board = BoardGenerator.new(4).generate
    @game = create(:game, player_1_board: @player_1_board, player_2_board: @player_2_board, player_1: @player_1, player_2: @player_2)
    ship = create(:ship, length: 3)
    space_array = []
    space_array << @player_2_board.spaces.find_by(name: "A1")
    space_array << @player_2_board.spaces.find_by(name: "B1")
    space_array << @player_2_board.spaces.find_by(name: "C1")
    space_array.each do |space|
      space.ship = ship
      space.save
    end
  end

  it "Valid api key" do
    turn_processor = TurnProcessor.new(@game, "D1", @player_1)

    expect(turn_processor.check_api_key).to eq(false)
  end

  it "Valid attack" do
    turn_processor = TurnProcessor.new(@game, "D1", @player_1)

    expect(turn_processor.check_invalid_turn).to eq(false)
  end

  it "Shoots but misses" do
    turn_processor = TurnProcessor.new(@game, "D1", @player_1)
    turn_processor.run!

    expect(turn_processor.message).to eq("Your shot resulted in a Miss.")
  end

  it "Shoots and hits" do
    @game.update(current_turn: "opponent")
    @player_1_board.spaces.find_by(name: "A1").update(ship: create(:ship))
    turn_processor = TurnProcessor.new(@game, "A1", @player_2)
    turn_processor.run!

    expect(turn_processor.message).to eq("Your shot resulted in a Hit.")
  end

  it "Shoots and hits to end the game" do
    @game.update(current_turn: "opponent")
    @player_1_board.spaces.find_by(name: "A1").update(ship: create(:ship, length: 1))
    turn_processor = TurnProcessor.new(@game, "A1", @player_2)
    turn_processor.run!

    expect(turn_processor.message).to eq("Your shot resulted in a Hit. Battleship sunk. Game over.")
  end

  it "Unregistered guest tries to fire a shot" do
    turn_processor = TurnProcessor.new(@game, "A1", nil)
    turn_processor.check_api_key

    expect(turn_processor.message).to eq("Unauthorized")
  end

  it "Registered user who isn't part of game tries to fire a shot" do
    user = create(:user, api_key: "123")
    turn_processor = TurnProcessor.new(@game, "A1", user)
    turn_processor.check_api_key

    expect(turn_processor.message).to eq("Unauthorized")
  end

  it "User tries to shoot out of turn" do
    turn_processor = TurnProcessor.new(@game, "A1", @player_2)
    turn_processor.check_invalid_turn

    expect(turn_processor.message).to eq("Invalid move. It's your opponent's turn")
  end

  it "User tries to shoot at invalid coordinates" do
    turn_processor = TurnProcessor.new(@game, "Z1", @player_1)
    turn_processor.check_invalid_turn

    expect(turn_processor.message).to eq("Invalid coordinates.")
  end

  it "User tries to shoot after game is over" do
    @game.update(winner: @player_1)
    turn_processor = TurnProcessor.new(@game, "A1", @player_1)
    turn_processor.check_invalid_turn

    expect(turn_processor.message).to eq("Invalid move. Game over.")
  end
end
