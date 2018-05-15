module Api
  module V1
    class GamesController < ActionController::API
      def show
        game = Game.find(params[:id])
        render json: game
      end

      def create
        challenger = User.find_by(api_key: request.headers["X-API-Key"])
        opponent = User.find_by(email: params["opponent_email"])

        binding.pry
      end
    end
  end
end
