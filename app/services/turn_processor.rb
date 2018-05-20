class TurnProcessor
  attr_reader :status
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
    rescue InvalidAttack => e
      @messages << e.message
    end
  end

  def message
    @messages.join(" ")
  end

  def check_api_key
    if shooter.nil?
      @messages << "Unauthorized"
    elsif shooter.api_key != game.player_1.api_key && shooter.api_key != game.player_2.api_key
      @messages << "Unauthorized"
    else
      false
    end
  end

  def check_invalid_turn
    if check_for_cheater
      @messages << "Invalid move. It's your opponent's turn"
    elsif check_for_invalid_coordinates
      @messages << "Invalid coordinates."
    elsif check_for_game_over
      @messages << "Invalid move. Game over."
    else
      false
    end
  end


  private

  attr_reader :game, :target, :shooter, :target_board

  def attack_opponent
    shot_attempt = Shooter.new(board: @target_board, target: target)
    shot_attempt.fire!
    @messages << "Your shot resulted in a #{shot_attempt.message}."
    check_end_of_game
    if game.current_turn == 'challenger'
      game.update(current_turn: 'opponent')
    else
      game.update(current_turn: 'challenger')
    end
  end

  def check_end_of_game
    if target_board.ships.sum(:length) == target_board.ships.sum(:damage)
      @messages[0] += " Game over."
      game.update(winner: shooter)
    end
  end

  def check_for_invalid_coordinates
    @target_board.spaces.pluck(:name).exclude?(target)
  end

  def check_for_game_over
    !game.winner.nil?
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
end
