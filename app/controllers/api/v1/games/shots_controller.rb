module Api
  module V1
    module Games
      class ShotsController < ApiController
        def create
          game = Game.find(params[:game_id])
          turn_processor = TurnProcessor.new(game, params[:shot][:target], current_requester)
          if turn_processor.check_api_key
            render json: game, message: turn_processor.message, status: 401 and return
          elsif turn_processor.check_invalid_turn
            render json: game, message: turn_processor.message, status: 400 and return
          end

          turn_processor.run!

          render json: game, winner: game.winner, message: turn_processor.message
        end
      end
    end
  end
end
