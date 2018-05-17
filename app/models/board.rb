class Board < ApplicationRecord
  has_many :spaces
  has_one :player_1_board, class_name: "Game", foreign_key: "player_1_board_id"
  has_one :player_2_board, class_name: "Game", foreign_key: "player_2_board_id"
  has_many :player_2_games, class_name: "Game", foreign_key: "player_2_id"
end
