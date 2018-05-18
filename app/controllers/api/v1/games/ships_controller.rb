class Api::V1::Games::ShipsController < ApiController
  def create
    game = Game.find(params[:game_id])
    ship = Ship.create(damage: 0, length: params[:ship_size])
    ship_placer = ShipPlacer.new(game: game, ship: ship, start_space: params[:start_space], end_space: params[:end_space], api_key: current_requester.api_key)
    ship_placer.run

    render json: game, message: ship_placer.message
  end
end
