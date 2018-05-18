module Api
  module V1
    module Games
      class ShotsController < ApiController
        def create
          game = Game.find(params[:game_id])

          # if game.winner
          #   render json: game, winner: game.winner, message: "Invalid move. Game over.", status: 400 and return
          # end
          #
          # unless game.player_1_api_key == request.headers["X-API-key"] || game.player_2_api_key == request.headers["X-API-key"]
          #   render json: {message: "Unauthorized"}, status: 401 and return
          # end

          turn_processor = TurnProcessor.new(game, params[:shot][:target], current_requester)
          turn_processor.run!

          render json: game, winner: game.winner, message: turn_processor.message
          # if turn_processor.check_for_cheater(request.headers["X-API-key"]) && !request.headers["X-API-key"].nil?
          #   render json: game, message: "Invalid move. It's your opponent's turn", status: 400
          # elsif turn_processor.check_for_valid_coordinates(params[:shot][:target])
          #   render json: game, message: "Invalid coordinates.", status: 400
          # else
          #   turn_processor.run!
          #   render json: game, winner: game.winner, message: turn_processor.message
          # end
        end
      end
    end
  end
end
