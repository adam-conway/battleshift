module Api
  module V1
    module Games
      class ShotsController < ApiController
        def create
          game = Game.find(params[:game_id])

          turn_processor = TurnProcessor.new(game, params[:shot][:target])

          binding.pry
          turn_processor.run!
          render json: game, message: turn_processor.message
        end
      end
    end
  end
end
