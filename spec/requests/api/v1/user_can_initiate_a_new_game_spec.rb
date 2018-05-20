require 'rails_helper'
require './spec/support/http_helpers.rb'


describe 'Api::V1::GamesController' do
  context 'POST /api/v1/games' do
    include HTTPHelpers

    let (:challenger) { create(:user) }
    let (:opponent) { create(:user, email: 'nelson.jimmy@gmail.com', api_key: '987654321a') }

    it 'creates a new game' do
      headers = { "CONTENT_TYPE" => "application/json", 'X-API-Key' => challenger.api_key }

      options = { opponent_email: opponent.email }.to_json

      post "/api/v1/games", params: options, headers: headers

      expect(response).to be_success
    end

    it 'creates a new game successfully' do
      response = create_game
      expect(response.body[:id])
    end
  end

end
