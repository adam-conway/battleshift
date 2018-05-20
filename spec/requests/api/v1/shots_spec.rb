require 'rails_helper'

describe "Api::V1::Shots" do
  context "POST /api/v1/games/:id/shots" do
    let(:player_1_board)   { create(:board) }
    let(:player_2_board)   { create(:board) }
    let(:sm_ship) { create(:small_ship) }
    let(:challenger) { create(:user) }
    let(:opponent) { create(:user, api_key: '987654321a') }
    let(:game)    {
      create(:game,
        player_1_board: player_1_board,
        player_2_board: player_2_board,
        player_1: challenger,
        player_2: opponent
      )
    }


    it "updates the message and board with a hit" do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, player_1: challenger, player_2: opponent)
      create(:space, board: player_1_board, name: 'A1')
      create(:space, board: player_1_board, name: 'A2')
      create(:space, board: player_2_board, name: 'A1')
      create(:space, board: player_2_board, name: 'A2')

      game.player_2_board.spaces.find_by(name: "A1").update(ship: create(:ship))

      headers = { "CONTENT_TYPE" => "application/json", 'X-API-Key' => challenger.api_key }
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Hit."
      player_2_targeted_space = game[:player_2_board][:rows].first[:data].first[:status]

      expect(game[:message]).to eq expected_messages
      expect(player_2_targeted_space).to eq("Hit")
    end

    it "updates the message and board with a miss" do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, player_1: challenger, player_2: opponent)
      create(:space, board: player_1_board, name: 'A1')
      create(:space, board: player_1_board, name: 'A2')
      create(:space, board: player_2_board, name: 'A1')
      create(:space, board: player_2_board, name: 'A2')

      game.player_2_board.spaces.find_by(name: "A1").update(ship: create(:ship))

      headers = { "CONTENT_TYPE" => "application/json", 'X-API-Key' => challenger.api_key }
      json_payload = {target: "A2"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Miss."
      player_2_targeted_space = game[:player_2_board][:rows].first[:data].last[:status]

      expect(game[:message]).to eq expected_messages
      expect(player_2_targeted_space).to eq("Miss")
    end

    it "updates the message but not the board with invalid coordinates" do
      game = create(
        :game,
        player_1_board: player_1_board,
        player_2_board: player_2_board,
        current_turn: 'challenger',
        player_1_id: challenger.id,
        player_2_id: opponent.id
      )

      headers = { "CONTENT_TYPE" => "application/json", 'X-API-Key' => challenger.api_key }
      json_payload = {target: "E3"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      game = JSON.parse(response.body, symbolize_names: true)
      expect(game[:message]).to eq "Invalid coordinates."
    end

    it "responds with incorrect api key" do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, player_1: challenger, player_2: opponent)
      create(:space, board: player_1_board, name: 'A1')
      create(:space, board: player_1_board, name: 'A2')
      create(:space, board: player_2_board, name: 'A1')
      create(:space, board: player_2_board, name: 'A2')

      game.player_2_board.spaces.find_by(name: "A1").update(ship: create(:ship))

      headers = { "CONTENT_TYPE" => "application/json", 'X-API-Key' => '123' }
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response.status).to eq(401)
    end
  end
end
