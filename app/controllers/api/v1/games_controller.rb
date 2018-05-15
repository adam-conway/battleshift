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

        challenger_board = Board.new(5)
        opponent_board = Board.new(5)

        game = Game.create(player_1_board: challenger_board, player_2_board: opponent_board)

        render json: game
      end
    end
  end
end
