require 'rails_helper'
require_relative '../support/http_helpers.rb'

describe 'POST /api/v1/games/:id/ships' do
  include HTTPHelpers
  before(:each) do
    response = create_game
    @game_id = response.body[:id]
  end

  it 'player 1 places a ship successfully' do
    ship_1_payload = {
      ship_size: 3,
      start_space: "A1",
      end_space: "A3"
    }.to_json

    response = post_json("/api/v1/games/#{@game_id}/ships", ship_1_payload)

    expect(response.status).to eq(200)
    expect(response.body[:message]).to include("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")
  end

  it 'player 1 places a ship in space already taken' do
    Game.find(@game_id).player_1_board.spaces.find_by(name: "A1").update(ship: create(:ship))
    ship_1_payload = {
      ship_size: 3,
      start_space: "A1",
      end_space: "A3"
    }.to_json

    response = post_json("/api/v1/games/#{@game_id}/ships", ship_1_payload)

    expect(response.status).to eq(200)
    expect(response.body[:message]).to include("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")
  end
end
