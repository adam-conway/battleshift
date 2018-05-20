require 'rails_helper'
require './spec/support/http_helpers.rb'

describe 'POST /api/v1/games/:id/ships' do

  let (:challenger) { create(:user) }
  let (:opponent) { create(:user, email: 'nelson.jimmy@gmail.com', api_key: '987654321a') }

  it 'player 1 places a ship successfully' do
    player_1_board = BoardGenerator.new(4).generate
    game = create(:game, player_1_board: player_1_board)

    ship_1_payload = {
      ship_size: 3,
      start_space: "A1",
      end_space: "A3"
    }.to_json
    headers = { "CONTENT_TYPE" => "application/json", 'X-API-Key' => challenger.api_key }


    post "/api/v1/games/#{game.id}/ships", headers: headers, params: ship_1_payload
    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(parsed[:message]).to include("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")
  end

  it 'player 1 tries to place a ship in space already taken' do
    player_1_board = BoardGenerator.new(4).generate
    player_1_board.spaces.find_by(name: "A1").update(ship: create(:ship))
    game = create(:game, player_1_board: player_1_board)

    ship_1_payload = {
      ship_size: 3,
      start_space: "A1",
      end_space: "A3"
    }.to_json
    headers = { "CONTENT_TYPE" => "application/json", 'X-API-Key' => challenger.api_key }

    expect{post "/api/v1/games/#{game.id}/ships", headers: headers, params: ship_1_payload}.to raise_error(InvalidShipPlacement)
  end
end
