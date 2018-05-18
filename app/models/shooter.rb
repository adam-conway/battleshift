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

  # def self.fire!(board:, target:)
  #   new(board: board, target: target).fire!
  # end

  private
    attr_reader :board, :target_space

    # def space
    #   @space ||= board.locate_space(target)
    # end

    def fire_on_space(target_space)
      if !target_space.ship_id.nil? && target_space.status == "Not Attacked"
        target_space.update(status: "Hit")
        target_space.ship.increment!(:damage)
        @message = "Hit"
      else
        target_space.update(status: "Miss")
        @message = "Miss"
      end
      # @status = if contents && not_attacked?
      #             contents.attack!
      #             if contents.is_sunk?
      #               "Hit. Battleship sunk."
      #             else
      #               "Hit"
      #             end
      #           else
      #             "Miss"
      #           end
    end

    def valid_shot?
      board.spaces.pluck(:name).include?(target_space.name)
    end
end

class InvalidAttack < StandardError
  def initialize(msg = "Invalid attack.")
    super(msg)
  end
end
