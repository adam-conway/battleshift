class BoardGenerator
  def initialize(length)
    @length = length
    @fleet = [2,3]
    @board = Board.create
  end

  def generate
    create_spaces
    @board
  end

  private
    attr_reader :size

    def create_spaces
      space_names.each do |name|
        @board.spaces.create(name: name, status: "Not Attacked")
      end
    end

    def space_names
      get_row_letters.map do |letter|
        get_column_numbers.map do |number|
          letter + number
        end
      end.flatten
    end

    def get_row_letters
      ("A".."Z").to_a.shift(@length)
    end

    def get_column_numbers
      ("1".."26").to_a.shift(@length)
    end
end
