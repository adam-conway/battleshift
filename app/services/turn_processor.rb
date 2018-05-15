class TurnProcessor
  def initialize(game, target)
    @game   = game
    @target = target
    @messages = []
  end

  def run!
    begin
      attack_opponent

      # ai_attack_back
      game.save!
    rescue InvalidAttack => e
      @messages << e.message
    end
  end

  def message
    @messages.join(" ")
  end

  def check_for_cheater(api_key)
    (game.current_turn == "challenger" && api_key == game.player_2_api_key) || (game.current_turn == "opponent" && api_key == game.player_1_api_key)
  end

  private

  attr_reader :game, :target

  def attack_opponent
    result = Shooter.fire!(board: opponent.board, target: target)
    @messages << "Your shot resulted in a #{result}."
    game.player_1_turns += 1
    if game.current_turn == 'challenger'
      game.current_turn = 'opponent'
    else
      game.current_turn = 'challenger'
    end
  end

  def ai_attack_back
    result = AiSpaceSelector.new(player.board).fire!
    @messages << "The computer's shot resulted in a #{result}."
    game.player_2_turns += 1
  end

  def player
    if game.current_turn == 1
      Player.new(game.player_2_board)
    else
      Player.new(game.player_1_board)
    end
  end

  def opponent
    if game.current_turn == 'challenger'
      Player.new(game.player_2_board)
    else
      Player.new(game.player_1_board)
    end
  end

end
