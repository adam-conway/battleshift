class BoardSerializer < ActiveModel::Serializer
  alias :read_attribute_for_serialization :send
  attributes :rows

  def rows
    rows = object.spaces.order(:id).pluck(:name).map do |space|
      space.delete(space[1])
    end.uniq

    rows.map do |row|
      RowSerializer.new(object.spaces.order(:id).where("name LIKE ?", "#{row}%")).attributes
    end
  end
end
