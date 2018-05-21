class GamesController < ApplicationController
  def index
    user = User.find(current_user.id)
    @player_1_games = user.player_1_games
    @player_2_games = user.player_2_games
  end
end
