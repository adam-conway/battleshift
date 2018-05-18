class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :password, confirmation: { case_sensitive: true }

  has_many :victories, class_name: "Game", foreign_key: "winner_id"
  has_many :player_1_games, class_name: "Game", foreign_key: "player_1_id"
  has_many :player_2_games, class_name: "Game", foreign_key: "player_2_id"
end
