class Space < ApplicationRecord
  validates :status, presence: true
  validates :name, presence: true
  belongs_to :board
  belongs_to :ship, optional: true

end
