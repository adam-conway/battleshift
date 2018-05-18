class Ship < ApplicationRecord
  validates :length, presence: true
  validates :damage, presence: true
  has_many :spaces
end
