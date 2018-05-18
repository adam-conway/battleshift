class TurnProcessor
  def initialize(game, target, shooter)
    @game         = game
    @target       = target
    @shooter      = shooter
    @target_board = determine_target_board
    @messages     = []
  end

  def run!
    begin
      attack_opponent
      # ai_attack_back
      # game.save!
    rescue InvalidAttack => e
      @messages << e.message
    end
  end

  def message
    @messages.join(" ")
  end


  def check_invalid_turn
    if check_for_cheater
      @messages << "Invalid move. It's your opponent's turn"
    elsif check_for_invalid_coordinates
      @messages << "Invalid coordinates"
    else
      false
    end
  end


  private

  attr_reader :game, :target, :shooter

  def attack_opponent
    shot_attempt = Shooter.new(board: @target_board, target: target)
    shot_attempt.fire!
    # ships = opponent.board.board.flatten.map(&:values).flatten.map(&:contents).find_all do |contents|
    #   contents.class == ShipPoro
    # end.uniq
    # if ships.all? {|ship| ship.is_sunk?}
    #   result += " Game over"
    #   key = if game.current_turn == "challenger"
    #     game.player_1_api_key
    #   else
    #     game.player_2_api_key
    #   end
    #   game.update(winner: User.find_by(api_key: key).email)
    # end
    @messages << "Your shot resulted in a #{shot_attempt.message}."
    if game.current_turn == 'challenger'
      game.update(current_turn: 'opponent')
    else
      game.update(current_turn: 'challenger')
    end
  end

  def check_for_invalid_coordinates
    @target_board.spaces.pluck(:name).exclude?(target)
    # possible_spaces = opponent.board.board.flatten.map do |space|
    #   space.keys
    # end.flatten
    #
    # !possible_spaces.include?(coordinates)
  end

  def check_for_cheater
    (game.current_turn == "challenger" && shooter.api_key == game.player_2.api_key) || (game.current_turn == "opponent" && shooter.api_key == game.player_1.api_key)
  end
  def ai_attack_back
    result = AiSpaceSelector.new(player.board).fire!
    @messages << "The computer's shot resulted in a #{result}."
    game.player_2_turns += 1
  end

  def determine_target_board
    if game.current_turn == 'challenger'
      game.player_2_board
    else
      game.player_1_board
    end
  end

  # def player
  #   if game.current_turn == 1
  #     Player.new(game.player_2_board)
  #   else
  #     Player.new(game.player_1_board)
  #   end
  # end
  #
  # def opponent
  #   if game.current_turn == 'challenger'
  #     Player.new(game.player_2_board)
  #   else
  #     Player.new(game.player_1_board)
  #   end
  # end

end
