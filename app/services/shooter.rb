class Shooter
  attr_reader :message
  def initialize(board:, target:)
    @board           = board
    @target_space    = @board.spaces.find_by(name: target)
    @message         = ""
  end

  def fire!
    if valid_shot?
      fire_on_space(@target_space)
    else
      raise InvalidAttack.new("Invalid coordinates.")
    end
  end

  private
    attr_reader :board, :target_space

    def fire_on_space(target_space)
      if !target_space.ship_id.nil? && target_space.status == "Not Attacked"
        target_space.update(status: "Hit")
        target_space.ship.increment!(:damage)
        @message = "Hit"
      else
        target_space.update(status: "Miss")
        @message = "Miss"
      end

      check_for_sunk_ship unless target_space.ship_id.nil?
    end

    def check_for_sunk_ship
      if target_space.ship.damage == target_space.ship.length
        @message += ". Battleship sunk"
      end
    end

    def valid_shot?
      board.spaces.pluck(:name).include?(target_space.name) unless target_space.nil?
    end
end

class InvalidAttack < StandardError
  def initialize(msg = "Invalid attack.")
    super(msg)
  end
end
