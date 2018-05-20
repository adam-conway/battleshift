require 'rails_helper'

describe 'GET /api/v1/games/1' do
  context 'with an existing game' do
    it 'returns a game with boards' do

      challenger = create(:user)
      opponent = create(:user, name: 'Jimmy', email: 'nelson.jimmy@gmail.com', api_key: '987654321a')
      challenger_board = BoardGenerator.new(4).generate
      opponent_board = BoardGenerator.new(4).generate

      game = Game.create(
        player_1: challenger,
        player_1_board: challenger_board,
        player_2: opponent,
        player_2_board: opponent_board
      )

      ShipPlacer.new(
        game: game,
        ship: create(:small_ship),
        start_space: 'A1',
        end_space: 'A2',
        api_key: challenger.api_key
      ).run

      ShipPlacer.new(
        game: game,
        ship: create(:ship),
        start_space: 'B1',
        end_space: 'D1',
        api_key: challenger.api_key
      ).run

      ShipPlacer.new(
        game: game,
        ship: create(:small_ship),
        start_space: 'A1',
        end_space: 'A2',
        api_key: opponent.api_key
      ).run

      ShipPlacer.new(
        game: game,
        ship: create(:ship),
        start_space: 'B1',
        end_space: 'D1',
        api_key: opponent.api_key
      ).run

      get "/api/v1/games/#{game.id}"

      actual  = JSON.parse(response.body, symbolize_names: true)
      expected = Game.last

      expect(response).to be_success
      expect(actual[:id]).to eq(expected.id)
      expect(actual[:current_turn]).to eq(expected.current_turn)
      expect(actual[:player_1_board][:rows].count).to eq(4)
      expect(actual[:player_2_board][:rows].count).to eq(4)
      expect(actual[:player_1_board][:rows][0][:name]).to eq("row_a")
      expect(actual[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
      expect(actual[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
      expect(actual[:player_1_board][:rows][3][:data][0][:status]).to eq("Not Attacked")
    end
  end

  describe 'with no game' do
    it 'returns a 400' do
      get "/api/v1/games/1"

      expect(response.status).to be(400)
    end
  end
end
