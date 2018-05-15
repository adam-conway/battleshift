class Api::V1::Games::ShipsController < ApiController
  def create
    game = Game.find(params[:game_id])
    ship = Ship.new(params[:ship_size])
    if game.player_1_api_key == request.headers['X-API-key']
      ship_placer = ShipPlacer.new(game.player_1_board, ship, params[:start_space], params[:end_space]).run
      game.update(player_1_board: game.player_1_board)
    else
      ship_placer = ShipPlacer.new(game.player_2_board, ship, params[:start_space], params[:end_space]).run
      game.update(player_2_board: game.player_2_board)
    end
    render json: game, message: ship_placer
  end
end
