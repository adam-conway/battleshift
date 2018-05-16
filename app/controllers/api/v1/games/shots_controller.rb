module Api
  module V1
    module Games
      class ShotsController < ApiController
        def create
          game = Game.find(params[:game_id])

          turn_processor = TurnProcessor.new(game, params[:shot][:target])
          if turn_processor.check_for_cheater(request.headers["X-API-key"]) && !request.headers["X-API-key"].nil?
            render json: game, message: "Invalid move. It's your opponent's turn", status: 400
          elsif turn_processor.check_for_valid_coordinates(params[:shot][:target])
            render json: game, message: "Invalid coordinates.", status: 400
          else
            turn_processor.run!
            render json: game, message: turn_processor.message
          end
        end
      end
    end
  end
end
