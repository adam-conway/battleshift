class ShipPlacer
  attr_reader :message
  def initialize(game:, ship:, start_space:, end_space:, api_key:)
    @game        = game
    @ship        = ship
    @start_space = start_space
    @end_space   = end_space
    @api_key     = api_key
    @board       = find_correct_board
    @message     = nil
  end

  def run
    if same_row?
      place_in_row
    elsif same_column?
      place_in_column
    else
      raise InvalidShipPlacement.new("Ship must be in either the same row or column.")
    end
  end

  private
  attr_reader :board, :ship,
    :start_space, :end_space

  def same_row?
    start_space[0] == end_space[0]
  end

  def same_column?
    start_space[1] == end_space[1]
  end

  def place_in_row
    spaces = find_row_spaces
    raise InvalidShipPlacement unless spaces.count == ship.length
    place_ship(spaces)
    # spaces.each do |space|
    #   space.update(ship: ship)
    # end
    # if @board.ships.uniq.count == 1
    #   "Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2."
    # else
    #   "Successfully placed ship with a size of 2. You have 1 ship(s) to place."
    # end
  end

  def place_in_column
    spaces = find_column_spaces
    raise InvalidShipPlacement unless range.count == ship.length
    place_ship(spaces)
    # range.each { |row| place_ship(row, column) }
    # @board.fleet.delete(ship.length)
    # if @board.fleet.length >= 1
    #   "Successfully placed ship with a size of #{ship.length}. You have #{board.fleet.count} ship(s) to place with a size of #{board.fleet.last}."
    # else
    #   "Successfully placed ship with a size of #{ship.length}. You have #{board.fleet.count} ship(s) to place."
    # end

    # spaces = @board.spaces.where("name LIKE ?", "%#{start_space[1]}").order(name: :asc).where("name > '#{start_space[0]}'").limit(2)
  end

  def find_correct_board
    if @game.player_1.api_key == @api_key
      @game.player_1_board
    else
      @game.player_2_board
    end
  end

  def find_row_spaces
    end_id = @board.spaces.find_by(name: "#{end_space}").id
    start_id = @board.spaces.find_by(name: "#{start_space}").id
    Space.find((start_id..end_id).to_a)
  end

  def find_column_spaces
    @board.spaces.where("name LIKE ?", "%#{start_space[1]}").order(name: :asc).where("name > '#{start_space[0]}'").limit(2)
  end

  def place_ship(spaces)
    spaces.each do |space|
      space.update(ship: ship)
    end
    if @board.ships.uniq.count == 1
      @message = "Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2."
    else
      @message = "Successfully placed ship with a size of 2. You have 1 ship(s) to place."
    end
  end
end

class InvalidShipPlacement < StandardError
  def initialize(msg = "Invalid ship placement")
    super
  end
end
